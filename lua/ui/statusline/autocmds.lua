local statusline_fetchers = vim.api.nvim_create_augroup("StatusLineFetchers", { clear = true })

vim.api.nvim_create_autocmd(
	{ "BufReadPost", "BufWritePost", "FocusGained", "InsertLeave", "TermLeave", "CmdlineLeave" },
	{
		group = statusline_fetchers,
		callback = function()
			local utils = require("ui.statusline.utils")
			local fetch_git_file_diff = utils.fetch_git_file_diff
			local fetch_git_file_stat = utils.fetch_git_file_stat
			if utils.buf_is_file() then
				fetch_git_file_stat()
				fetch_git_file_diff()
				vim.schedule(function()
					vim.cmd("redrawstatus")
				end)
			end
		end,
	}
)

vim.api.nvim_create_autocmd({ "BufEnter", "CmdlineLeave" }, {
	group = statusline_fetchers,
	callback = function()
		local utils = require("ui.statusline.utils")
		local fetch_git_branch = utils.fetch_git_branch
		if utils.buf_is_file() then
			fetch_git_branch()
			vim.schedule(function()
				vim.cmd("redrawstatus")
			end)
		end
	end,
})

vim.api.nvim_create_autocmd({ "LspAttach", "LspDetach" }, {
	group = statusline_fetchers,
	callback = function()
		local utils = require("ui.statusline.utils")
		utils.fetch_lsp_info()
		if utils.buf_is_file() then
			vim.cmd("redrawstatus")
		end
	end,
})

vim.api.nvim_create_autocmd({ "DiagnosticChanged" }, {
	group = statusline_fetchers,
	callback = function()
		local utils = require("ui.statusline.utils")
		local fetch_diagnostics = utils.fetch_diagnostics
		if utils.buf_is_file() then
			fetch_diagnostics()
			vim.schedule(function ()
				vim.cmd("redrawstatus")
			end)
		end
	end,
})
