return {
  {
    "neovim/nvim-lspconfig",
    event = "BufReadPre",
    dependencies = {
      "mason.nvim",
      "williamboman/mason-lspconfig.nvim",
      "hrsh7th/cmp-nvim-lsp",
      {
        "SmiteshP/nvim-navbuddy",
        dependencies = {
          -- lsp symbol navigation for lualine
          {
            "SmiteshP/nvim-navic",
            opts = { highlight = true, depth_limit = 5 },
          },
          -- "SmiteshP/nvim-navic",
          "MunifTanjim/nui.nvim",
        },
        opts = { lsp = { auto_attach = true } },
        keys = {
          { "<leader>nb", "<cmd>Navbuddy<cr>", desc = "Navbuddy" },
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
        virtual_text = { spacing = 4, prefix = "●" },
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
      },
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

      local servers = opts.servers
      local capabilities = require("cmp_nvim_lsp").default_capabilities(vim.lsp.protocol.make_client_capabilities())
      -- Copy/pasted from the nvim-ufo docs
      -- Tell the server the capability of foldingRange,
      -- Neovim hasn't added foldingRange to default capabilities, users must add it manually
      capabilities.textDocument.foldingRange = {
        dynamicRegistration = false,
        lineFoldingOnly = true,
      }

      local function setup(server, server_opts)
        server_opts = server_opts or servers[server] or {}
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
          b.diagnostics.mypy,
          b.formatting.black,
          require("none-ls.formatting.ruff_format"),

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
      }

      for _, tool in ipairs(tools) do
        if mr.is_installed(tool) == false then
          local p = mr.get_package(tool)
          if p then
            p:install()
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
