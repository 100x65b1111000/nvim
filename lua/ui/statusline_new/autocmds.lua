local utils = require("ui.statusline_new.utils")

local buf_status_augroup = vim.api.nvim_create_augroup("StatusLineFileStatus", { clear = true })
vim.api.nvim_create_autocmd({ "ModeChanged" }, {
	group = buf_status_augroup,
	callback = function()
		utils.update_statusline_mode()
		vim.cmd[[ redrawstatus ]]
	end,
})
