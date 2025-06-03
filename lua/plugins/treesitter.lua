local P = {
	"nvim-treesitter/nvim-treesitter",
	event = "BufAdd",
	build = ":TSUpdate",
	config = function()
		require("nvim-treesitter")
		local configs = require("nvim-treesitter.configs")
		---@diagnostic disable-next-line: missing-fields
		configs.setup({
			ensure_installed = { "c", "lua", "vim", "vimdoc", "query", "elixir", "heex", "javascript", "html" },
			sync_install = false,
			highlight = { enable = true },
			indent = { enable = true },
		})
	end,
}

return P
