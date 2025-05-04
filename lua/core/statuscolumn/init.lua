local states = require("core.statuscolumn.states")
local utils = require("core.statuscolumn.utils")

require('core.statusline.autocmds')

local M = {}

M.render_statuscolumn = function()
	local wins = vim.api.nvim_list_wins()
	utils.set_win_opt(wins)
end

return M
