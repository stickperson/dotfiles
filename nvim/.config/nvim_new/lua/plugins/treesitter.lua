return {
	-- Parser installation and highlighting
	{
		"nvim-treesitter/nvim-treesitter",
		version = false,
		build = ":TSUpdate",
		event = { "BufReadPost", "BufNewFile" },
		cmd = { "TSUpdateSync", "TSUpdate", "TSInstall" },
		config = function()
			-- v1.x: setup() only configures install_dir
			require("nvim-treesitter").setup()

			-- Enable highlighting for all buffers (v1.x no longer does this automatically)
			vim.api.nvim_create_autocmd("FileType", {
				callback = function(args)
					pcall(vim.treesitter.start, args.buf)
				end,
			})

			-- Install parsers
			require("nvim-treesitter").install({
				"bash",
				"hcl",
				"javascript",
				"json",
				"lua",
				"luadoc",
				"markdown",
				"markdown_inline",
				"python",
				"query",
				"regex",
				"terraform",
				"typescript",
				"vim",
				"vimdoc",
				"yaml",
			})
		end,
	},

	-- Text objects, motions, and swap
	{
		"nvim-treesitter/nvim-treesitter-textobjects",
		event = { "BufReadPost", "BufNewFile" },
		dependencies = { "nvim-treesitter/nvim-treesitter" },
		config = function()
			require("nvim-treesitter-textobjects").setup({
				select = { lookahead = true },
				move = { set_jumps = true },
			})

			local sel = require("nvim-treesitter-textobjects.select")
			local mov = require("nvim-treesitter-textobjects.move")
			local swp = require("nvim-treesitter-textobjects.swap")

			-- Select text objects
			local function sel_map(key, query, desc)
				vim.keymap.set({ "x", "o" }, key, function()
					sel.select_textobject(query, "textobjects")
				end, { desc = desc })
			end
			sel_map("af", "@function.outer", "Around function")
			sel_map("if", "@function.inner", "Inside function")
			sel_map("ac", "@class.outer", "Around class")
			sel_map("ic", "@class.inner", "Inside class")
			sel_map("aa", "@parameter.outer", "Around parameter")
			sel_map("ia", "@parameter.inner", "Inside parameter")

			-- Motions
			local function mov_map(key, fn, query, desc)
				vim.keymap.set("n", key, function()
					mov[fn](query, "textobjects")
				end, { desc = desc })
			end
			mov_map("]m", "goto_next_start", "@function.outer", "Next function start")
			mov_map("[m", "goto_previous_start", "@function.outer", "Prev function start")
			mov_map("]M", "goto_next_end", "@function.outer", "Next function end")
			mov_map("[M", "goto_previous_end", "@function.outer", "Prev function end")
			mov_map("]]", "goto_next_start", "@class.outer", "Next class start")
			mov_map("[[", "goto_previous_start", "@class.outer", "Prev class start")

			-- Swap parameters
			vim.keymap.set("n", "<leader>a", function()
				swp.swap_next("@parameter.inner", "textobjects")
			end, { desc = "Swap next parameter" })
			vim.keymap.set("n", "<leader>A", function()
				swp.swap_previous("@parameter.inner", "textobjects")
			end, { desc = "Swap prev parameter" })
		end,
	},
}
