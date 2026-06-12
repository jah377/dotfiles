-- ============================================================================
-- FILE: lua/config/plugins/obsidian.lua
--
-- SUMMARY:
--   Obsidian.nvim integration for the local zettelkasten vault.
--
-- WORKFLOW:
--  Notes are created -> reviewed -> organized
--
--  1. Creating a new note in tmp directory
--    >>`on "{{name}}"` -- See `stow/local/.local/scripts/on`
--
--  2. Add notes to newly created file
--    >> `<leader>on`   -- add front-matter
--    >> Add tag        -- later used to re-file note
--    >> Add url        -- optional
--    >> Add [[hub]]    -- .md file auto-populates with linked files
--    >> `<leader>of`   -- format title from file name
--
--  3. Review notes at end of week
--    >> `or`           -- see `stow/local/.local/scripts/or`
--    >> `<leader>od`   -- delete tmp note file
--    >> `<leader>ok`   -- keep file; file moved to `keep/` subdir
--
--  4. Refile kept notes to [tag]-specific subdir
--    >> `og`           -- see `stow/local/.local/scripts/og`
--
-- DOCUMENTATION:
--   > GitHub        : https://github.com/obsidian-nvim/obsidian.nvim
--
-- ============================================================================

return {
  "obsidian-nvim/obsidian.nvim",

  -- Load early so note commands are available during normal editing.
  priority = 1000,

  dependencies = {
    { "dmtrKovalenko/fff.nvim", opts = {} },
  },
  config = function()
    require("obsidian").setup({
      legacy_commands = false, -- to be removed in 4.0.0
      workspaces = { { name = "zettelkasten", path = "~/zettelkasten" } },
      notes_subdir = "tmp_notes", -- workspace subdir name
      new_notes_location = "notes_subdir", -- use `new_notes_location`
      templates = { folder = "templates" }, -- workspace subdir name
      completion = { nvim_cmp = true, min_chars = 2 },
      ui = { enable = false }, -- render-markdown.nvim handles all markdown UI
      link = { auto_update = true }, -- automatically update links
      disable_frontmatter = true, -- use templates instead
    })

    local fff = require("fff")
    local kbd = vim.keymap.set

    -- Insert the note template and remove leading blank lines it may leave behind.
    kbd("n", "<leader>on", function()
      vim.cmd("Obsidian template note")

      local first_content_line = vim.fn.nextnonblank(1)
      if first_content_line > 1 then
        vim.api.nvim_buf_set_lines(0, 0, first_content_line - 1, false, {})
      end
    end, { desc = "[O]bsidian [N]ote from template" })

    -- Strip date from note title and replace dashes with spaces.
    -- Must have cursor on title for keybinding to work.
    kbd(
      "n",
      "<leader>ot",
      ":s/\\(# \\)[0-9]\\{8}__*/\\1/ | s/[-_]/ /g<cr>",
      { desc = "[O]bsidian format note [T]itle" }
    )

    -- Search note files in workspace
    kbd("n", "<leader>of", function()
      fff.find_files_in_dir("~/zettelkasten")
    end, { desc = "[O]bsidian [F]ind file" })

    kbd("n", "<leader>og", function()
      fff.live_grep({ cwd = "~/zettelkasten" })
    end, { desc = "[O]bsidian live [G]rep" })

    -- Keep note file; move from the capture directory to the review queue.
    kbd("n", "<leader>ok", function()
      local current_file = vim.fn.expand("%:p")
      local target_dir = vim.fn.expand("~/zettelkasten/keep")
      local target_file = vim.fs.joinpath(target_dir, vim.fn.fnamemodify(current_file, ":t"))

      if vim.fn.rename(current_file, target_file) == 0 then
        vim.cmd("bd")
      else
        vim.notify("Could not move note to " .. target_dir, vim.log.levels.WARN)
      end
    end, { desc = "[O]bsidian [K]eep note" })

    -- Delete current note file
    kbd("n", "<leader>odd", function()
      local current_file = vim.fn.expand("%:p")

      if vim.fn.delete(current_file) == 0 then
        vim.cmd("bd")
      else
        vim.notify("Could not delete note " .. current_file, vim.log.levels.WARN)
      end
    end, { desc = "[O]bsidian [D]elete note" })

    -- Use Obsidian's note-aware commands for links and tasks.
    kbd("n", "<leader>oo", "<cmd>Obsidian follow_link<cr>", { desc = "[O]bsidian [O]pen link" })
    kbd("n", "<leader>oc", "<cmd>Obsidian toggle_checkbox<cr>", { desc = "[O]bsidian toggle [C]heckbox" })
    kbd("n", "<leader>oh", "<cmd>Obsidian toc<cr>", { desc = "[O]bsidian find [H]eaders" })
  end,
}
