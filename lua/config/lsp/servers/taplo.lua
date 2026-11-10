vim.lsp.config("taplo", {
	cmd = { "taplo", "lsp", "stdio", "--log-spans" },
	filetypes = { "toml" },
})

vim.lsp.enable("taplo")
