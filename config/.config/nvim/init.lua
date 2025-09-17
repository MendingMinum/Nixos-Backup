-- key
vim.g.mapleader = " "
vim.g.maplocalleader = " "

-- Lazy
require("config.lazy")
require('config.keymaps').setup()
require("config.tab").setup()

-- Config

-- number
vim.opt.number = true

-- status
vim.o.laststatus = 0

-- tab status
vim.o.showtabline = 0

