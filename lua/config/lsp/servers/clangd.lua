vim.lsp.config("clangd", {
	cmd = { "clangd", "--clang-tidy", "--offset-encoding=utf-16", "--background-index" },
	filetypes = { "c", "cpp" },
	settings = {},
})

vim.lsp.enable("clangd")
