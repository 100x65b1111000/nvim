local utils = require("ui.statusline_new.utils")

local buf_status_augroup = vim.api.nvim_create_augroup("StatusLineGitFileStatus", { clear = true })
vim.api.nvim_create_autocmd({ "FocusLost", "BufEnter", "BufWritePost", "FocusGained", "InsertLeave" }, {
	group = buf_status_augroup,
	callback = function()
		if utils.buf_is_file() then
			utils.fetch_git_file_stat()
			utils.fetch_git_file_diff()
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


vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
	group = buf_status_augroup,
	callback = function()
		if utils.buf_is_file() then
			utils.fetch_lsp_info()
			vim.cmd('redrawstatus')
		end
	end,
})
