vim.lsp.config("qmlls", {
	cmd = {
		"qmlls",
		"-E",
	},
	filetypes = { "qml" },
})

vim.lsp.enable("qmlls")
