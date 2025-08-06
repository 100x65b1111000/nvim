require("core.opts")
require("core.keymaps")
require("lazy-config")
require("core.abbr")
require("ui").setup({
	enabled = true,
	statusline = { enabled = true, left = { separator = { left = "", right = "" } } },
	tabline = { enabled = true, hide_misc_buffers = true },
})
require("config.lsp")
