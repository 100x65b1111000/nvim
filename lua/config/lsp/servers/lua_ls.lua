local utils = require("config.lsp.lsputils")
---@type vim.lsp.Client
vim.lsp.config("lua_ls",{
	cmd = {
		"lua-language-server"
	},
	filetypes = { "lua" },
	on_init = function(client)
		-- Check for config files
		if client.workspace_folders then
			local path = client.workspace_folders[1].name
			-- Don't load default config if .luarc.json exists
			if vim.uv.fs_stat(path .. "/.luarc.json") or vim.uv.fs_stat(path .. "/.luarc.jsonc") then
				return
			end
		end
	end,
	-- cmd_cwd = utils.find_root({ ".git", "luarc.json", ".luarc.json", ".luarc.jsonc", ".stylua.toml" }),
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
					vim.fn.expand "VIMRUNTIME/lua/vim/deprecated",
					vim.fn.expand "VIMRUNTIME/lua/vim/health",
					vim.fn.stdpath("data") .. "/lazy/lazy.nvim/lua/lazy",
					"${3rd}/luv/library"
					-- "home/dex/.config/nvim/"
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
				globals = { "vim" },
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
