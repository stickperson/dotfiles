return {
	-- Mason: installer for LSP servers, linters, formatters
	{
		"williamboman/mason.nvim",
		cmd = "Mason",
		keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
		opts = {
			ensure_installed = {
				-- Formatters (used by conform.nvim)
				"black",
				"stylua",
				"prettier",
				"shfmt",
				"hclfmt",
				"sqlfmt",
				"markdownlint",
				-- Linters (used by nvim-lint)
				"flake8",
				"mypy",
				"shellcheck",
				"hadolint",
				-- DAP
				"debugpy",
			},
			ui = { border = "rounded" },
		},
		config = function(_, opts)
			require("mason").setup(opts)
			local mr = require("mason-registry")
			local function ensure_installed()
				for _, tool in ipairs(opts.ensure_installed) do
					local p = mr.get_package(tool)
					if not p:is_installed() then
						p:install()
					end
				end
			end
			if mr.refresh then
				mr.refresh(ensure_installed)
			else
				ensure_installed()
			end
		end,
	},

	-- Bridge between mason and native LSP
	{ "williamboman/mason-lspconfig.nvim", lazy = true },

	-- LSP servers
	{
		"neovim/nvim-lspconfig",
		event = { "BufReadPre", "BufNewFile" },
		dependencies = {
			"williamboman/mason.nvim",
			"williamboman/mason-lspconfig.nvim",
			"saghen/blink.cmp", -- ensures capabilities are set before servers start
		},
		config = function()
			-- Diagnostic display
			vim.diagnostic.config({
				underline = true,
				update_in_insert = false,
				virtual_text = { spacing = 4, prefix = "●" },
				severity_sort = true,
				signs = {
					text = {
						[vim.diagnostic.severity.ERROR] = " ",
						[vim.diagnostic.severity.WARN] = " ",
						[vim.diagnostic.severity.HINT] = " ",
						[vim.diagnostic.severity.INFO] = " ",
					},
				},
				float = { border = "rounded" },
			})

			-- LSP keymaps (set per-buffer on attach)
			vim.api.nvim_create_autocmd("LspAttach", {
				group = vim.api.nvim_create_augroup("lsp_keymaps", { clear = true }),
				callback = function(event)
					local buf = event.buf
					local map = function(keys, fn, desc)
						vim.keymap.set("n", keys, fn, { buffer = buf, desc = "LSP: " .. desc })
					end

					-- Navigation via snacks picker
					map("gd", function()
						Snacks.picker.lsp_definitions()
					end, "Goto definition")
					map("gr", function()
						Snacks.picker.lsp_references()
					end, "Goto references")
					map("gI", function()
						Snacks.picker.lsp_implementations()
					end, "Goto implementation")
					map("gt", function()
						Snacks.picker.lsp_type_definitions()
					end, "Goto type definition")
					map("<leader>ss", function()
						Snacks.picker.lsp_symbols()
					end, "LSP symbols")

					-- Code outline
					map("<leader>co", "<cmd>Navbuddy<cr>", "Code outline (Navbuddy)")

					-- Actions
					map("K", vim.lsp.buf.hover, "Hover")
					map("gK", vim.lsp.buf.signature_help, "Signature help")
					map("<leader>cr", vim.lsp.buf.rename, "Rename")
					map("<leader>ca", vim.lsp.buf.code_action, "Code action")
					map("<leader>ci", "<cmd>LspInfo<cr>", "LSP info")

					-- Diagnostic navigation by severity
					map("]e", function()
						vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.ERROR })
					end, "Next error")
					map("[e", function()
						vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.ERROR })
					end, "Prev error")
					map("]w", function()
						vim.diagnostic.goto_next({ severity = vim.diagnostic.severity.WARN })
					end, "Next warning")
					map("[w", function()
						vim.diagnostic.goto_prev({ severity = vim.diagnostic.severity.WARN })
					end, "Prev warning")

					vim.keymap.set(
						"i",
						"<C-h>",
						vim.lsp.buf.signature_help,
						{ buffer = buf, desc = "LSP: Signature help" }
					)
				end,
			})

			-- Server-specific configurations
			local servers = {
				bashls = {},
				dockerls = {},
				groovyls = {},
				jedi_language_server = {},
				jsonls = {},
				rust_analyzer = {},
				sqls = {},
				terraformls = {},
				tflint = {},
				yamlls = {
					settings = {
						yaml = { keyOrdering = false },
					},
				},
				lua_ls = {
					settings = {
						Lua = {
							diagnostics = { globals = { "vim" } },
							workspace = { checkThirdParty = false },
							completion = { callSnippet = "Replace" },
							telemetry = { enable = false },
						},
					},
				},
			}

			-- Register configs with native vim.lsp.config
			for server, config in pairs(servers) do
				vim.lsp.config(server, config)
			end

			-- Mason-lspconfig: install and auto-enable servers
			require("mason-lspconfig").setup({
				ensure_installed = vim.tbl_keys(servers),
				automatic_enable = true,
			})
		end,
	},

	-- Code outline / symbol navigator (navbuddy)
	{
		"hasansujon786/nvim-navbuddy",
		lazy = false,
		dependencies = {
			"SmiteshP/nvim-navic",
			"MunifTanjim/nui.nvim",
		},
		opts = {
			lsp = { auto_attach = true },
			window = { border = "rounded" },
		},
	},

	-- Better Lua LSP for neovim config (replaces neodev.nvim)
	{
		"folke/lazydev.nvim",
		ft = "lua",
		opts = {
			library = {
				{ path = "luvit-meta/library", words = { "vim%.uv" } },
				{ path = "snacks.nvim", words = { "Snacks" } },
			},
		},
	},
	{ "Bilal2453/luvit-meta", lazy = true },
}
