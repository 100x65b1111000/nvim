local tabline_augroup = vim.api.nvim_create_augroup("TablineBuffers", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufUnload", "BufDelete", "VimResized" }, {
	callback = function()
		local utils = require("ui.tabline.utils")
		utils.update_tabline_buffer_info()
	end,
	group = tabline_augroup,
})
