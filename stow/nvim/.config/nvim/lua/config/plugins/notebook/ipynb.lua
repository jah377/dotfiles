-- =============================================================================
-- FILE: lua/config/plugins/notebook/ipynb.lua
--
-- PURPOSE:
--   Edit .ipynb files directly as notebooks (modal: Notebook mode / Cell mode)
--   with Jupyter kernel execution and inline outputs.
--
-- WORKFLOW:
--   1. In each project venv: pip install jupyter_client ipykernel
--   2. nvim notebook.ipynb     (kernel auto-starts if a venv is found)
--   3. <leader>ks  : Start kernel manually (e.g. notebook outside any venv)
--   4. <leader>kx  : Execute cell
--
-- KERNEL AUTO-START:
--   Python is discovered per notebook: the plugin walks up from the
--   notebook's dir for a .venv (also venv, .virtualenv, env), then falls back
--   to system python3. Auto-start only runs when a venv is found, so notebooks
--   outside a project don't error against a python3 without jupyter_client.
--   `kernel.auto_connect` exists in the plugin's config but is never read, so
--   this is done with a BufReadCmd autocmd instead. BufReadCmd, not FileType:
--   filetype=ipynb is set before the notebook state and the buffer-local
--   :NotebookKernelStart command exist. Registered after setup(), so it runs
--   after the plugin's own BufReadCmd handler has opened the notebook.
--
-- NOTES:
--   - Not lazy-loaded by ft: the plugin claims *.ipynb via BufReadCmd in
--     setup() and sets filetype=ipynb itself, so ft="ipynb" would never fire
--   - Images use the snacks.image API directly; snacks `image.enabled = false`
--     only disables snacks' own autocmds, so image.nvim still owns md/quarto
--   - Inline images need Unicode placeholders (kitty, Ghostty); WezTerm lacks
--     them, so image outputs are skipped there
--   - Run :checkhealth ipynb to verify setup
--
-- DOCUMENTATION:
--   > ipynb.nvim : https://github.com/ajbucci/ipynb.nvim
--
-- =============================================================================

return {
  "ajbucci/ipynb.nvim",
  lazy = false,
  dependencies = {
    "nvim-treesitter/nvim-treesitter",
    "neovim/nvim-lspconfig",
  },
  opts = {},
  config = function(_, opts)
    require("ipynb").setup(opts)

    vim.api.nvim_create_autocmd("BufReadCmd", {
      group = vim.api.nvim_create_augroup("ipynb-kernel-autostart", { clear = true }),
      pattern = "*.ipynb",
      callback = function(ev)
        -- Skip nb:// picker previews, matching the plugin's own handler
        if ev.file:match "^%w+://" then return end

        local _, source = require("ipynb.kernel").get_python_info(ev.file)
        if source ~= "venv" then return end

        vim.schedule(function()
          if not vim.api.nvim_buf_is_valid(ev.buf) then return end
          if not vim.api.nvim_buf_get_commands(ev.buf, {}).NotebookKernelStart then return end
          vim.api.nvim_buf_call(ev.buf, function()
            vim.cmd.NotebookKernelStart()
          end)
        end)
      end,
    })
  end,
}
