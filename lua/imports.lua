require("core.opts")
require("core.keymaps")
require("lazy-config")
require("core.abbr")
require("ui").setup({
	enabled = true,
	statusline = { left = { separator = { left = "", right = "" } } },
})
require("config.lsp")
