local utils = require("ui.statusline.utils")
local statusline_fetchers = vim.api.nvim_create_augroup("StatusLineFetchers", { clear = true })

vim.api.nvim_create_autocmd({ "FocusLost", "BufReadPost", "BufWritePost", "FocusGained", "InsertLeave" }, {
	group = statusline_fetchers,
	callback = function()
		if utils.buf_is_file() then
			utils.fetch_git_file_stat()
			utils.fetch_git_file_diff()
			vim.cmd("redrawstatus")
		end
	end,
})

vim.api.nvim_create_autocmd({ "BufReadPost" }, {
	group = statusline_fetchers,
	callback = function()
		if utils.buf_is_file() then
			utils.fetch_git_branch()
			vim.cmd("redrawstatus")
		end
	end,
})

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
	group = statusline_fetchers,
	callback = function()
		if utils.buf_is_file() then
			utils.fetch_lsp_info()
			vim.cmd("redrawstatus")
		end
	end,
})

-- vim.api.nvim_create_autocmd({ ""})
