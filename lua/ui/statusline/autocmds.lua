local statusline_fetchers = vim.api.nvim_create_augroup("StatusLineFetchers", { clear = true })

vim.api.nvim_create_autocmd(
	{ "BufReadPost", "BufWritePost", "FocusGained", "InsertLeave", "CmdlineLeave", "TermLeave" },
	{
		group = statusline_fetchers,
		callback = function()
			local utils = require("ui.statusline.utils")
			local buf_is_file = utils.buf_is_file
			local fetch_git_file_diff = utils.fetch_git_file_diff
			local fetch_git_file_stat = utils.fetch_git_file_stat
			if utils.buf_is_file() then
				vim.schedule(function()
					fetch_git_file_stat()
					fetch_git_file_diff()
					vim.cmd("redrawstatus")
				end)
			end
		end,
	}
)

vim.api.nvim_create_autocmd({ "BufEnter", "CmdLineLeave" }, {
	group = statusline_fetchers,
	callback = function()
		local utils = require("ui.statusline.utils")
		if utils.buf_is_file() then
			vim.schedule(function()
				utils.fetch_git_branch()
				vim.cmd("redrawstatus")
			end)
		end
	end,
})

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
	group = statusline_fetchers,
	callback = function()
		local utils = require("ui.statusline.utils")
		if utils.buf_is_file() then
			utils.fetch_lsp_info()
			vim.cmd("redrawstatus")
		end
	end,
})

vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
	group = statusline_fetchers,
	callback = function()
		local utils = require("ui.statusline.utils")
		if utils.buf_is_file() then
			utils.fetch_diagnostics()
			vim.cmd("redrawstatus")
		end
	end,
})
