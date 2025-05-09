require("core.keymaps")
require("core.opts")
require("core.abbr")
require("lazy-config")
require("config.lsp")
require("ui.tabline.autocmds")
require("ui.statusline").setup({ modules = { }})

-- vim.opt.statusline = [[%!v:lua.require('ui.statusline').stl()]]
vim.opt.tabline = [[%!v:lua.require('ui.tabline').tabline()]]
-- vim.o.statuscolumn = [[%!v:lua.require('core.statuscolumn').statuscolumn()]]
