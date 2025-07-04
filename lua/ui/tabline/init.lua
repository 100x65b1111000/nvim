local M = {}

M.setup = function(opts)
	opts = opts or {}
	if opts.enabled then
		require("ui.tabline.autocmds")
		vim.api.nvim_set_option_value("tabline", [[%!v:lua.require('ui.tabline.utils').get_tabline()]], {})
	else
		vim.api.nvim_set_option_value("tabline", "", {})
	end
end

return M
