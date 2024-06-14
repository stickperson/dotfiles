local find_command = {
  "fd",
  "--type",
  "f",
  "--hidden",
  "--follow",
  "--exclude",
  "{.git,node_modules}",
  "--color",
  "never",
}
return {
  --
  {
    "ThePrimeagen/harpoon",
    event = "BufReadPost",
    keys = {
      {
        "<leader>hc",
        function()
          require("harpoon.mark").clear_all()
        end,
        desc = "Harpoon clear all marks",
      },
      {
        "<leader>hd",
        function()
          require("harpoon.mark").rm_file()
        end,
        desc = "Harpoon remove file",
      },
      {
        "<leader>hm",
        function()
          require("harpoon.mark").add_file()
        end,
        desc = "Harpoon mark",
      },
      {
        "<leader>hv",
        function()
          require("harpoon.ui").toggle_quick_menu()
        end,
        desc = "Harpoon toggle quick menu",
      },
    },
    config = function()
      require("telescope").load_extension("harpoon")
    end,
  },

  -- file explorer
  {
    "kyazdani42/nvim-tree.lua",
    cmd = { "NvimTreeToggle", "NvimTreeFocus" },
    keys = {
      -- toggle
      { "<leader>e", "<cmd> NvimTreeToggle <CR>", desc = "toggle nvimtree" },
    },
    opts = {
      live_filter = {
        prefix = "[FILTER]: ",
        -- name is weird. this allows you to filter folders
        always_show_folders = false,
      },
      filters = {
        -- dotfiles = false,
        exclude = { vim.fn.stdpath("config") .. "/lua/custom" },
      },
      disable_netrw = true,
      hijack_netrw = true,
      -- ignore_ft_on_setup = { "starter" },
      hijack_cursor = true,
      hijack_unnamed_buffer_when_opening = true,
      sync_root_with_cwd = true,
      update_focused_file = {
        enable = true,
        update_root = false,
      },
      view = {
        adaptive_size = true,
        side = "left",
        width = 25,
      },
      git = {
        enable = false,
        ignore = true,
      },
      filesystem_watchers = {
        enable = true,
      },
      actions = {
        open_file = {
          resize_window = true,
        },
      },
      renderer = {
        highlight_git = false,
        highlight_opened_files = "none",

        indent_markers = {
          enable = false,
        },

        icons = {
          show = {
            file = true,
            folder = true,
            folder_arrow = true,
            git = false,
          },

          glyphs = {
            default = "",
            symlink = "",
            folder = {
              default = "",
              empty = "",
              empty_open = "",
              open = "",
              symlink = "",
              symlink_open = "",
              arrow_open = "",
              arrow_closed = "",
            },
            git = {
              unstaged = "✗",
              staged = "✓",
              unmerged = "",
              renamed = "➜",
              untracked = "★",
              deleted = "",
              ignored = "◌",
            },
          },
        },
        root_folder_label = false,
      },
    },
  },

  -- search/replace in multiple files
  {
    "windwp/nvim-spectre",
    config = true,
    -- stylua: ignore
    keys = {
      { "<leader>sr", function() require("spectre").open() end, desc = "Replace in files (Spectre)" },
    },
  },

  -- fuzzy finder
  {
    "nvim-telescope/telescope.nvim",
    cmd = "Telescope",
    version = false, -- telescope did only one release, so use HEAD for now
    dependencies = {
      {
        "ANGkeith/telescope-terraform-doc.nvim",
      },
      {
        "aaronhallaert/advanced-git-search.nvim",
        dependencies = {
          {
            "sindrets/diffview.nvim",
          },
        },
      },
      {
        "nvim-telescope/telescope-fzf-native.nvim",
        build = "make",
      },
      {
        "sindrets/diffview.nvim",
      },
    },
    keys = {
      { "<leader>:", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      -- find
      { "<leader>fb", "<cmd>Telescope buffers<cr>", desc = "Buffers" },
      { "<leader>ff", "<cmd>Telescope find_files<cr>", desc = "Find files" },
      { "<leader>fh", "<cmd>Telescope help_tags<cr>", desc = "Help Pages" },
      { "<leader>fo", "<cmd>Telescope oldfiles<cr>", desc = "Recent" },
      { "<leader>fw", "<cmd>Telescope live_grep <cr>", desc = "Find in Files (Grep)" },
      { "<leader>gs", "<cmd>Telescope grep_string<CR>", desc = "Grep string" },
      { "<leader>tb", "<cmd>Telescope buffers<CR>", desc = "Terraform buffers" },
      { "<leader>td", "<cmd>Telescope terraform_doc full_name=hashicorp/aws<CR>", desc = "Terraform doc" },
      { "<leader>tk", "<cmd>Telescope keymaps<CR>", desc = "Telescope keymaps" },

      -- search
      { "<leader>sa", "<cmd>Telescope autocommands<cr>", desc = "Auto Commands" },
      { "<leader>sb", "<cmd>Telescope current_buffer_fuzzy_find<cr>", desc = "Buffer" },
      { "<leader>sc", "<cmd>Telescope command_history<cr>", desc = "Command History" },
      { "<leader>sC", "<cmd>Telescope commands<cr>", desc = "Commands" },
      { "<leader>sd", "<cmd>Telescope diagnostics<cr>", desc = "Diagnostics" },
      { "<leader>sH", "<cmd>Telescope highlights<cr>", desc = "Search Highlight Groups" },
      { "<leader>sk", "<cmd>Telescope keymaps<cr>", desc = "Key Maps" },
      { "<leader>sM", "<cmd>Telescope man_pages<cr>", desc = "Man Pages" },
      { "<leader>sm", "<cmd>Telescope marks<cr>", desc = "Jump to Mark" },
      { "<leader>so", "<cmd>Telescope vim_options<cr>", desc = "Options" },
      {
        "<leader>tf",
        function()
          if not require("nvim-tree.view").is_visible() then
            return
          end
          local node = require("nvim-tree.lib").get_node_at_cursor()

          if node == nil then
            return
          end

          require("telescope.builtin").find_files({
            shorten_path = true,
            cwd = node.absolute_path,
            prompt_title = "~ Find files in directory ~",
            hidden = true,
          })
        end,
        desc = "Find files in directory selected in nvim-tree",
      },
      {
        "<leader>tw",
        function()
          if not require("nvim-tree.view").is_visible() then
            return
          end
          local node = require("nvim-tree.lib").get_node_at_cursor()

          if node == nil then
            return
          end

          require("telescope.builtin").live_grep({
            shorten_path = true,
            cwd = node.absolute_path,
            prompt_title = "~ Live grep in directory ~",
            hidden = true,
          })
        end,
        desc = "Live grep in directory selected in nvim-tree",
      },
      -- other
      { "<leader>tc", "<cmd>Telescope colorscheme<cr>", desc = "Change colorscheme" },
    },
    opts = function()
      local actions = require("telescope.actions")
      return {
        extensions = {
          advanced_git_search = {
            diff_plugin = "diffview",
            git_flags = {
              "-c",
              "delta.side-by-side=false",
            },
          },
        },
        defaults = {
          prompt_prefix = " ",
          selection_caret = " ",
          sorting_strategy = "ascending",
          layout_strategy = "horizontal",
          layout_config = {
            horizontal = {
              prompt_position = "top",
              preview_width = 0.55,
              results_width = 0.8,
            },
            vertical = {
              mirror = false,
            },
            width = 0.87,
            height = 0.80,
            preview_cutoff = 120,
          },
          file_ignore_patterns = { "node_modules" },
          border = {},
          borderchars = { "─", "│", "─", "│", "╭", "╮", "╯", "╰" },
          set_env = { ["COLORTERM"] = "truecolor" }, -- default = nil,
          -- Developer configurations: Not meant for general override
          -- buffer_previewer_maker = require("telescope.previewers").buffer_previewer_maker,
          mappings = {
            i = {
              ["<c-t>"] = function(...)
                return require("trouble.providers.telescope").open_with_trouble(...)
              end,
              ["<C-Down>"] = function(...)
                return require("telescope.actions").cycle_history_next(...)
              end,
              ["<C-Up>"] = function(...)
                return require("telescope.actions").cycle_history_prev(...)
              end,
              ["<C-f>"] = actions.send_to_qflist + actions.open_qflist,
            },
            n = {
              ["<C-f>"] = actions.send_to_qflist + actions.open_qflist,
            },
          },
        },
        pickers = {
          find_files = {
            find_command = find_command,
          },
          colorscheme = {
            enable_preview = true,
          },
          help_tags = {
            mappings = {
              i = {
                ["<CR>"] = "select_vertical",
              },
              n = {
                ["<CR>"] = "select_vertical",
              },
            },
          },
        },
      }
    end,
    config = function(_, opts)
      require("telescope").setup(opts)
      require("telescope").load_extension("advanced_git_search")
      require("telescope").load_extension("terraform_doc")
      require("telescope").load_extension("fzf")
    end,
  },
  {
    "folke/flash.nvim",
    event = "VeryLazy",
    opts = {
      modes = {
        search = {
          -- disable when doing normal (e.g. /) searches
          enabled = false,
        },
      },
    },
    keys = {
      {
        "s",
        mode = { "n", "x", "o" },
        function()
          require("flash").jump({
            search = {
              mode = function(str)
                return "\\<" .. str
              end,
            },
          })
        end,
        desc = "Flash",
      },
      {
        "S",
        mode = { "n", "o", "x" },
        function()
          require("flash").treesitter()
        end,
        desc = "Flash Treesitter",
      },
      {
        "r",
        mode = "o",
        function()
          require("flash").remote()
        end,
        desc = "Remote Flash",
      },
      {
        "R",
        mode = { "o", "x" },
        function()
          require("flash").treesitter_search()
        end,
        desc = "Flash Treesitter Search",
      },
      {
        "<c-s>",
        mode = { "c" },
        function()
          require("flash").toggle()
        end,
        desc = "Toggle Flash Search",
      },
    },
  },
  -- which-key
  {
    "folke/which-key.nvim",
    event = "VeryLazy",
    opts = {
      plugins = { spelling = true },
    },
    config = function(_, opts)
      local wk = require("which-key")
      wk.setup(opts)
      wk.register({
        mode = { "n", "v" },
        ["g"] = { name = "+goto" },
        ["gz"] = { name = "+surround" },
        ["]"] = { name = "+next" },
        ["["] = { name = "+prev" },
        ["<leader><tab>"] = { name = "+tabs" },
        ["<leader>b"] = { name = "+buffer" },
        ["<leader>c"] = { name = "+code" },
        ["<leader>f"] = { name = "+file/find" },
        ["<leader>g"] = { name = "+git" },
        ["<leader>gh"] = { name = "+hunks" },
        ["<leader>h"] = { name = "+harpoon" },
        ["<leader>q"] = { name = "+quit/session" },
        ["<leader>s"] = { name = "+search" },
        ["<leader>sn"] = { name = "+noice" },
        ["<leader>t"] = { name = "+telescope" },
        ["<leader>u"] = { name = "+ui" },
        ["<leader>w"] = { name = "+windows" },
        ["<leader>x"] = { name = "+diagnostics/quickfix" },
      })
    end,
  },

  -- git signs
  {
    "lewis6991/gitsigns.nvim",
    event = "BufReadPre",
    opts = {
      numhl = true,
      current_line_blame = true,
      on_attach = function(buffer)
        local gs = package.loaded.gitsigns

        local function map(mode, l, r, desc)
          vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
        end

        -- stylua: ignore start
        map("n", "ghn", gs.next_hunk, "Next Hunk")
        map("n", "ghp", gs.prev_hunk, "Prev Hunk")
        map("n", "]h", gs.next_hunk, "Next Hunk")
        map("n", "[h", gs.prev_hunk, "Prev Hunk")
        map({ "n", "v" }, "<leader>rh", ":Gitsigns reset_hunk<CR>", "Reset Hunk")
        map("n", "<leader>ph", gs.preview_hunk, "Preview Hunk")
        -- map("n", "<leader>ghd", gs.diffthis, "Diff This")
        -- map("n", "<leader>ghD", function() gs.diffthis("~") end, "Diff This ~")
        -- map({ "o", "x" }, "ih", ":<C-U>Gitsigns select_hunk<CR>", "GitSigns Select Hunk")
      end,
    },
  },
  {
    "ruifm/gitlinker.nvim",
    config = true,
    lazy = false,
  },

  -- references
  {
    "RRethy/vim-illuminate",
    event = "BufReadPost",
    opts = { delay = 200 },
    config = function(_, opts)
      require("illuminate").configure(opts)
    end,
  },

  -- buffer remove
  {
    "echasnovski/mini.bufremove",
    -- stylua: ignore
    keys = {
      { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
      { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
    },
  },

  -- better diagnostics list and others
  {
    "folke/trouble.nvim",
    cmd = { "TroubleToggle", "Trouble" },
    opts = { use_diagnostic_signs = true },
    keys = {
      { "<leader>xx", "<cmd>TroubleToggle document_diagnostics<cr>", desc = "Document Diagnostics (Trouble)" },
      { "<leader>xX", "<cmd>TroubleToggle workspace_diagnostics<cr>", desc = "Workspace Diagnostics (Trouble)" },
    },
  },

  -- todo comments
  {
    "folke/todo-comments.nvim",
    cmd = { "TodoTrouble", "TodoTelescope" },
    event = "BufReadPost",
    config = true,
    -- stylua: ignore
    keys = {
      { "]t", function() require("todo-comments").jump_next() end, desc = "Next todo comment" },
      { "[t", function() require("todo-comments").jump_prev() end, desc = "Previous todo comment" },
      { "<leader>xt", "<cmd>TodoTrouble<cr>", desc = "Todo (Trouble)" },
      { "<leader>xT", "<cmd>TodoTrouble keywords=TODO,FIX,FIXME<cr>", desc = "Todo/Fix/Fixme (Trouble)" },
      { "<leader>st", "<cmd>TodoTelescope<cr>", desc = "Todo" },
    },
  },

  -- terminal
  {
    "akinsho/toggleterm.nvim",
    cmd = { "ToggleTerm" },
    keys = {
      { [[<c-\>]], "<cmd> ToggleTerm <cr>", desc = "toggle terminal" },
    },
    opts = {
      direction = "float",
      open_mapping = [[<c-\>]],
      shade_terminals = false,
    },
  },

  -- folding
  -- {
  --   "kevinhwang91/nvim-ufo",
  --   lazy = "VeryLazy",
  --   dependencies = { "kevinhwang91/promise-async" },
  --   keys = {
  --     {
  --       "zM",
  --       function()
  --         require("ufo").closeAllFolds()
  --       end,
  --       desc = "close all folds",
  --     },
  --     {
  --       "zR",
  --       function()
  --         require("ufo").openAllFolds()
  --       end,
  --       desc = "open all folds",
  --     },
  --   },
  --   opts = {
  --     ---@diagnostic disable-next-line: unused-local
  --     provider_selector = function(bufnr, filetype, buftype)
  --       return { "treesitter", "indent" }
  --     end,
  --   },
  -- },
  {
    "SmiteshP/nvim-navbuddy",
    dependencies = {
      "SmiteshP/nvim-navic",
      "MunifTanjim/nui.nvim",
    },
    opts = { lsp = { auto_attach = true } },
    keys = {
      { "<leader>nb", "<cmd>Navbuddy<cr>", desc = "Navbuddy" },
    },
  },
  {
    "hedyhli/outline.nvim",
    lazy = true,
    cmd = { "Outline", "OutlineOpen" },
    keys = { -- Example mapping to toggle outline
      { "<leader>o", "<cmd>Outline<CR>", desc = "Toggle outline" },
    },
    opts = {
      outline_window = {
        auto_jump = true,
      },
    },
  },
  {
    "ibhagwan/fzf-lua",
    -- optional for icon support
    dependencies = { "nvim-tree/nvim-web-devicons" },
    lazy = "VeryLazy",
    keys = {
      { "<leader>lf", "<cmd>FzfLua files<cr>" },
    },
    -- config = true,
    -- config = function()
    --   -- calling `setup` is optional for customization
    --   require("fzf-lua").setup({})
    -- end,
  },
}
