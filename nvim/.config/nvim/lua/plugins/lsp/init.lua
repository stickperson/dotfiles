return {
  {
    "mason-org/mason-lspconfig.nvim",
    event = "BufReadPre",
    opts = {},
    dependencies = {
      "mason-org/mason.nvim",
      "neovim/nvim-lspconfig",
    },
  },
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "mason.nvim",
      "hrsh7th/cmp-nvim-lsp",
      {
        -- Setup easy lua_ls setup
        "folke/lazydev.nvim",
        ft = "lua", -- only load on lua files
        opts = {
          library = {
            -- See the configuration section for more details
            -- Load luvit types when the `vim.uv` word is found
            { path = "${3rd}/luv/library", words = { "vim%.uv" } },
            { path = "snacks.nvim", words = { "Snacks" } },
          },
        },
      },
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          -- lsp symbol navigation for lualine
          {
            "SmiteshP/nvim-navic",
            opts = { highlight = true, depth_limit = 5 },
          },
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
        keys = {
          { "<leader>nb", "<cmd>Navbuddy<cr>", desc = "Navbuddy", mode = "n" },
        },
      },
      --
      { "j-hui/fidget.nvim", tag = "legacy" },
    },
    opts = {
      -- options for vim.diagnostic.config()
      diagnostics = {
        underline = true,
        update_in_insert = false,
        virtual_lines = {
          format = function(d)
            return string.format("%s [%s]", d.message, d.source or "unknown")
          end,
        },
        -- virtual_text = { spacing = 4, prefix = "●" },
        severity_sort = true,
      },
      -- Automatically format on save
      autoformat = true,
      -- options for vim.lsp.buf.format
      -- `bufnr` and `filter` is handled by the LazyVim formatter,
      -- but can be also overriden when specified
      format = {
        formatting_options = nil,
        timeout_ms = nil,
      },
<<<<<<< Updated upstream
||||||| Stash base
      -- LSP Server Settings
      servers = {
        bashls = {},
        diagnosticls = {},
        dockerls = {},
        jedi_language_server = {},
        jsonls = {},
        rust_analyzer = {},
        sqls = {},
        terraformls = {},
        tflint = {},
        yamlls = {
          settings = {
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              telemetry = { enable = false },
            },
          },
        },
        -- ts_ls = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
=======
      -- LSP Server Settings
      servers = {
        bashls = {},
        diagnosticls = {},
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
            yaml = {
              keyOrdering = false,
            },
          },
        },
        lua_ls = {
          settings = {
            Lua = {
              diagnostics = {
                globals = { "vim" },
              },
              workspace = {
                checkThirdParty = false,
              },
              completion = {
                callSnippet = "Replace",
              },
              telemetry = { enable = false },
            },
          },
        },
        -- ts_ls = {},
      },
      -- you can do any additional lsp server setup here
      -- return true if you don't want this server to be setup with lspconfig
      setup = {
        -- example to setup with typescript.nvim
        -- tsserver = function(_, opts)
        --   require("typescript").setup({ server = opts })
        --   return true
        -- end,
        -- Specify * to use this function as a fallback for any server
        -- ["*"] = function(server, opts) end,
      },
>>>>>>> Stashed changes
    },
    config = function(_, opts)
      -- setup autoformat
      require("plugins.lsp.format").autoformat = opts.autoformat
      -- setup formatting and keymaps
      require("plugins.lsp.util").on_attach(function(client, buffer)
        require("plugins.lsp.format").on_attach(client, buffer)
        require("plugins.lsp.keymaps").on_attach(client, buffer)
      end)

      vim.diagnostic.config(opts.diagnostics)

      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      -- Copy/pasted from the nvim-ufo docs
      -- Tell the server the capability of foldingRange,
      -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }
<<<<<<< Updated upstream
||||||| Stash base

      local function setup(server)
        local server_opts = servers[server] or {}
        server_opts.capabilities = capabilities
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        require("lspconfig")[server].setup(server_opts)
      end

      local mlsp = require("mason-lspconfig")
      local available = mlsp.get_available_servers()

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          -- run manual setup if mason=false or if this is a server that cannot be installed with mason-lspconfig
          if server_opts.mason == false or not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
          end
        end
      end

      require("mason-lspconfig").setup({ ensure_installed = ensure_installed })
      require("mason-lspconfig").setup_handlers({ setup })
