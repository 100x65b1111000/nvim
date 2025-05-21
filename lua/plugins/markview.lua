local P = {
	"OXY2DEV/markview.nvim",
	lazy = true,
	ft = { "markdown", "yaml", "html", "latex" },
	dependencies = {
		"nvim-treesitter/nvim-treesitter",
		"echasnovski/mini.icons",
	},
}

P.config = function()
	require("markview").setup({
		preview = {
			enabled = false,
			icon_provider = "mini",
		},
	})
end

return P
