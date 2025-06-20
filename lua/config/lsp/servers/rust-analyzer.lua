vim.lsp.config("rust-analyzer", {
	cmd = {
		"rust-analyzer",
	},
	filetypes = { "rust" },
})

vim.lsp.enable("rust-analyzer")
