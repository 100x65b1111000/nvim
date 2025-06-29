local M = {}

local reset_cache = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if vim.api.nvim_buf_is_valid(bufnr) then
		vim.api.nvim_buf_set_var(bufnr, "_extmark_cache", {})
	end
end

M.setup = function()
	vim.api.nvim_create_augroup("StatusColumnRefresh", { clear = true })
	vim.api.nvim_create_autocmd(
		{
			"BufWrite",
			"BufEnter",
			"TextChanged",
			"TextChangedI",
			"FocusGained",
			"LspAttach",
			"DiagnosticChanged",
			"CursorHold",
		},
		{
			group = "StatusColumnRefresh",
			callback = function(args)
				reset_cache(args.buf)
				vim.schedule(function()
					vim.cmd([[redrawstatus]])
				end)
			end,
		}
	)
	vim.api.nvim_set_option_value("statuscolumn", "%!v:lua.require('ui.statuscolumn.utils').set_statuscolumn()", {})
end

return M
