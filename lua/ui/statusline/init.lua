local M = {}

---@param opts StatusLineConfig
M.setup = function(opts)
	opts = opts or {}
	if opts.enabled then
		require("ui.statusline.autocmds")
		local utils = require("ui.statusline.utils")
		utils.initialize_stl(opts)
		vim.api.nvim_set_option_value("statusline", "%{%v:lua.require('ui.statusline.utils').set_statusline()%}", {})
	else
		vim.api.nvim_set_option_value("statusline", "", {})
	end
end

return M
