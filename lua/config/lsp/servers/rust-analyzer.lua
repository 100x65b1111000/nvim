vim.lsp.config("rust-analyzer", {
	cmd = {
		"rust-analyzer",
	},
	filetypes = { "rust" },
	settings = {
		["rust-analyzer"] = {
			diagnostics = {
				enable = false,
				experimental = {
					enable = true,
				},
				styleLints = {
					enable = true,
				},
			},
			check = {
				command = "clippy",
			},
		},
	},
})

vim.lsp.enable("rust-analyzer")
