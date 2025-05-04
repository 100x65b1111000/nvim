require("core.keymaps")
require("core.opts")
require("core.abbr")
require("lazy-config")
require("config.lsp")
require("core.tabline.autocmds")
require("core.statusline.autocmds")

vim.opt.statusline = [[%!v:lua.require('core.statusline').stl()]]
vim.opt.tabline = [[%!v:lua.require('core.tabline').tabline()]]
-- vim.o.statuscolumn = [[%!v:lua.require('core.statuscolumn').statuscolumn()]]
