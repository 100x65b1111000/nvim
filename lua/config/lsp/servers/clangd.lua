vim.lsp.config("clangd", {
	cmd = { "clangd", "--offset-encoding=utf-16" },
	filetypes = { "c", "cpp" },
	settings = {},
})

vim.lsp.enable("clangd")
