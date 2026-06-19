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
      -- Delegate image rendering to image.nvim (Kitty Protocol)
      vim.g.molten_image_provider = "image.nvim"

      -- Show output as virtual text below the cell rather than a split window
      vim.g.molten_virt_text_output = true

      -- Don't auto-open the output window on execution.
      -- Use <leader>jo to view output explicitly.
      vim.g.molten_auto_open_output = false

      -- Maximum height of the floating output window in lines
      vim.g.molten_output_win_max_height = 20

      -- Corrects a 1-line offset in virtual text placement
      vim.g.molten_virt_lines_off_by_1 = true

      -- Use Neovim highlight groups for output window borders
      vim.g.molten_use_border_highlights = true
    end,

    config = function()
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
          map("n", "<leader>ji", ":MoltenInit<CR>", "Jupyter [I]nit kernel")

          -- Cell execution via quarto.runner (understands quarto cell format)
          map("n", "<leader>jr", function()
            require("quarto.runner").run_cell()
          end, "Jupyter [R]un cell")
          map("n", "<leader>jR", function()
            require("quarto.runner").run_all()
          end, "Jupyter [R]un all cells")
          map("v", "<leader>jr", ":<C-u>MoltenEvaluateVisual<CR>", "Jupyter [R]un selection")

          -- Output management
          map("n", "<leader>jo", ":MoltenShowOutput<CR>", "Jupyter [O]utput show")
          map("n", "<leader>jd", ":MoltenDelete<CR>", "Jupyter [D]elete output")

          -- Output persistence (saves to <notebook>.qmd.json alongside the .qmd file)
          map("n", "<leader>js", function()
            vim.cmd("MoltenSave " .. save_path())
          end, "Jupyter [S]ave outputs")
          map("n", "<leader>jl", function()
            vim.cmd("MoltenLoad " .. save_path())
          end, "Jupyter [L]oad outputs")
        end,
      })
    end,
  },
}
