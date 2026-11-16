-- ============================================================================
-- FILE: lua/config/plugins/notes/obsidian.lua
--
-- SUMMARY:
--   obsidian.nvim for the local zettelkasten vault.
--
-- WORKFLOW:
--  Notes are created -> reviewed -> organized
--
--  1. Create a note in the inbox
--    >> `on "{{name}}"` -- see `stow/local/.local/scripts/on`
--
--  2. Fill in the new file
--    >> `<leader>on`   -- insert the note template (front matter)
--    >> Add tag        -- later used to re-file the note
--    >> Add url        -- optional
--    >> Add [[hub]]    -- .md file auto-populates with linked files
--    >> `<leader>ot`   -- format the title from the file name
--
--  3. Review notes at the end of the week
--    >> `or`           -- see `stow/local/.local/scripts/or`
--    >> `<leader>odd`  -- delete the note file
--    >> `<leader>ok`   -- keep: move the file to the reviewed directory
--
--  4. Refile kept notes to a tag-specific directory
--    >> `og`           -- see `stow/local/.local/scripts/og`
--
-- LOADING:
--   Loaded for markdown and quarto buffers (inbox notes are .qmd, see the
--   `or` shell function), or earlier by the two global keys that search the
--   vault from anywhere. It used to be a priority-1000 start plugin, which
--   dragged fff and telescope into the earliest startup phase.
--
-- ENVIRONMENT:
--   ZK_DIR, ZK_INBOX_DIR, ZK_REVIEWED_DIR are exported by stow/zsh/.zshenv.
--   They are validated in one place (vault_paths) so a missing variable is
--   reported by name instead of as an obscure error from the first keymap.
--
-- DOCUMENTATION:
--   > GitHub : https://github.com/obsidian-nvim/obsidian.nvim
-- ============================================================================

local REQUIRED_ENV = { "ZK_DIR", "ZK_INBOX_DIR", "ZK_REVIEWED_DIR" }

--- Read the ZK_* environment variables, notifying about any that are unset.
--- @return { dir: string, inbox: string, reviewed: string }|nil
local function vault_paths()
    local missing = {}
    for _, name in ipairs(REQUIRED_ENV) do
        local value = vim.env[name]
        if not value or value == "" then missing[#missing + 1] = name end
    end
    if #missing > 0 then
        vim.notify("obsidian: unset environment variables: " .. table.concat(missing, ", ") .. " (see stow/zsh/.zshenv)", vim.log.levels.ERROR)
        return nil
    end
    return {
        dir = vim.env.ZK_DIR,
        inbox = vim.env.ZK_INBOX_DIR,
        reviewed = vim.env.ZK_REVIEWED_DIR,
    }
end

return {
    "obsidian-nvim/obsidian.nvim",
    ft = { "markdown", "quarto" },
    dependencies = { "dmtrKovalenko/fff.nvim" },

    -- Vault-wide search works from any buffer, so these two keys also load
    -- the plugin.
    keys = {
        {
            "<leader>of",
            function()
                local vault = vault_paths()
                if vault then require("fff").find_files_in_dir(vault.dir) end
            end,
            desc = "[O]bsidian [F]ind file",
        },
        {
            "<leader>og",
            function()
                local vault = vault_paths()
                if vault then require("fff").live_grep({ cwd = vault.dir }) end
            end,
            desc = "[O]bsidian live [G]rep",
        },
    },

    config = function()
        local vault = vault_paths()
        if not vault then return end -- already notified; nothing below can work

        -- notes_subdir is joined onto the workspace path by obsidian.nvim, so
        -- it must be relative. ZK_INBOX_DIR is absolute; relpath() turns
        -- "<vault>/inbox" into "inbox" (nil, and so no subdir, if the inbox
        -- ever moves outside the vault). The earlier revision passed the
        -- absolute path, which obsidian would have appended to the vault path.
        local notes_subdir = vim.fs.relpath(vault.dir, vault.inbox)

        require("obsidian").setup({
            legacy_commands = false, -- to be removed in 4.0.0
            workspaces = { { name = "zettelkasten", path = vault.dir } },
            notes_subdir = notes_subdir,
            new_notes_location = "notes_subdir",
            templates = { folder = "templates" }, -- workspace subdir name
            ui = { enable = false }, -- render-markdown.nvim handles markdown UI
            link = { auto_update = true },
            frontmatter = { enabled = false }, -- templates provide the front matter
        })

        -- Insert the note template, then drop blank lines it leaves at the top
        vim.keymap.set("n", "<leader>on", function()
            vim.cmd("Obsidian template note")
            local first_content_line = vim.fn.nextnonblank(1)
            if first_content_line > 1 then vim.api.nvim_buf_set_lines(0, 0, first_content_line - 1, false, {}) end
        end, { desc = "[O]bsidian [N]ote from template" })

        -- Title line "key: 20240101__some-title" -> "key: some title".
        -- The cursor must be on the title line. The `e` flags stop :s from
        -- raising E486 when a pattern has nothing to replace.
        vim.keymap.set("n", "<leader>ot", ":s/\\(: \\)[0-9]\\{8}__*/\\1/e | s/[-_]/ /ge<CR>", { desc = "[O]bsidian format note [T]itle" })

        -- Keep: move the note from the inbox to the review queue. Refuse while
        -- the buffer is modified, otherwise the file moves and :bdelete then
        -- fails, leaving the buffer pointing at a path that no longer exists.
        vim.keymap.set("n", "<leader>ok", function()
            if vim.bo.modified then
                vim.notify("Save the note before keeping it", vim.log.levels.WARN)
                return
            end
            local current_file = vim.fn.expand("%:p")
            local target_file = vim.fs.joinpath(vault.reviewed, vim.fn.fnamemodify(current_file, ":t"))
            if vim.fn.rename(current_file, target_file) ~= 0 then
                vim.notify("Could not move note to " .. vault.reviewed, vim.log.levels.WARN)
                return
            end
            vim.cmd("bdelete")
        end, { desc = "[O]bsidian [K]eep note" })

        -- Delete the current note file. Two `d`s so it cannot be hit by accident.
        -- bdelete! because unsaved changes are moot once the file is gone.
        vim.keymap.set("n", "<leader>odd", function()
            local current_file = vim.fn.expand("%:p")
            if vim.fn.delete(current_file) ~= 0 then
                vim.notify("Could not delete note " .. current_file, vim.log.levels.WARN)
                return
            end
            vim.cmd("bdelete!")
        end, { desc = "[O]bsidian [D]elete note" })

        -- Obsidian's note-aware commands for links and headings
        vim.keymap.set("n", "<leader>oo", "<cmd>Obsidian follow_link<CR>", { desc = "[O]bsidian [O]pen link" })
        vim.keymap.set("n", "<leader>oh", "<cmd>Obsidian toc<CR>", { desc = "[O]bsidian find [H]eaders" })
        vim.keymap.set("n", "<leader>ob", "<cmd>Obsidian backlinks<CR>", { desc = "[O]bsidian [B]acklinks" })
    end,
}
