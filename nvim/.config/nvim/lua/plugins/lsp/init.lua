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
        "jedi-language-server",
        "json-lsp",
        "lua-language-server",
        "markdownlint",
        "mypy",
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
