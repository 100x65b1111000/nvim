local M = {}

local reset_cache = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	vim.api.nvim_buf_set_var(bufnr, "_extmark_cache", {})
end

M.setup = function()
	vim.api.nvim_create_augroup("StatusColumnRefresh", { clear = true })
	vim.api.nvim_create_autocmd({ "BufEnter", "BufWritePost", "DiagnosticChanged", "TextChanged", "CursorMoved" }, {
		group = "StatusColumnRefresh",
		callback = function(args)
			reset_cache(args.buf)
			vim.cmd[[redrawstatus]]
		end,
	})
	vim.schedule(function()
		vim.api.nvim_set_option_value("statuscolumn", "%!v:lua.require('ui.statuscolumn.utils').set_statuscolumn()", {})
	end)
end

return M
