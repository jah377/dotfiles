-- =============================================================================
-- FILE: lua/config/plugins/molten.lua
--
-- PURPOSE:
--   Configures a Jupyter notebook workflow for .qmd (Quarto markdown) files.
--   Combines four plugins to provide:
--     - Cell execution with output rendered inline (text + images)
--     - LSP completions and diagnostics inside {python} code blocks
--     - Kitty Graphics Protocol image rendering (compatible with WezTerm)
--     - .qmd filetype wiring and treesitter integration
--
-- PLUGINS:
--   image.nvim   : Kitty Graphics Protocol backend — renders images inline
--   otter.nvim   : Injects virtual LSP buffers for code blocks in .qmd files
--   quarto-nvim  : .qmd filetype/treesitter wiring + otter.nvim integration
--   molten-nvim  : Jupyter kernel execution with inline output
--
-- WORKFLOW:
--   1. brew install luarocks          (system dependency for optional SVG support)
--   2. In each project venv:
--        pip install pynvim jupyter_client ipykernel
--        python -m ipykernel install --user --name <project-name>
--   3. Open a .qmd file in Neovim
--   4. <leader>ji                     (select and attach a Jupyter kernel)
--   5. <leader>jr                     (execute the cell under cursor)
--
-- KEYMAPS (active only in .qmd buffers):
--   <leader>ji  : Init kernel (select from registered Jupyter kernels)
--   <leader>jr  : Run cell under cursor (normal) / run selection (visual)
--   <leader>jR  : Run all cells in buffer
--   <leader>jo  : Show output window for current cell
--   <leader>jd  : Delete output for current cell
--   <leader>js  : Save outputs to sidecar JSON (persists across sessions)
--   <leader>jl  : Load saved outputs (use after <leader>ji if auto-load fails)
--
-- OUTPUT PERSISTENCE:
--   Outputs are saved to <notebook>.qmd.json alongside the .qmd file.
--   This path is version-controllable — commit it with the notebook.
--   Auto-save: triggers on BufWinLeave for .qmd files
--   Auto-load: triggers 500ms after MoltenInitPost (deferred to ensure kernel ready)
--   If auto-load doesn't fire: <leader>ji then <leader>jl
--
-- NOTES:
--   - WezTerm supports Kitty Graphics Protocol natively (no extra config needed)
--   - image.nvim build=false skips luarocks/magick; PNG/JPG output works without it.
--     SVG support requires: brew install luarocks && luarocks install magick
--   - If .qmd syntax highlighting looks wrong: :TSInstall quarto
--   - Keymaps are buffer-local and do not appear in .py or other file types
--   - Run :checkhealth molten and :checkhealth image to verify setup
--
-- DOCUMENTATION:
--   > molten-nvim  : https://github.com/benlubas/molten-nvim
--   > image.nvim   : https://github.com/3rd/image.nvim
--   > otter.nvim   : https://github.com/jmbuhr/otter.nvim
--   > quarto-nvim  : https://github.com/quarto-dev/quarto-nvim
--
-- =============================================================================

