vim.lsp.config("basedpyright", {
	cmd = {
		"basedpyright-langserver",
		"--stdio",
	},
	filetypes = { "python" },
	settings = {
		basedpyright = {
			analysis = {
				logLevel = "Error",
				inlayHints = {
					genericTypes = true,
				},
				useLibraryForCodeTypes = true,
				autoImportCompletions = true,
				diagnosticMode = "workspace",
				typeCheckingMode = "standard",
			},
			python = {},
		},
	},
})

vim.lsp.enable("basedpyright")
