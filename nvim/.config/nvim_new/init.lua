-- Leader must be set before plugins load
vim.g.mapleader = " "
vim.g.maplocalleader = "\\"

-- Mason-installed tools on PATH before any plugins start
vim.env.PATH = vim.fn.stdpath("data") .. "/mason/bin:" .. vim.env.PATH

require("config.options")
require("config.keymaps")
require("config.autocmds")
require("config.lazy")
