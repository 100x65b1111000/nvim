local M = {}

M.setup = function ()
	-- local utils = require('ui.statucolumn.utils')
	vim.api.nvim_set_option_value('statuscolumn', "%!v:lua.require('ui.statuscolumn.utils').set_statuscolumn()", {})
end

return M
