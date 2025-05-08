-- local states = require('ui.statusline_new.states')
require('ui.statusline_new.autocmds')

local M = {}

---@alias StatusLineConfig StatusLineDefaultConfig

---@param opts StatusLineConfig
M.setup = function(opts)
	local utils = require("ui.statusline_new.utils")
	utils.initialize_stl(opts)

	vim.o.statusline = [[%!v:lua.require('ui.statusline_new.utils').set_statusline()]]
	-- vim.o.statusline = [[%#DiagnosticWarn# statusline :-)]]
end

return M
