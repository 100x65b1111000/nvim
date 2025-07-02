require("core.opts")
require("core.keymaps")
require("lazy-config")
require("core.abbr")
require("ui.tabline").setup()
---@diagnostic disable-next-line: missing-fields
require("ui.statusline").setup({
---@diagnostic disable-next-line: missing-fields
	left = { separator = { right = "" } },
})
require("ui.statuscolumn").setup()
require("config.lsp")
