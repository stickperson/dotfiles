home = print(os.getenv("HOME"))
return {
  "epwalsh/obsidian.nvim",
  version = "*", -- recommended, use latest release instead of latest commit
  -- ft = "markdown",
  -- lazy = true,
  event = {
    -- If you want to use the home shortcut '~' here you need to call 'vim.fn.expand'.
    -- E.g. "BufReadPre " .. vim.fn.expand "~" .. "/my-vault/**.md"
    "BufReadPre "
      .. vim.fn.expand("~")
      .. "/projects/obsidian/**.md",
    "BufNewFile " .. vim.fn.expand("~") .. "/projects/obsidian/**.md",
  },
  opts = {
    workspaces = {
      {
        name = "obsidian",
        path = "~/projects/obsidian",
      },
    },
  },
}
