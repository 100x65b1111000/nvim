vim.lsp.config("bash-language-server", {
	cmd = {
		"bash-language-server",
		"start",
	},
	filetypes = { "sh", "bash" },
	-- settings = {
	-- },
})

vim.lsp.enable("bash-language-server")
