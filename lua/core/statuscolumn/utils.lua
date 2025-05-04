local states = require("core.statuscolumn.states")

local M = {}

local fetch_git_sign = function()
	local ok, gitsigns = pcall(require, "gitsigns")
	if not ok then
		return ""
	end

	-- gitsigns.
end

---Checks if a buffer is valid for display in the tabline.
---@param bufnr integer The buffer number to check.
---@return boolean True if the buffer is valid, false otherwise.
local function buf_is_valid(bufnr)
	return vim.api.nvim_buf_get_name(bufnr) ~= ""
		and (vim.bo[bufnr].buftype == "")
		and vim.fn.isdirectory(vim.api.nvim_buf_get_name(bufnr)) == 0
		and vim.api.nvim_buf_is_loaded(bufnr)
end

local function win_is_valid(winnr)
	local bufnr = vim.api.nvim_win_get_buf(winnr)
	return buf_is_valid(bufnr)
end

local set_win_opts = function (wins)
	for _, i in ipairs(wins) do
		if win_is_valid(i) then
			vim.wo[i].statuscolumn = states.statuscolumn_string
		end
	end
end

M.buf_is_valid = buf_is_valid
M.win_is_valid = win_is_valid
M.set_win_opt = set_win_opts

return M
