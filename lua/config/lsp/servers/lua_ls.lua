---@type vim.lsp.Client
vim.lsp.config("lua_ls",{
	cmd = {
		"lua-language-server"
	},
	filetypes = { "lua" },
	settings = {
		Lua = {
			runtime = {
				version = "LuaJIT",
			},
			workspace = {
				checkThirdParty = false,
				library = {
					vim.fn.expand "$VIMRUNTIME/lua",
					vim.fn.expand "$VIMRUNTIME/lua/vim/lsp",
					vim.fn.expand "$VIMRUNTIME/lua/vim/treesitter",
					vim.fn.expand "$VIMRUNTIME/lua/vim/provider",
					vim.fn.expand "$VIMRUNTIME/lua/vim/filetype",
					vim.fn.expand "$VIMRUNTIME/lua/vim/func",
					vim.fn.expand "$VIMRUNTIME/lua/vim/deprecated",
					vim.fn.expand "$VIMRUNTIME/lua/vim/health",
					vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
					"${3rd}/luv/library"
				}
			},
			completion = {
				autoRequire = true,
				callSnippet = "Both",
				displayContext = 5,
				enable = true,
				keywordSnippet = "Both",
				portfix = ".",
				showWord = "Enable",
			},
			diagnostics = {
				globals = { "vim", "scroll" },
			},
			doc = {
				privateName = { "^_" },
			},
			hint = {
				enable = true,
			},
			signatureHelp = {
				enable = true,
			},
			telemetry = {
				enable = false,
			},
			format = {
				enable = false,
			},
		},
	},
})

vim.lsp.enable('lua_ls')
