local utils = require("config.lsp.lsputils")

vim.lsp.config("taplo", {
    cmd = { 'taplo', 'lsp', 'stdio' },
	filetypes = { "toml" },
    root_dir = utils.find_root(nil, true)
})

vim.lsp.enable("taplo")

-- require("lspconfig").taplo.setup({
-- 	on_attach = function(client, bufnr)
-- 		utils.on_attach(client, bufnr)
-- 	end,
-- 	capabilities = utils.lsp_capabilities
-- })
