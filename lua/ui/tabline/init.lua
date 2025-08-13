local M = {}

M.setup = function(opts)
	opts = opts or {}
	if opts.enabled then
		local utils = require("ui.tabline.utils")
		require("ui.tabline.autocmds")
		utils.initialize_tabline(opts)
		vim.api.nvim_set_option_value("tabline", [[%!v:lua.require('ui.tabline.utils').get_tabline()]], {})
		vim.g.ui_tabline_enabled = true
	else
		vim.api.nvim_set_option_value("tabline", "", {})
		vim.g.ui_tabline_enabled = false
	end
end

return M
