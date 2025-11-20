return {
  {
    "mfussenegger/nvim-dap-python",
    ft = "python",
    dependencies = {
      "mfussenegger/nvim-dap",
      "rcarriga/nvim-dap-ui",
    },
    config = function()
      local dap = require("dap")
      local dap_python = require("dap-python")

      -- Use debugpy through uv
      dap_python.setup("uv")

      -- TODO: determine how to set this on a per-project basis
      dap_python.test_runner = "pytest"

      -- Launch configuration for debugging a single file
      dap.configurations.python = {
        {
          type = "python",
          request = "launch",
          name = "Launch current file",
          program = "${file}",
          console = "integratedTerminal",
          justMyCode = false,
        },
      }

      -- Keymaps to switch test runners
      vim.keymap.set("n", "<leader>dpp", function()
        dap_python.test_runner = "pytest"
        print("dap-python: pytest")
      end, { desc = "Set test runner: pytest" })

      vim.keymap.set("n", "<leader>dpu", function()
        dap_python.test_runner = "unittest"
        print("dap-python: unittest")
      end, { desc = "Set test runner: unittest" })

      -- Keymaps for running/debugging tests
      vim.keymap.set("n", "<leader>tm", function()
        dap_python.test_method()
      end, { desc = "Debug test under cursor" })

      vim.keymap.set("n", "<leader>tc", function()
        dap_python.test_class()
      end, { desc = "Debug tests in class" })

      -- Debug all tests in file (works for latest nvim-dap-python)
      vim.keymap.set("n", "<leader>tf", function()
        if dap_python.test_file then
          dap_python.test_file()
        else
          -- fallback for older versions
          local file = vim.fn.expand("%")
          dap.run({
            type = "python",
            request = "launch",
            name = "Debug all tests in file",
            program = "uv",
            args = { "-m", "pytest", file },
            console = "integratedTerminal",
            justMyCode = false,
          })
        end
      end, { desc = "Debug all tests in file" })
    end,
  },
  {
    "rcarriga/nvim-dap",
    lazy = true,
    keys = {
      { "<leader>db", "<cmd>DapToggleBreakpoint<CR>", desc = "Toggle Breakpoint" },
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
    config = function()
      local dap, dapui = require("dap"), require("dapui")
      dapui.setup()

      -- Open UI automatically on session start
      dap.listeners.before.attach.dapui_config = function()
        dapui.open()
      end
      dap.listeners.before.launch.dapui_config = function()
        dapui.open()
      end

      -- Optional keymap to close UI manually
      vim.keymap.set("n", "<leader>du", function()
        dapui.close()
      end, { desc = "Close DAP UI" })
    end,
  },
}
