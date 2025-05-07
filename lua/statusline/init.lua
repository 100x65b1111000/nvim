local mini_icons = require("mini.icons")
-- require("core.statusline.autocmds")
local utils = require("core.statusline.utils")

local Modes = {
	["n"] = "NORMAL",
	["no"] = "OPERATOR",
	["v"] = "VISUAL",
	["V"] = "VISUAL LINE",
	[""] = "VISUAL BLOCK",
	["s"] = "SELECT",
	["s"] = "SELECT",
	["S"] = "SELECT LINE",
	[""] = "SELECT BLOCK",
	["i"] = "INSERT",
	["ic"] = "INSERT",
	["R"] = "REPLACE",
	["Rv"] = "VISUAL REPLACE",
	["c"] = "COMMAND",
	["cr"] = "COMMAND",
	["cv"] = "VIM EX",
	["cvr"] = "VIM EX",
	["ce"] = "EX",
	["r"] = "PROMPT",
	["rm"] = "MOAR",
	["r?"] = "CONFIRM",
	["!"] = "SHELL",
	["t"] = "TERMINAL",
	["nt"] = "TERMINAL",
	["ntT"] = "TERMINAL",
}

local get_mode = function(sep)
	local m = vim.api.nvim_get_mode().mode
	local mode = Modes[m] or "NORMAL"
	local mode_hl = utils.generate_mode_hl(m)
	return string.format("%%#%s#%s%s ", mode_hl, "  ", mode)
end

local cursor_position = function()
	local row_col = "%#StatusLineCursorPos# %l:%v " .. "%#StatusLineCursorIcon#" .. "  "
	-- local row_col = string.format("(%l, %c)", pos[2], pos[3])
	return row_col
end

local process_buffer_name = function()
	local bufname = vim.fn.expand("%:p:t")
	local init_files = _G.init_files or { "init.lua" }
	if vim.list_contains(init_files, bufname) then
		bufname = vim.fn.expand("%:h:t") .. "/" .. bufname
	end

	return bufname
end

---@return string
local file = function()
	local buftype = vim.bo[0].buftype
	local file_name = " " .. process_buffer_name()
	local filetype = vim.bo[0].filetype
	local file_icon = nil
	local file_icon_hl = "Normal"
	if buftype == "" then
		file_icon, file_icon_hl = mini_icons.get("file", vim.fn.expand("%t"))
		file_icon = string.format("%%#%s# %s", file_icon_hl, file_icon)
	elseif buftype == "help" then
		file_icon, file_icon_hl = mini_icons.get("filetype", "help")
		file_icon = string.format("%%#%s# %s", file_icon_hl, file_icon)
	elseif buftype == "prompt" then
		file_icon = "%#MiniIconsCyan# 󰘎 "
	elseif buftype == "terminal" then
		file_icon = "%#MiniIconsYellow#  "
	else
		file_name = " " .. filetype
		file_icon = ""
	end
	return "%#StatusLineFile#" .. file_icon .. "%#StatusLineFile#" .. file_name .. " "
end

local modified_status = function()
	if vim.bo.modified then
		return " %m "
	end
	return ""
end

local status_ro = function()
	if vim.bo.readonly then
		return " %r "
	end
	return ""
end

local stl_sep_right = function(hl, sep)
	return string.format("%%#%s#%s", hl, sep)
end

local stl_file_status = function ()
	local file_status_hl = utils.generate_highlight("MiniIconsOrange", "StatusLineNormalMode", {}, -50, "StatusLineFileStatus").hl_string
	return string.format("%%#%s#%s", file_status_hl, modified_status() .. status_ro())
end

local M = {}

---@return string
M.stl = function()
	local left_items = {
		get_mode(),
		stl_file_status(),
		utils.get_buffer_info(),
	}
	local middle_items = {
		vim.b.stl_cwd
			or ("%#StatusLineCwdIcon#  %#StatusLineHl#" .. vim.fn.fnamemodify(vim.uv.cwd() or "", ":~:.") .. " "),
		vim.b.stl_git_branch or "",
		vim.b.stl_file_git_status,
	}
	local right_items = {
		vim.b.stl_diagnostics_info or "",
		vim.b.stl_lsp_info or "",
		cursor_position(),
		utils.scroll_perc(),
	}

	local format_items = function(items, sep)
		if items == {} or items == nil then
			return ""
		end
		return table.concat(items, sep)
	end

	local left = format_items(left_items, "%#StatusLineHl#")
	local middle = format_items(middle_items, "%#StatusLineHl#")
	local right = format_items(right_items, "%#StatusLineHl#")

	local main = {
		left,
		middle,
		right,
	}

	-- local stl = vim.fn.flatten(main, 2)

	return table.concat(main, "%#StatusLineHl#%=")
end

return M
