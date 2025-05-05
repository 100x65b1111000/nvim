local M = {
	"nvim-lualine/lualine.nvim",
	enabled = false,
	config = function ()
		require('lualine').setup()
	end
}

return M
