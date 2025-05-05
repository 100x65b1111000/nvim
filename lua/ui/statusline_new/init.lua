local utils = require('ui.statusline_new.utils')
local states = require('ui.statusline_new.states')

local M = {}

---@alias StatusLineConfig StatusLineDefaultConfig

---@param opts StatusLineConfig
M.setup = function(opts)
	if opts then
		opts = vim.tbl_deep_extend('force', states.default_config, opts)
		utils.set_statusline(opts)
		return
	end
	utils.set_statusline(opts)
	vim.o.statusline = [[%!v:lua.require('ui.statusline_new.states').cache.statusline_string]]
end

return M
