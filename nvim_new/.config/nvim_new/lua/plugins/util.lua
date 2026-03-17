return {
	{ "nvim-lua/plenary.nvim", lazy = true },
	{ "tpope/vim-repeat", event = "VeryLazy" },

	-- Central utility hub: picker, notifier, dashboard, indent, words, zen, etc.
	{
		"folke/snacks.nvim",
		priority = 1000,
		lazy = false,
		opts = {
			bigfile = { enabled = true },
			dashboard = {
				enabled = true,
				preset = {
					header = [[
      ╭╮╭┬─╮╭─╮┬  ┬┬╭┬╮
      │││├┤ │ │╰┐┌╯││││
      ╯╰╯╰─╯╰─╯ ╰╯ ┴┴ ┴

         ༼ つ ◕_◕ ༽つ

      ]],
				},
			},
			dim = {
				enabled = true,
				scope = { min_size = 5, max_size = 20, siblings = true },
				filter = function(buf)
					return vim.g.snacks_dim ~= false and vim.b[buf].snacks_dim ~= false and vim.bo[buf].buftype == ""
				end,
			},
			indent = {
				enabled = true,
				indent = { hl = "IndentBlanklineChar" },
				scope = { hl = "LineNr" },
				filter = function(buf)
					return vim.g.snacks_indent ~= false
						and vim.b[buf].snacks_indent ~= false
						and vim.bo[buf].buftype == ""
				end,
			},
			input = { enabled = true },
			notifier = { enabled = true, timeout = 3000 },
			picker = { enabled = true, matcher = { frecency = true } },
			quickfile = { enabled = true },
			statuscolumn = { enabled = true },
			words = { enabled = true },
			zen = { enabled = true },
		},
		keys = {
			-- Files & search (replaces telescope)
			{
				"<leader><space>",
				function()
					Snacks.picker.smart()
				end,
				desc = "Smart find files",
			},
			{
				"<leader>ff",
				function()
					Snacks.picker.files()
				end,
				desc = "Find files",
			},
			{
				"<leader>fo",
				function()
					Snacks.picker.recent()
				end,
				desc = "Recent files",
			},
			{
				"<leader>fb",
				function()
					Snacks.picker.buffers()
				end,
				desc = "Buffers",
			},
			{
				"<leader>fg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>sg",
				function()
					Snacks.picker.grep()
				end,
				desc = "Grep",
			},
			{
				"<leader>sw",
				function()
					Snacks.picker.grep_word()
				end,
				mode = { "n", "x" },
				desc = "Grep word",
			},
			{
				"<leader>fh",
				function()
					Snacks.picker.help()
				end,
				desc = "Help pages",
			},
			{
				"<leader>sk",
				function()
					Snacks.picker.keymaps()
				end,
				desc = "Keymaps",
			},
			{
				"<leader>sc",
				function()
					Snacks.picker.command_history()
				end,
				desc = "Command history",
			},
			{
				"<leader>sC",
				function()
					Snacks.picker.commands()
				end,
				desc = "Commands",
			},
			{
				"<leader>sd",
				function()
					Snacks.picker.diagnostics()
				end,
				desc = "Diagnostics",
			},
			{
				"<leader>sm",
				function()
					Snacks.picker.marks()
				end,
				desc = "Marks",
			},
			{
				"<leader>sH",
				function()
					Snacks.picker.highlights()
				end,
				desc = "Highlights",
			},
			{
				"<leader>sr",
				function()
					Snacks.picker.resume()
				end,
				desc = "Resume last picker",
			},
			{
				"<leader>tw",
				function()
					vim.ui.input({ prompt = "Grep in directory: ", completion = "dir" }, function(dir)
						if dir and dir ~= "" then
							Snacks.picker.grep({ cwd = vim.fn.expand(dir) })
						end
					end)
				end,
				desc = "Grep in directory",
			},

			-- Git via picker
			{
				"<leader>gb",
				function()
					Snacks.picker.git_branches()
				end,
				desc = "Git branches",
			},
			{
				"<leader>gl",
				function()
					Snacks.picker.git_log()
				end,
				desc = "Git log",
			},
			{
				"<leader>gs",
				function()
					Snacks.picker.git_status()
				end,
				desc = "Git status",
			},

			-- Utilities
			{
				"<leader>z",
				function()
					Snacks.zen()
				end,
				desc = "Zen mode",
			},
			{
				"<leader>.",
				function()
					Snacks.scratch()
				end,
				desc = "Scratch buffer",
			},
			{
				"<leader>S",
				function()
					Snacks.scratch.select()
				end,
				desc = "Select scratch",
			},
			{
				"<leader>bd",
				function()
					Snacks.bufdelete()
				end,
				desc = "Delete buffer",
			},
			{
				"<leader>un",
				function()
					Snacks.notifier.hide()
				end,
				desc = "Dismiss notifications",
			},
			{
				"<leader>N",
				function()
					Snacks.notifier.show_history()
				end,
				desc = "Notification history",
			},

			{
				"<leader>tc",
				function()
					Snacks.picker.colorschemes()
				end,
				desc = "Change colorscheme",
			},
		},
		init = function()
			vim.api.nvim_create_autocmd("User", {
				pattern = "VeryLazy",
				callback = function()
					-- Global debug helpers
					_G.dd = function(...)
						Snacks.debug.inspect(...)
					end
					_G.bt = function()
						Snacks.debug.backtrace()
					end
					vim.print = _G.dd
				end,
			})
		end,
		config = function(_, opts)
			require("snacks").setup(opts)
			Snacks.toggle.option("spell"):map("<leader>us")
			Snacks.toggle.option("wrap"):map("<leader>uw")
			Snacks.toggle.option("relativenumber"):map("<leader>uL")
			Snacks.toggle.diagnostics():map("<leader>ud")
			Snacks.toggle.line_number():map("<leader>ul")
			Snacks.toggle.option("conceallevel", { off = 0, on = 2 }):map("<leader>uc")
			Snacks.toggle.inlay_hints():map("<leader>uh")
			Snacks.toggle.indent():map("<leader>ug")
			Snacks.toggle.dim():map("<leader>uD")
		end,
	},

	-- Session management
	{
		"folke/persistence.nvim",
		event = "BufReadPre",
		opts = {
			options = {
				"blank",
				"buffers",
				"curdir",
				"folds",
				"help",
				"tabpages",
				"winsize",
				"winpos",
				"terminal",
				"localoptions",
			},
		},
		keys = {
			{
				"<leader>qs",
				function()
					require("persistence").load()
				end,
				desc = "Restore session",
			},
			{
				"<leader>ql",
				function()
					require("persistence").load({ last = true })
				end,
				desc = "Restore last session",
			},
			{
				"<leader>qd",
				function()
					require("persistence").stop()
				end,
				desc = "Stop session save",
			},
		},
	},

	-- Obsidian vault integration
	{
		"epwalsh/obsidian.nvim",
		version = "*",
		lazy = true,
		ft = "markdown",
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = {
			workspaces = {
				{ name = "personal", path = "~/projects/obsidian" },
			},
		},
	},
}
