vim.g.mapleader = " "
vim.g.maplocalleader = ","
vim.opt.timeoutlen = 200

vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.opt.termguicolors = true

require("config.options")
require("config.lazy")
require("config.keymaps")
