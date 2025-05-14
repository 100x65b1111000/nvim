require("core.keymaps")
require("core.opts")
require("core.abbr")
require("lazy-config")
require("config.lsp")
require("ui.statusline").setup({})
require("ui.tabline").setup()
require("ui.statuscolumn").setup()

-- vim.opt.statusline = [[%!v:lua.require('ui.statusline').stl()]]
-- vim.o.statuscolumn = [[%!v:lua.require('core.statuscolumn').statuscolumn()]]