=======

      local function setup(server)
        local server_opts = servers[server] or {}
        server_opts.capabilities = capabilities
        if opts.setup[server] then
          if opts.setup[server](server, server_opts) then
            return
          end
        elseif opts.setup["*"] then
          if opts.setup["*"](server, server_opts) then
            return
          end
        end
        vim.lsp.config(server, server_opts)
        vim.lsp.enable(server)
      end

      local mlsp = require("mason-lspconfig")
      local available = mlsp.get_available_servers()

      -- Set capabilities globally for all servers
      vim.lsp.config("*", { capabilities = capabilities })

      local ensure_installed = {} ---@type string[]
      for server, server_opts in pairs(servers) do
        if server_opts then
          server_opts = server_opts == true and {} or server_opts
          if server_opts.mason == false or not vim.tbl_contains(available, server) then
            setup(server)
          else
            ensure_installed[#ensure_installed + 1] = server
            setup(server)
          end
        end
      end

      require("mason-lspconfig").setup({
        ensure_installed = ensure_installed,
        automatic_enable = false,
      })
>>>>>>> Stashed changes
    end,
  },

  -- formatters
  {
    "nvimtools/none-ls.nvim",
    event = "BufReadPre",
    dependencies = { "mason.nvim", "nvimtools/none-ls-extras.nvim" },
    opts = function()
      local b = require("null-ls").builtins
      return {
        border = "rounded",
        debug = false,
        sources = {
          -- General
          b.completion.spell,

          -- Git
          b.code_actions.gitsigns,

          -- Lua
          b.formatting.stylua,

          -- HTML etc.
          b.formatting.prettier,

          -- Markdown
          b.code_actions.proselint,
          -- Better diagnostics that proselint
          b.diagnostics.write_good,
          b.completion.spell,
          b.formatting.markdownlint,
          b.formatting.sqlfmt,

          -- Python
          require("none-ls.diagnostics.flake8"),
          b.formatting.black,

          -- Shell
          b.formatting.shfmt.with({
            extra_args = { "-i", "2", "-ci" },
          }),

          -- Terraform
          b.formatting.terraform_fmt,
          b.formatting.hclfmt,

          b.formatting.prettier,
        },
      }
    end,
  },

  -- cmdline tools and lsp servers
  {
    "williamboman/mason.nvim",
    cmd = "Mason",
    keys = { { "<leader>cm", "<cmd>Mason<cr>", desc = "Mason" } },
    opts = {
<<<<<<< Updated upstream
      PATH = "append",

||||||| Stash base
      ensure_installed = {
        "autopep8",
        "beautysh",
        "black",
        "debugpy",
        "flake8",
        "gopls",
        "hadolint",
        "hclfmt",
        "markdownlint",
        "mypy",
        "prettier",
        "proselint",
        "shellcheck",
        "shfmt",
        "stylua",
        "write-good",
        "yamlfmt",
      },
=======
      ensure_installed = {
        "autopep8",
        "jedi-language-server",
        "beautysh",
        "black",
        "debugpy",
        "flake8",
        "gopls",
        "hadolint",
        "hclfmt",
        "markdownlint",
        "mypy",
        "prettier",
        "proselint",
        "shellcheck",
        "shfmt",
        "stylua",
        "write-good",
        "yamlfmt",
      },
>>>>>>> Stashed changes
      ui = {
        border = "rounded",
      },
    },
    config = function(_, opts)
      local mason = require("mason")
      mason.setup(opts)

      -- Ensure registry is refreshed
      local mr = require("mason-registry")
      mr.refresh() -- important to avoid "Cannot find package"

      local tools = {
        "autopep8",
        "basedpyright",
        "bash-language-server",
        "beautysh",
        "black",
        "debugpy",
        "diagnostic-languageserver",
        "dockerfile-language-server",
        "flake8",
        "gopls",
        "hadolint",
        "hclfmt",
        "json-lsp",
        "lua-language-server",
        "markdownlint",
        "prettier",
        "proselint",
        "rust-analyzer",
        "shellcheck",
        "shfmt",
        "sqlfmt",
        "sqls",
        "stylua",
        "terraform",
        "terraform-ls",
        "tflint",
        "write-good",
        "yamlfmt",
        "yaml-language-server",
      }

      for _, tool in ipairs(tools) do
        if not mr.is_installed(tool) then
          if mr.has_package(tool) then
            local pkg = mr.get_package(tool)
            vim.notify("Installing tool: " .. tool, vim.log.levels.WARN)
            pkg:install()
          else
            vim.notify("Mason cannot find package: " .. tool, vim.log.levels.WARN)
          end
        end
      end
    end,
  },
  {
    "nvimdev/lspsaga.nvim",
    event = "LspAttach",
    dependencies = { { "nvim-tree/nvim-web-devicons" } },
    opts = {
      -- Disable code action lightbulb
      lightbulb = {
        enable = false,
      },
      outline = {
        win_position = "left",
      },
    },
  },
}
