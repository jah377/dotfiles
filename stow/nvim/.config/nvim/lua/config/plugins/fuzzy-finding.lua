-- =============================================================================
-- FILE: lua/config/plugins/fuzzy-finding.lua
-- Fuzzy finder and file search.
--
-- telescope.nvim and fff.nvim are declared as independent specs so that
-- telescope fully initialises before fff patches its picker internals. fff is
-- a start plugin (its file index warms in the background) and lists telescope
-- as a dependency, so telescope is loaded at startup through that chain and
-- needs no event of its own.
--
-- DOCUMENTATION:
--  > Github : https://github.com/nvim-telescope/telescope.nvim
--  > Github : https://github.com/dmtrKovalenko/fff.nvim
--  > :help telescope
--  > :help telescope.builtin
-- =============================================================================

local paths = require("config.lib.paths")

local telescope_spec = {
    "nvim-telescope/telescope.nvim",
    dependencies = {
        "nvim-lua/plenary.nvim",
        { "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
        "nvim-telescope/telescope-ui-select.nvim",
        { "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
        "crispgm/telescope-heading.nvim",
    },
    config = function()
        local telescope = require("telescope")
        telescope.setup({
            extensions = { ["ui-select"] = { require("telescope.themes").get_dropdown() } },
        })

        -- Extensions are optional: a failed fzf-native build must not break
        -- every picker, but it should be visible rather than swallowed.
        for _, extension in ipairs({ "fzf", "ui-select", "heading" }) do
            local ok, err = pcall(telescope.load_extension, extension)
            if not ok then vim.notify("telescope: could not load extension " .. extension .. ": " .. tostring(err), vim.log.levels.WARN) end
        end

        local builtin = require("telescope.builtin")

        --- Wrap a picker so <CR> opens the selection in a vertical split.
        --- @param picker fun(opts: table)
        --- @return fun()
        local function open_vertical(picker)
            return function()
                local actions = require("telescope.actions")
                picker({
                    attach_mappings = function(_, map)
                        map("i", "<CR>", actions.select_vertical)
                        map("n", "<CR>", actions.select_vertical)
                        return true
                    end,
                })
            end
        end

        vim.keymap.set("n", "<leader>fh", open_vertical(builtin.help_tags), { desc = "Find Help" })
        vim.keymap.set("n", "<leader>fm", open_vertical(builtin.man_pages), { desc = "Find Man-Pages" })
        vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "Find Keymaps" })
        vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "Find Diagnostics" })
        vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "Find Buffers" })
        vim.keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "Find Treesitter Objects" })
        vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "Resume Search" })
        vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "Fuzzy Find in Buffer" })
        vim.keymap.set("n", "<leader>fL", function() builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") }) end, { desc = "Find Lazy Plugin Files" })
        vim.keymap.set("n", "<leader>fF", function() builtin.find_files({ no_ignore = true, hidden = true }) end, { desc = "Find All Files (incl. ignored)" })
        vim.keymap.set("n", "<leader>mh", "<cmd>Telescope heading<CR>", { desc = "[M]arkdown [H]eadings" })
    end,
}

local fff_spec = {
    "dmtrKovalenko/fff.nvim",
    dependencies = { "nvim-telescope/telescope.nvim" },
    build = function() require("fff.download").download_or_build_binary() end,
    lazy = false, -- start plugin: the background file index is ready before the first search
    opts = {},
    config = function(_, opts)
        local fff = require("fff")
        fff.setup(opts)

        vim.keymap.set("n", "<leader>ff", fff.find_files, { desc = "FFFind files" })
        -- The dotfiles root is derived from the stow symlink (config.lib.paths)
        -- rather than hard-coded, so the map works wherever the repo lives.
        vim.keymap.set("n", "<leader>fc", function() fff.find_files_in_dir(paths.dotfiles_root()) end, { desc = "FFFind Config Files" })
        vim.keymap.set("n", "<leader>fg", fff.live_grep, { desc = "FFFind live grep" })
        vim.keymap.set("n", "<leader>fw", function() fff.live_grep({ query = vim.fn.expand("<cword>") }) end, { desc = "FFFind current word" })
    end,
}

return { telescope_spec, fff_spec }
