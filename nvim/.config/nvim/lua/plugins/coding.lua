local function border(hl_name)
  return {
    { "╭", hl_name },
    { "─", hl_name },
    { "╮", hl_name },
    { "│", hl_name },
    { "╯", hl_name },
    { "─", hl_name },
    { "╰", hl_name },
    { "│", hl_name },
  }
end

local setup_exists, config = pcall(require, "config.setup")

return {

  -- snippets
  {
    "L3MON4D3/LuaSnip",
    dependencies = {
      "rafamadriz/friendly-snippets",
      config = function()
        require("luasnip.loaders.from_vscode").lazy_load()
      end,
    },
    opts = {
      history = true,
      delete_check_events = "TextChanged",
    },
    -- stylua: ignore
    keys = {
      {
        "<C-k>",
        function()
          local luasnip = require("luasnip")
          if luasnip.expand_or_jumpable() then
            luasnip.expand_or_jump()
          end
        end,
        expr = true, silent = true, mode = { "i", "s" }, desc = "luasnip jump or expand"
      },
      {
        "<C-j>",
        function()
          local luasnip = require("luasnip")
          if luasnip.jumpable(-1) then
            luasnip.jump(-1)
          end
        end,
        mode ={"i", "s" }, desc = "luasnip jump backwards",
      },
      {
        "<C-l>",
        function()
          local luasnip = require("luasnip")
          if luasnip.choice_active() then
            luasnip.change_choice(1)
          end
        end,
        mode ={"i" }, desc = "luasnip select list of options",
      },
    },
  },

  -- auto completion
  {
    "hrsh7th/nvim-cmp",
    version = false, -- last release is way too old
    event = "InsertEnter",
    dependencies = {
      "hrsh7th/cmp-nvim-lsp", -- lsp-based completions
      "hrsh7th/cmp-buffer", -- buffer completions
      "hrsh7th/cmp-path",
      "saadparwaiz1/cmp_luasnip", -- luasnip completions
    },
    opts = function()
      local cmp = require("cmp")
      return {
        window = {
          completion = cmp.config.window.bordered(),
          documentation = {
            border = border("CmpDocBorder"),
          },
        },
        snippet = {
          expand = function(args)
            -- Use luasnip as snippet engine. Neovim has its own built in completion engine in 0.10.0+ but it's
            -- not as powerful as luasnip
            require("luasnip").lsp_expand(args.body)
          end,
        },
        mapping = {
          ["<C-d>"] = cmp.mapping.scroll_docs(-4),
          ["<C-f>"] = cmp.mapping.scroll_docs(4),
          ["<C-Space>"] = cmp.mapping.complete(),
          ["<C-e>"] = cmp.mapping.close(),
          ["<CR>"] = cmp.mapping.confirm({
            behavior = cmp.ConfirmBehavior.Replace,
            select = false,
          }),
          ["<Tab>"] = cmp.mapping.select_next_item(),
          ["<S-Tab>"] = cmp.mapping(function(fallback)
            if cmp.visible() then
              cmp.select_prev_item()
            elseif require("luasnip").jumpable(-1) then
              vim.fn.feedkeys(vim.api.nvim_replace_termcodes("<Plug>luasnip-jump-prev", true, true, true), "")
            else
              fallback()
            end
          end, {
            "i",
            "s",
          }),
        },
        sources = cmp.config.sources({
          { name = "nvim_lsp" },
          { name = "luasnip" },
          { name = "buffer" },
          { name = "nvim_lua" },
        }, {

          { name = "path" },
        }),
        experimental = {
          ghost_text = false,
        },
      }
    end,
  },

  -- auto pairs
  {
    "windwp/nvim-autopairs",
    event = "InsertEnter",
    opts = {
      fast_wrap = {},
      disable_filetype = { "TelescopePrompt", "vim" },
    },
    config = function(_, opts)
      require("nvim-autopairs").setup(opts)

      -- setup cmp for autopairs
      local cmp_autopairs = require("nvim-autopairs.completion.cmp")
      require("cmp").event:on("confirm_done", cmp_autopairs.on_confirm_done())
    end,
  },

  -- surround
  {
    "echasnovski/mini.surround",
    keys = function(plugin, keys)
      -- Populate the keys based on the user's options
      local opts = require("lazy.core.plugin").values(plugin, "opts", false)
      local mappings = {
        { opts.mappings.add, desc = "Add surrounding", mode = { "n", "v" } },
        { opts.mappings.delete, desc = "Delete surrounding" },
        { opts.mappings.find, desc = "Find right surrounding" },
        { opts.mappings.find_left, desc = "Find left surrounding" },
        { opts.mappings.highlight, desc = "Highlight surrounding" },
        { opts.mappings.replace, desc = "Replace surrounding" },
        { opts.mappings.update_n_lines, desc = "Update `MiniSurround.config.n_lines`" },
      }
      return vim.list_extend(mappings, keys)
    end,
    opts = {
      mappings = {
        add = "gza", -- Add surrounding in Normal and Visual modes
        delete = "gzd", -- Delete surrounding
        find = "gzf", -- Find surrounding (to the right)
        find_left = "gzF", -- Find surrounding (to the left)
        highlight = "gzh", -- Highlight surrounding
        replace = "gzr", -- Replace surrounding
        update_n_lines = "gzn", -- Update `n_lines`
      },
    },
    config = function(_, opts)
      -- use gz mappings instead of s to prevent conflict with leap
      require("mini.surround").setup(opts)
    end,
  },

  -- comments
  {
    "numToStr/Comment.nvim",
    module = "Comment",
    keys = {
      {
        "<leader>/",
        function()
          require("Comment.api").toggle.linewise.current()
        end,
        "toggle comment",
      },
      {
        "<leader>/",
        "<ESC><cmd>lua require('Comment.api').toggle.linewise(vim.fn.visualmode())<CR>",
        "toggle comment",
        mode = "v",
      },
    },
  },
  {
    "github/copilot.vim",
    lazy = false,
    cond = function()
      return setup_exists and config.enable_copilot
    end,
    config = function()
      vim.keymap.set("i", "<C-p>", 'copilot#Accept("\\<CR>")', {
        expr = true,
        replace_keycodes = false,
      })
      vim.g.copilot_no_tab_map = true
    end,
  },
}
