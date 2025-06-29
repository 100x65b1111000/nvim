local M = {}

---@alias StatusLineConfig StatusLineDefaultConfig

---@param opts StatusLineConfig
M.setup = function(opts)
	require("ui.statusline.autocmds")
	local utils = require("ui.statusline.utils")
	utils.initialize_stl(opts)
	vim.api.nvim_set_option_value("statusline", "%{%v:lua.require('ui.statusline.utils').set_statusline()%}", {})
end

return M
