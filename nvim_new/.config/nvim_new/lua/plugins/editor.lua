return {
	-- Sidebar file tree
	{
		"nvim-neo-tree/neo-tree.nvim",
		branch = "v3.x",
		dependencies = {
			"nvim-lua/plenary.nvim",
			"nvim-tree/nvim-web-devicons",
			"MunifTanjim/nui.nvim",
		},
		cmd = "Neotree",
		keys = {
			{ "<leader>e", "<cmd>Neotree toggle<cr>", desc = "File tree" },
			{ "<leader>E", "<cmd>Neotree reveal<cr>", desc = "Reveal file in tree" },
		},
		opts = {
			filesystem = {
				follow_current_file = { enabled = true },
				hijack_netrw_behavior = "open_current",
				use_libuv_file_watcher = true,
			},
			window = {
				width = 35,
				mappings = {
					["<space>"] = "none", -- don't steal leader
				},
			},
			default_component_configs = {
				indent = { with_expanders = true },
			},
		},
	},

	-- Fast motions
	{
		"folke/flash.nvim",
		event = "VeryLazy",
		opts = { modes = { search = { enabled = false } } },
		keys = {
			{
				"s",
				mode = { "n", "x", "o" },
				function()
					require("flash").jump()
				end,
				desc = "Flash",
			},
			{
				"S",
				mode = { "n", "x", "o" },
				function()
					require("flash").treesitter()
				end,
				desc = "Flash treesitter",
			},
			{
				"r",
				mode = "o",
				function()
					require("flash").remote()
				end,
				desc = "Remote flash",
			},
			{
				"R",
				mode = { "o", "x" },
				function()
					require("flash").treesitter_search()
				end,
				desc = "Treesitter search",
			},
			{
				"<c-s>",
				mode = "c",
				function()
					require("flash").toggle()
				end,
				desc = "Toggle flash search",
			},
		},
	},

	-- Keymap hints
	{
		"folke/which-key.nvim",
		event = "VeryLazy",
		opts = { plugins = { spelling = true } },
		config = function(_, opts)
			local wk = require("which-key")
			wk.setup(opts)
			wk.add({
				{ "<leader>b", group = "buffer" },
				{ "<leader>c", group = "code" },
				{ "<leader>d", group = "debug" },
				{ "<leader>f", group = "file/find" },
				{ "<leader>g", group = "git" },
				{ "<leader>gh", group = "git hunks" },
				{ "<leader>gd", group = "diffview" },
				{ "<leader>q", group = "quit/session" },
				{ "<leader>s", group = "search" },
				{ "<leader>u", group = "ui toggles" },
				{ "<leader>w", group = "windows" },
				{ "<leader>x", group = "diagnostics/quickfix" },
				{ "<leader><tab>", group = "tabs" },
				{ "[", group = "prev" },
				{ "]", group = "next" },
				{ "g", group = "goto" },
				{ "gz", group = "surround" },
				-- Prevent neo-tree from turning <leader>e into a group
				{ "<leader>e", desc = "File tree" },
				{ "<leader>E", desc = "Reveal in tree" },
			})
		end,
	},

	-- Highlight TODO/FIXME/HACK comments
	{
		"folke/todo-comments.nvim",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-lua/plenary.nvim" },
		opts = { signs = false },
		keys = {
			{
				"]t",
				function()
					require("todo-comments").jump_next()
				end,
				desc = "Next todo",
			},
			{
				"[t",
				function()
					require("todo-comments").jump_prev()
				end,
				desc = "Prev todo",
			},
			{ "<leader>xt", "<cmd>Trouble todo toggle<cr>", desc = "Todo (trouble)" },
			{
				"<leader>st",
				function()
					Snacks.picker.todo_comments()
				end,
				desc = "Search todos",
			},
		},
	},

	-- Diagnostics list
	{
		"folke/trouble.nvim",
		cmd = "Trouble",
		opts = { use_diagnostic_signs = true },
		keys = {
			{ "<leader>xx", "<cmd>Trouble diagnostics toggle<cr>", desc = "Diagnostics" },
			{ "<leader>xX", "<cmd>Trouble diagnostics toggle filter.buf=0<cr>", desc = "Buffer diagnostics" },
			{ "<leader>cs", "<cmd>Trouble symbols toggle focus=false<cr>", desc = "Symbols" },
			{ "<leader>cl", "<cmd>Trouble lsp toggle focus=false win.position=right<cr>", desc = "LSP (trouble)" },
			{ "<leader>xL", "<cmd>Trouble loclist toggle<cr>", desc = "Location list" },
			{ "<leader>xQ", "<cmd>Trouble qflist toggle<cr>", desc = "Quickfix list" },
		},
	},

	-- Surround text objects
	{
		"echasnovski/mini.surround",
		version = false,
		event = "VeryLazy",
		opts = {
			mappings = {
				add = "gza",
				delete = "gzd",
				find = "gzf",
				find_left = "gzF",
				highlight = "gzh",
				replace = "gzr",
				update_n_lines = "gzn",
			},
		},
	},

	-- Comments
	{
		"numToStr/Comment.nvim",
		event = "VeryLazy",
		opts = {},
		keys = {
			{
				"<leader>/",
				function()
					require("Comment.api").toggle.linewise.current()
				end,
				mode = "n",
				desc = "Toggle comment",
			},
			{
				"<leader>/",
				function()
					local esc = vim.api.nvim_replace_termcodes("<ESC>", true, false, true)
					vim.api.nvim_feedkeys(esc, "nx", false)
					require("Comment.api").toggle.linewise(vim.fn.visualmode())
				end,
				mode = "v",
				desc = "Toggle comment",
			},
		},
	},

	-- Floating terminal
	{
		"akinsho/toggleterm.nvim",
		version = "*",
		keys = { { "<C-\\>", desc = "Toggle terminal" } },
		opts = {
			open_mapping = [[<C-\>]],
			direction = "float",
			float_opts = { border = "curved" },
		},
	},

	-- Better code folding
	{
		"kevinhwang91/nvim-ufo",
		event = "BufReadPost",
		dependencies = { "kevinhwang91/promise-async" },
		opts = {
			provider_selector = function(_, filetype, buftype)
				return (buftype == "" and filetype ~= "") and { "treesitter", "indent" } or ""
			end,
		},
		keys = {
			{
				"zM",
				function()
					require("ufo").closeAllFolds()
				end,
				desc = "Close all folds",
			},
			{
				"zR",
				function()
					require("ufo").openAllFolds()
				end,
				desc = "Open all folds",
			},
		},
	},

	{ "kevinhwang91/promise-async", lazy = true },

	-- Live markdown preview in browser
	{
		"iamcco/markdown-preview.nvim",
		cmd = { "MarkdownPreviewToggle", "MarkdownPreview", "MarkdownPreviewStop" },
		ft = "markdown",
		build = "cd app && npx --yes yarn install",
		keys = {
			{ "<leader>mp", "<cmd>MarkdownPreviewToggle<cr>", desc = "Markdown preview" },
		},
	},
}
