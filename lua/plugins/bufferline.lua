local M = {
	"akinsho/bufferline.nvim",
	event = { "BufEnter" },
	enabled = false,
	config = function()
		require("bufferline").setup()
	end
}

return M
