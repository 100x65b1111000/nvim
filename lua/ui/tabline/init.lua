-- init.lua
local utils = require("ui.tabline.utils")
local states = require("ui.tabline.states")

local M = {}

---@return string The complete tabline string for Neovim's 'tabline' option.
M.tabline = function()
	utils.update_tabline_buffer_string()
	return states.cache.tabline_buf_string
end

return M
