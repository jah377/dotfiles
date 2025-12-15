return {
  {
    -- "mfussenegger/nvim-lint",
    -- event = { "BufReadPre", "BufNewFile" },
    -- config = function()
    --   local lint = require("lint")
    --   lint.linters_by_ft = {
    --     lua = { "selene" },
    --     python = { "ruff", "pydocstyle", "vulture" },
    --     markdown = { "markdownlint", "vale" },
    --   }
    --
    --   local lint_augroup = vim.api.nvim_create_augroup("lint", { clear = true })
    --   vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "TextChanged", "InsertLeave" }, {
    --     group = lint_augroup,
    --     callback = function()
    --       lint.try_lint()
    --     end,
    --   })
    -- end,
  },
}
