vim.lsp.config("jsonls", {
	cmd = {
		"vscode-json-language-server",
		"--stdio",
	},
	filetypes = { "json", "jsonc" },
})

vim.lsp.enable("jsonls")
