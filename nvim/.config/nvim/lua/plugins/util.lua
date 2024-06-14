return {
  -- session management
  {
    "folke/persistence.nvim",
    event = "BufReadPre",
    -- opts = { options = { "buffers", "curdir", "tabpages", "winsize", "help" } },
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
    -- stylua: ignore
    keys = {
      { "<leader>qs", function() require("persistence").load() end, desc = "Restore Session" },
      { "<leader>ql", function() require("persistence").load({ last = true }) end, desc = "Restore Last Session" },
      { "<leader>qd", function() require("persistence").stop() end, desc = "Don't Save Current Session" },
    },
  },

  -- library used by other plugins
  { "nvim-lua/plenary.nvim", lazy = true },

  -- makes some plugins dot-repeatable like leap
  { "tpope/vim-repeat", event = "VeryLazy" },

  {
    "phaazon/mind.nvim",
    branch = "v2.2",
    cmd = { "MindOpenMain", "MindClose" },
    keys = {
      { "<leader>mo", "<cmd> MindOpenMain <cr>", "open mind" },
      { "<leader>mc", "<cmd> MindClose <cr>", "close mind" },
    },
    config = true,
  },
}
