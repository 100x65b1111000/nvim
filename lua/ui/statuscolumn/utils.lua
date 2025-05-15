local M = {}

local signs_cache = {}
local cache = {}
local icon_cache = {}

M.get_folds = function()
	vim.api.nvim_win_call()
end

M.get_extmark_info = function()
	local signs = {}
	local extmarks = vim.api.nvim_buf_get_extmarks(0, -1, 0, -1, { details = true, type = "sign" })
	for _, extmark in pairs(extmarks) do
		local line = extmark[2] + 1
		signs[line] = signs[line] or {}
		local name = extmark[4].sign_hl_group or extmark[4].sign_name
		signs[line] = {
			name = name,
			text = extmark[4].sign_text,
			text_hl = extmark[4].sign_hl_group,
			priority = extmark[4].priority,
		}
	end
	return signs
end

M.set_statuscolumn = function()
	vim.api.nvim_win_get_cursor(0)
	vim.fn.getcurpos(0)
	return "%s %l %C"
end

return M
