return {
  {
    "pwntester/octo.nvim",
    lazy = false,
    dependencies = {
      "nvim-lua/plenary.nvim",
      "nvim-telescope/telescope.nvim",
      "nvim-tree/nvim-web-devicons",
    },
    opts = {
      mappings = {
        submit_win = {
          approve_review = { lhs = "<leader>ga", desc = "approve review" },
          comment_review = { lhs = "<C-m>", desc = "comment review" },
          request_changes = { lhs = "<C-r>", desc = "request changes review" },
          close_review_tab = { lhs = "<C-c>", desc = "close review tab" },
        },
      },
      suppress_missing_scope = {
        projects_v2 = true,
      },
    },
  },
  {
    "tpope/vim-fugitive",
    cmd = "Git",
    lazy = false,
  },
}
