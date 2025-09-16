return {
	"nvim-telescope/telescope.nvim",
	event = "VimEnter",
	tag = "0.1.8",
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
		{ "nvim-telescope/telescope-ui-select.nvim" },
		-- Useful for getting pretty icons, but requires a Nerd Font.
		{ "nvim-tree/nvim-web-devicons", enabled = vim.g.have_nerd_font },
	},
	config = function()
		-- See `:help telescope` and `:help telescope.setup()`
		require("telescope").setup({
			extensions = {
				["ui-select"] = {
					require("telescope.themes").get_dropdown(),
				},
			},
		})

		-- Enable Telescope extensions if they are installed
		pcall(require("telescope").load_extension, "fzf")
		pcall(require("telescope").load_extension, "ui-select")

		-- See `:help telescope.builtin`
		local builtin = require("telescope.builtin")
		vim.keymap.set("n", "<leader>fh", builtin.help_tags, { desc = "[F]ind [H]elp" })
		vim.keymap.set("n", "<leader>fm", builtin.man_pages, { desc = "[F]ind [H]elp" })
		vim.keymap.set("n", "<leader>fk", builtin.keymaps, { desc = "[F]ind [K]eymaps" })
		vim.keymap.set("n", "<leader>fd", builtin.diagnostics, { desc = "[F]ind [D]iagnostics" })
		vim.keymap.set("n", "<leader>fb", builtin.buffers, { desc = "[F]ind open [B]uffers" })
		vim.keymap.set("n", "<leader>fp", builtin.git_files, { desc = "[F]ind git [P]roject files" })
		vim.keymap.set("n", "<leader>ft", builtin.treesitter, { desc = "[F]ind [T]reesitter" })
		vim.keymap.set("n", "<leader>fr", builtin.resume, { desc = "[F]ind [R]esume search" })
		vim.keymap.set("n", "<leader>fz", builtin.current_buffer_fuzzy_find, { desc = "[F]ind fuz[Z]y in buffer" })

		-- Search files, including hidden
		vim.keymap.set("n", "<leader>ff", function()
			builtin.find_files({ hidden = true })
		end, { desc = "[F]ind directory [F]iles" })

		vim.keymap.set("n", "<leader>fc", function()
			builtin.find_files({ cwd = "~/dotfiles/", hidden = true })
		end, { desc = "[F]ind [C]onfig files" })

		-- Search lazy package files
		vim.keymap.set("n", "<space>fl", function()
			builtin.find_files({ cwd = vim.fs.joinpath(vim.fn.stdpath("data"), "lazy") })
		end, { desc = "[F]ind [L]azy files" })

		-- Search using grep
		vim.keymap.set("n", "<leader>fgs", builtin.grep_string, { desc = "[F]ind [G]rep for [S]tring" })
		vim.keymap.set("n", "<leader>fgd", function()
			builtin.live_grep({ grep_open_files = false, prompt_title = "Live Grep in Directory" })
		end, { desc = "[F]ind [G]rep for [D]irectory files" })
		vim.keymap.set("n", "<leader>fgo", function()
			builtin.live_grep({ grep_open_files = true, prompt_title = "Live Grep in Open Files" })
		end, { desc = "[F]ind [G]rep for [O]pen files" })
	end,
}
