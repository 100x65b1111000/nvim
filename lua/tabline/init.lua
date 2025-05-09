-- init.lua
local utils = require("core.tabline.utils")
local states = require("core.tabline.states")

local M = {}

---@return string The complete tabline string for Neovim's 'tabline' option.
M.tabline = function()
	utils.update_tabline_buffer_string()
	return states.cache.tabline_buf_string
end

return M
