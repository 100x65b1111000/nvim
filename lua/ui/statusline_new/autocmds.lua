local utils = require("ui.statusline_new.utils")

local buf_status_augroup = vim.api.nvim_create_augroup("StatusLineFileStatus", { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "BufEnter", "BufWritePost", "FocusGained" }, {
	group = buf_status_augroup,
	callback = function()
		if utils.buf_is_file() then
			utils.fetch_git_file_stat(100, 0)
			vim.cmd('redrawstatus')
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	group = buf_status_augroup,
	callback = function()
		if utils.buf_is_file() then
			utils.fetch_git_branch()
			vim.cmd('redrawstatus')
		end
	end,
})
