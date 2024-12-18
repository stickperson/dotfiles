return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      -- Use debugpy from mason
      require("dap-python").setup(vim.fn.stdpath("data") .. "/mason" .. "/packages/debugpy/venv/bin/python")
    end,
  },
  {
    "rcarriga/nvim-dap",
    lazy = true,
    keys = {
      {
        "<leader>db",
        "<cmd> DapToggleBreakpoint <CR>",
        desc = "Toggle Breakpoint",
      },
      {
        "<leader>dc",
        function()
          require("dap").continue()
        end,
        desc = "Dap continue",
      },
      {
        "<leader>dso",
        function()
          require("dap").step_over()
        end,
        desc = "Dap step over",
      },
      {
        "<leader>dsi",
        function()
          require("dap").step_into()
        end,
        desc = "Dap step into",
      },
      {
        "<leader>do",
        function()
          require("dap").step_out()
        end,
        desc = "Dap step out",
      },
    },
  },
  {
    "rcarriga/nvim-dap-ui",
    dependencies = { "mfussenegger/nvim-dap", "nvim-neotest/nvim-nio" },
    lazy = true,
    -- config fn comes from the README
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.event_terminated.dapui_config = function()
        dapui.close()
      end
      dap.listeners.before.event_exited.dapui_config = function()
        dapui.close()
      end
    end,
  },
}
