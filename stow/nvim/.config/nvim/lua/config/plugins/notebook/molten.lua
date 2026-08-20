-- =============================================================================
-- FILE: lua/config/plugins/notebook/molten.lua
--
-- PURPOSE:
--   Jupyter kernel execution with inline output for .qmd (Quarto) files.
--   Cell keymaps call config.plugins.custom.quarto_extras.
--   Image rendering is owned by notes/image.lua. This spec is ft=quarto so
--   molten (and its image.nvim dependency) are not start plugins.
--
-- WORKFLOW:
--   1. In each project venv:
--        pip install pynvim jupyter_client ipykernel
--        python -m ipykernel install --user --name <project-name>
--   2. Open a .qmd file in Neovim
--   3. <leader>ji                     (select and attach a Jupyter kernel)
--   4. <leader>jr                     (execute the cell under cursor)
--
-- KEYMAPS (active only in .qmd buffers):
--   Kernel management:
--     <leader>ji  : Init kernel (select from registered Jupyter kernels)
--     <leader>jI  : Restart kernel (clears all outputs)
--     <leader>jx  : Kill kernel (shutdown)
--   Cell execution:
--     <leader>jr  : Run cell under cursor
--     <leader>jR  : Run all cells in buffer
--     <leader>je  : Run cell and advance to next (creates cell if at end)
--   Cell creation:
--     <leader>ja  : Insert cell above current cell
--     <leader>jb  : Insert cell below current cell
--   Cell navigation:
--     <leader>jn  : Jump to next cell
--     <leader>jp  : Jump to previous cell
--     <leader>jv  : Visual select cell contents
--     <leader>jd  : Delete cell contents (keep fences)
--     <leader>jD  : Delete entire cell (fences + contents)
--     <leader>jl  : Replace cell language
--   Output management:
--     <leader>jo  : Enter output window for current cell
--     <leader>jO  : Image popup for current cell
--     <leader>jh  : Hide output for current cell
--
-- NOTES:
--   - Keymaps are buffer-local (ev.buf / already-open quarto buffers) and
--     do not appear in .py or other file types
--   - Run :checkhealth molten to verify the remote plugin
--
-- DOCUMENTATION:
--   > molten-nvim  : https://github.com/benlubas/molten-nvim
--
-- =============================================================================

return {
  "benlubas/molten-nvim",
  version = "^1.0.0",
  ft = "quarto",

  -- Required: registers molten as a Neovim remote plugin
  build = ":UpdateRemotePlugins",

  dependencies = { "3rd/image.nvim" },

  -- init runs before config and before the plugin loads.
  -- These globals must be set before molten initializes.
  init = function()
    vim.g.molten_image_provider = "image.nvim" -- use image.nvim for inline image rendering
    vim.g.molten_wrap_output = true
    vim.g.molten_virt_text_output = false -- disabled; weird behavior with plots
    vim.g.molten_auto_open_output = false -- use <leader>jo explicitly
    vim.g.molten_output_win_max_height = 40
    vim.g.molten_virt_lines_off_by_1 = true
    vim.g.molten_use_border_highlights = true
    vim.g.molten_enter_output_behavior = "open_and_enter"
  end,

  config = function()
    local quarto_extras = require "config.plugins.custom.quarto_extras"
    local lazy_ft = require "config.plugins.custom.lazy_ft"

    -- buffer = bufnr, not { buffer = true }: FileType can fire for a
    -- non-current quarto buffer (nvim a.qmd b.qmd, a split).
    local function set_keymaps(bufnr)
      local opts = { buffer = bufnr, silent = true }
      local map = function(modes, lhs, rhs, desc)
        vim.keymap.set(modes, lhs, rhs, vim.tbl_extend("force", opts, { desc = desc }))
      end

      -- Kernel management
      map("n", "<leader>ji", ":MoltenInit<CR>", "[J]upyter [I]nit kernel")
      map("n", "<leader>jI", quarto_extras.restart_kernel, "[J]upyter re[I]nit kernel")
      map("n", "<leader>jx", ":MoltenDeinit<CR>", "[J]upyter e[X]it kernel")

      -- Cell execution via quarto.runner (understands quarto cell format)
      map("n", "<leader>jr", function()
        require("quarto.runner").run_cell()
      end, "[J]upyter [R]un cell")
      map("n", "<leader>jR", function()
        require("quarto.runner").run_all()
      end, "[J]upyter [R]un all cells")
      map("n", "<leader>je", quarto_extras.run_cell_and_advance, "[J]upyter [E]xecute cell & advance")

      -- Cell creation
      map("n", "<leader>ja", quarto_extras.insert_cell_above, "[J]upyter insert cell [A]bove")
      map("n", "<leader>jb", quarto_extras.insert_cell_below, "[J]upyter insert cell [B]elow")

      -- Cell navigation
      map("n", "<leader>jn", quarto_extras.goto_next_cell, "[J]upyter [N]ext cell")
      map("n", "<leader>jp", quarto_extras.goto_prev_cell, "[J]upyter [P]rev cell")
      map("n", "<leader>jd", quarto_extras.delete_current_cell_contents, "[J]upyter [D]elete cell contents")
      map("n", "<leader>jD", quarto_extras.delete_current_cell, "[J]upyter [D]elete cell")
      map("n", "<leader>jv", quarto_extras.select_cell_contents, "[J]upyter [V]isual select cell")
      map("n", "<leader>jl", quarto_extras.replace_block_lang, "[J]upyter replace cell [L]anguage")

      -- Output management
      map("n", "<leader>jo", ":noautocmd MoltenEnterOutput<CR>", "[J]upyter enter [O]utput")
      map("n", "<leader>jO", ":noautocmd MoltenImagePopup<CR>", "[J]upyter Image P[O]pup")
      map("n", "<leader>jh", ":MoltenHideOutput<CR>", "[J]upyter [H]ide output")
    end

    lazy_ft.on_filetypes("molten-keymaps", "quarto", set_keymaps)
  end,
}