return {
  -- ---------------------------------------------------------------------------
  -- image.nvim: Kitty Graphics Protocol image rendering backend.
  -- Renders matplotlib figures and other image output inline in the buffer.
  -- ---------------------------------------------------------------------------
  {
    "3rd/image.nvim",

    -- build=false skips luarocks/magick installation.
    -- magick is only required for SVG rendering; PNG/JPG works without it.
    build = false,

    -- Only load when opening file types that use inline images
    ft = { "quarto", "markdown" },

    opts = {
      -- Kitty Graphics Protocol: supported natively by WezTerm
      backend = "kitty",

      -- Only render the image nearest the cursor.
      -- Prevents large notebooks from rendering all figures simultaneously.
      only_render_image_at_cursor = true,

      -- Cap image height at 40% of the window to prevent large figures
      -- from pushing other content off screen.
      max_height_window_percentage = 40,

      integrations = {
        markdown = {
          enabled = true,
          -- Activate for both markdown and quarto filetypes
          filetypes = { "markdown", "quarto" },
        },
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- otter.nvim: Injects virtual LSP buffers for embedded code blocks.
  -- Enables pyright completions and diagnostics inside {python} blocks.
  -- Activated automatically by quarto-nvim for .qmd files.
  -- ---------------------------------------------------------------------------
  {
    "jmbuhr/otter.nvim",
    dependencies = { "nvim-treesitter/nvim-treesitter" },
    opts = {},
  },

  -- ---------------------------------------------------------------------------
  -- quarto-nvim: .qmd filetype wiring and otter.nvim integration.
  -- Sets filetype=quarto for .qmd files, configures treesitter injections,
  -- and activates otter.nvim LSP for {python} blocks.
  -- Preview is intentionally not configured.
  -- ---------------------------------------------------------------------------
  {
    "quarto-dev/quarto-nvim",
    ft = "quarto",
    dependencies = {
      "jmbuhr/otter.nvim",
      "nvim-treesitter/nvim-treesitter",
    },
    opts = {
      -- LSP features: activate pyright inside {python} blocks via otter.nvim
      lspFeatures = {
        languages = { "python" },
        chunks = "all",
        diagnostics = {
          enabled = true,
          -- Run diagnostics on save (not on every keystroke)
          triggers = { "BufWritePost" },
        },
        completion = {
          enabled = true,
        },
      },
      -- Cell execution delegates to molten-nvim
      codeRunner = {
        enabled = true,
        default_method = "molten",
      },
    },
  },

  -- ---------------------------------------------------------------------------
  -- molten-nvim: Jupyter kernel integration with inline output rendering.
  -- Connects to a running Jupyter kernel, executes cells, and renders output
  -- (text and images) as virtual text below each cell.
  -- ---------------------------------------------------------------------------
  {
    "benlubas/molten-nvim",
    version = "^1.0.0",

    -- Required: registers molten as a Neovim remote plugin
    build = ":UpdateRemotePlugins",

    dependencies = { "3rd/image.nvim" },

    -- init runs before config and before the plugin loads.
    -- These globals must be set before molten initializes.
    init = function()
      vim.g.molten_image_provider = "image.nvim" -- images behavior weirdly in wezterm
      vim.g.molten_wrap_output = true
      vim.g.molten_virt_text_output = false -- display below cell, not new window
      vim.g.molten_auto_open_output = false -- use <leader>jo explicitly
      vim.g.molten_output_win_max_height = 40
      vim.g.molten_virt_lines_off_by_1 = true
      vim.g.molten_use_border_highlights = true
      vim.g.molten_enter_output_behavior = "open_and_enter"
    end,

    config = function()
      local FENCE_OPEN = "^```{"
      local FENCE_CLOSE = "^```%s*$"

      -- Returns (cell_start, cell_end) as 1-based line numbers, or (nil, nil)
      -- with a warning if the cursor is not inside a valid cell.
      local function find_cell_boundaries(row)
        local lines_above = vim.api.nvim_buf_get_lines(0, 0, row, false)
        local cell_start = nil
        for i = #lines_above, 1, -1 do
          if lines_above[i]:match(FENCE_OPEN) then
            cell_start = i
            break
          end
        end

        if not cell_start then
          vim.notify("Not inside a code cell", vim.log.levels.WARN)
          return nil, nil
        end

        local lines_below = vim.api.nvim_buf_get_lines(0, cell_start, -1, false)
        local cell_end = nil
        for i, line in ipairs(lines_below) do
          if line:match(FENCE_CLOSE) then
            cell_end = cell_start + i
            break
          end
        end

        if not cell_end then
          vim.notify("Could not find end of code cell", vim.log.levels.WARN)
          return nil, nil
        end

        return cell_start, cell_end
      end

      local function toggle_notebook_format()
        local curr_file = vim.fn.expand "%p"
        local qmd_path = curr_file:gsub("%.ipynb$", ".qmd")
        local ipynb_path = curr_file:gsub("%.qmd$", ".ipynb")

        if curr_file == qmd_path then
          vim.fn.system("quarto convert " .. qmd_path .. " --output " .. ipynb_path)
          vim.notify("Converted to .ipynb", vim.log.levels.INFO)
        elseif curr_file == ipynb_path then
          vim.fn.system("quarto convert " .. ipynb_path .. " --output " .. qmd_path)
          vim.notify("Converted to .qmd", vim.log.levels.INFO)
        else
          error "Current file must be a .qmd or .ipynb file"
        end
      end
      vim.keymap.set("n", "<leader>Q", toggle_notebook_format, { desc = "[Q]uarto convert" })

      -- Searches from the line after the cursor so the current fence is never re-matched.
      local function goto_next_cell()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_get_lines(0, row, -1, false)
        for i, line in ipairs(lines) do
          if line:match(FENCE_OPEN) then
            vim.api.nvim_win_set_cursor(0, { row + i + 1, 0 })
            return
          end
        end
        vim.notify("No next cell", vim.log.levels.WARN)
      end

      -- Two-pass: pass 1 skips the current cell's opening fence, pass 2 finds the one before it.
      local function goto_prev_cell()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local lines = vim.api.nvim_buf_get_lines(0, 0, row - 1, false)

        local search_end = #lines
        for i = #lines, 1, -1 do
          if lines[i]:match(FENCE_OPEN) then
            search_end = i - 1
            break
          end
        end

        for i = search_end, 1, -1 do
          if lines[i]:match(FENCE_OPEN) then
            vim.api.nvim_win_set_cursor(0, { i + 1, 0 })
            return
          end
        end
        vim.notify("No previous cell", vim.log.levels.WARN)
      end

      local function select_cell_contents()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local cell_start, cell_end = find_cell_boundaries(row)
        if not cell_start then return end

        local content_start = cell_start + 1
        local content_end = cell_end - 1

        if content_start > content_end then
          vim.notify("Code cell is empty", vim.log.levels.WARN)
          return
        end

        vim.api.nvim_win_set_cursor(0, { content_start, 0 })
        vim.cmd "normal! V"
        vim.api.nvim_win_set_cursor(0, { content_end, 0 })
      end

      local function delete_current_cell_contents()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local cell_start, cell_end = find_cell_boundaries(row)
        if not cell_start then return end

        vim.api.nvim_buf_set_lines(0, cell_start, cell_end - 1, false, { "" })
        vim.api.nvim_win_set_cursor(0, { cell_start + 1, 0 })
      end

      local function delete_current_cell()
        local row = vim.api.nvim_win_get_cursor(0)[1]
        local cell_start, cell_end = find_cell_boundaries(row)
        if not cell_start then return end

        vim.api.nvim_buf_set_lines(0, cell_start - 1, cell_end, false, {})
      end

      -- Register <leader>j keymaps as buffer-local for .qmd files only.
      -- FileType autocmd (not BufEnter) sets keymaps once per buffer and
      -- fires after quarto-nvim assigns filetype=quarto to .qmd files.
      vim.api.nvim_create_autocmd("FileType", {
        pattern = "quarto",
        group = vim.api.nvim_create_augroup("molten-keymaps", { clear = true }),
        callback = function()
          local opts = { buffer = true, silent = true }
          local map = function(modes, lhs, rhs, desc)
            vim.keymap.set(modes, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
          end

          -- Kernel management
          map("n", "<leader>ji", ":MoltenInit<CR>", "[J]upyter [I]nit kernel")
          map("n", "<leader>jI", ":MoltenDeinit<CR>", "[J]upyter De[I]nit kernel")

          -- Cell execution via quarto.runner (understands quarto cell format)
          map("n", "<leader>jr", function()
            require("quarto.runner").run_cell()
          end, "[J]upyter [R]un cell")
          map("n", "<leader>jR", function()
            require("quarto.runner").run_all()
          end, "[J]upyter [R]un all cells")

          -- Cell navigation
          map("n", "<leader>jn", goto_next_cell, "[J]upyter [N]ext cell")
          map("n", "<leader>jp", goto_prev_cell, "[J]upyter [P]rev cell")
          map("n", "<leader>jd", delete_current_cell_contents, "[J]upyter [D]elete cell contents")
          map("n", "<leader>jD", delete_current_cell, "[J]upyter [D]elete cell")
          map("n", "<leader>jv", select_cell_contents, "[J]upyter [V]isual select cell")

          -- Output management
          map("n", "<leader>jo", ":noautocmd MoltenEnterOutput<CR>", "[J]upyter enter [O]utput")
          map("n", "<leader>jO", ":noautocmd MoltenImagePopup<CR>", "[J]upyter Image P[O]pup")
          map("n", "<leader>jh", ":MoltenHideOutput<CR>", "[J]upyter [H]ide output")
        end,
      })
    end,
  },
}
