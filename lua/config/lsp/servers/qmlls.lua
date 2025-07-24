local utils = require("config.lsp.lsputils")
vim.lsp.config("qmlls", {
	cmd = {
		"qmlls",
		"-E",
	},
	root_dir = utils.find_root(),
	filetypes = { "qml" },
})

vim.lsp.enable("qmlls")
