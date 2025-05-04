local utils = require("config.lsp.lsputils")
vim.lsp.config("jsonls", {
	cmd = {
		"vscode-json-language-server",
		"--stdio",
	},
	root_dir = utils.find_root(),
	filetypes = { "json", "jsonc" },
})

vim.lsp.enable("jsonls")
