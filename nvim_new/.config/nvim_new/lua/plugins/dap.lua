return {
  {
    "mfussenegger/nvim-dap",
    dependencies = {
      "rcarriga/nvim-dap-ui",
      "nvim-neotest/nvim-nio",
    },
    keys = {
      { "<leader>db", function() require("dap").toggle_breakpoint() end, desc = "Toggle breakpoint" },
      { "<leader>dc", function() require("dap").continue() end, desc = "Continue" },
      { "<leader>dso", function() require("dap").step_over() end, desc = "Step over" },
      { "<leader>dsi", function() require("dap").step_into() end, desc = "Step into" },
      { "<leader>dse", function() require("dap").step_out() end, desc = "Step out" },
      { "<leader>dR", function() require("dap").run_to_cursor() end, desc = "Run to cursor" },
      { "<leader>du", function() require("dapui").toggle() end, desc = "Toggle DAP UI" },
    },
    config = function()
      local dap = require("dap")
      local dapui = require("dapui")
      dapui.setup()
      dap.listeners.after.event_initialized["dapui_config"] = function() dapui.open() end
      dap.listeners.before.event_terminated["dapui_config"] = function() dapui.close() end
      dap.listeners.before.event_exited["dapui_config"] = function() dapui.close() end
    end,
  },

  -- Python debugging
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = { "mfussenegger/nvim-dap" },
    config = function()
      local debugpy = vim.fn.stdpath("data") .. "/mason/packages/debugpy/venv/bin/python"
      require("dap-python").setup(vim.fn.executable(debugpy) == 1 and debugpy or "python3")
    end,
  },

  { "nvim-neotest/nvim-nio", lazy = true },
  { "rcarriga/nvim-dap-ui", lazy = true, dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" } },
}
