local mini_icons = require("mini.icons")
local cache = require("statusline.cache")
local M = {}

---Truncates a string.
---@param string string The string to truncate.
---@param source_length integer The original string length.
---@param target_length integer The target string length.
---@return string The truncated string.
local function truncate_string(string, source_length, target_length)
	local ellipsis = "…"
	if source_length <= target_length then
		return string
	end
	return string.sub(string, 1, target_length - 1) .. ellipsis
end

---@param hl_name string The name of the highlight group.
---@return vim.api.keyset.get_hl_info The highlight information.
local function get_highlight(hl_name)
	local ok, hl = pcall(vim.api.nvim_get_hl, 0, { name = hl_name })
	if not ok or not hl then
		return { fg = 0xFFFFFF, bg = 0x000000 } -- Default colors
	end
	return hl
end

---Alters a color value.
---@param c integer The color value (0-255).
---@param val integer The percentage to alter the color by.
---@return integer The altered color value.
local function alter_color(c, val)
	return math.min(255, math.max(0, c * (1 + val / 100)))
end

---Alters the color of a hex string.
---@param hex string The hex color string (e.g., "#rrggbb").
---@param val integer The percentage to alter the color by.
---@return string The altered hex color string.
local function alter_hex_color(hex, val)
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)

	r, g, b = alter_color(r, val), alter_color(g, val), alter_color(b, val)

	return string.format("#%02x%02x%02x", r, g, b)
end

---Generates a highlight group.
---@param source_fg string The source highlight group for fg.
---@param source_bg string The source highlight group for bg.
---@param opts? table Additional highlight options.
---@param brightness integer Brightness value.
---@param new_name? string The new highlight group name.
---@return table The name of the generated highlight group.
local function generate_highlight(source_fg, source_bg, opts, brightness, new_name)
	opts = opts or {}
	local source_hl_fg = get_highlight(source_fg).fg
	local source_hl_bg = get_highlight(source_bg).bg
	local fallback_hl = get_highlight("Normal") -- User Normal as default hlgroup as fg and bg values are defined in it
	local fg = "#" .. string.format("%06x", source_hl_fg or fallback_hl.fg)
	-- local statusline_bg = "#" .. string.format("%06x", get_highlight("StatusLine").bg)
	local bg = "#" .. string.format("%06x", source_hl_bg or fallback_hl.bg)

	bg = alter_hex_color(bg, brightness)
	local suffix = ""
	local prefix = "StatusLine"
	local hl_opts = vim.tbl_extend("force", { fg = fg, bg = bg }, opts)
	local hl_string = new_name or prefix .. (source_fg or source_bg) .. suffix
	if not vim.tbl_contains(cache.generated_hl, hl_string) then
		-- vim.notify("Tabline: Generating highlight group: " .. hl_string) --debug purposes
		vim.api.nvim_set_hl(0, hl_string, hl_opts)
		table.insert(cache.generated_hl, hl_string)
	end
	return { hl_string = hl_string, fg = hl_opts.fg, bg = hl_opts.bg }
end

M.generate_highlight = generate_highlight

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
	local file_name = " " .. process_buffer_name() .. " "
	local filetype = vim.bo[0].filetype .. " "
	local file_icon, file_icon_hl = mini_icons.get("file", vim.fn.expand("%t"))
	file_icon_hl = generate_highlight(file_icon_hl, file_icon_hl, {}, 75).hl_string
	local file_name_hl =
		string.format("%%#%s#", generate_highlight("Normal", "Normal", {}, 75, "StatusLineFileName").hl_string)
	if buftype == "" then
		-- file_icon, file_icon_hl = mini_icons.get("file", vim.fn.expand("%t"))
		file_icon = string.format("%%#%s# %s", file_icon_hl, file_icon)
	elseif buftype == "help" then
		file_icon, file_icon_hl = mini_icons.get("filetype", "help")
		file_icon_hl = generate_highlight(file_icon_hl, file_icon_hl, {}, 75).hl_string
		file_icon = string.format("%%#%s# %s", file_icon_hl, file_icon)
	elseif buftype == "prompt" then
		file_name = filetype
		file_icon_hl = string.format(
			"%%#%s#",
			generate_highlight("MiniIconsCyan", "Normal", {}, 75, "StatusLinePromptIcon").hl_string
		)
		file_icon = file_icon_hl .. " 󰘎 "
	elseif buftype == "terminal" then
		file_name = filetype
		file_icon_hl = string.format(
			"%%#%s#",
			generate_highlight("MiniIconsYellow", "Normal", {}, 75, "StatusLineTermIcon").hl_string
		)
		file_icon = file_icon_hl .. "  "
	else
		file_name = " " .. filetype
		file_icon = ""
	end
	return file_icon .. file_name_hl .. file_name
end

M.get_buffer_info = file

---@param mode string
M.generate_mode_hl = function(mode)
	local hl_string = "StatusLineMode"
	if mode == "n" then
		hl_string = "StatusLineNormalMode"
	elseif mode == "v" or mode == "V" or mode == "" or mode == "s" then
		hl_string = "StatusLineVisualMode"
	elseif mode == "s" or mode == "S" or mode == "" then
		hl_string = "StatusLineSelectMode"
	elseif mode == "i" or mode == "ic" then
		hl_string = "StatusLineInsertMode"
	elseif mode == "c" then
		hl_string = "StatusLineCommandMode"
	elseif mode == "no" then
		hl_string = "StatusLineOperatorMode"
	elseif mode == "t" or mode == "nt" or mode == "ntT" then
		hl_string = "StatusLineTerminalMode"
	elseif mode == "!" then
		hl_string = "StatusLineShellMode"
	elseif vim.tbl_contains({ "R", "Rx", "Rc", "Rv", "Rvc", "Rvx" }, mode) then
		hl_string = "StatusLineReplaceMode"
	end
	return hl_string
end

local git_parent = function(path)
	return vim.fs.find({ ".git" }, { path = path, upward = true, stop = vim.env.HOME })[1]
end

local insertions = function(ins)
	if ins and ins ~= "0" and ins ~= "" then
		return "%#StatusLineGitInsertions# %#StatusLineHl#" .. ins
	end
	return ""
end

local deletions = function(del)
	if del and del ~= "0" and del ~= "" then
		return " %#StatusLineGitDeletions# %#StatusLineHl#" .. del
	end
	return ""
end

---@param mode string
M.get_mode_hl = function(mode)
	local mode_hl = "%#StatusLineMode#"
	if mode == "n" then
		mode_hl = "%#StatusLineNormal#"
	elseif mode == "v" or mode == "V" or mode == "" or mode == "s" then
		mode_hl = "%#StatusLineVisual#"
	elseif mode == "s" or mode == "S" or mode == "" then
		mode_hl = "%#StatusLineSelect#"
	elseif mode == "i" or mode == "ic" then
		mode_hl = "%#StatusLineInsert#"
	elseif mode == "c" then
		mode_hl = "%#StatusLineCommand#"
	elseif mode == "t" then
		mode_hl = "%#StatusLineTerm#"
	elseif vim.tbl_contains({ "R", "Rx", "Rc", "Rv", "Rvc", "Rvx" }, mode) then
		mode_hl = "%#StatusLineReplace#"
	end
	return mode_hl
end

---@param Modes table
---@param get_mode_hl function
M.get_mode = function(Modes, get_mode_hl)
	local m = vim.api.nvim_get_mode().mode
	local mode = Modes[m] or "NORMAL"
	return get_mode_hl(mode) .. "  " .. mode
end

M.scroll_perc = function()
	local total_lines = vim.fn.line("$") or 0
	local cur_line = vim.fn.line(".") or 0
	local hl_string_content = "%#StatusLineScrollPerc#"
	local scroll_perc_icon = "%#StatusLineScrollIcon#  "
	local scroll_str = hl_string_content

	if cur_line == 1 or total_lines == 0 or total_lines == 1 then
		scroll_str = hl_string_content .. " Top " .. scroll_perc_icon
	elseif cur_line == total_lines then
		scroll_str = hl_string_content .. " Bot " .. scroll_perc_icon
	else
		scroll_str = string.format("%%#StatusLineScrollPerc#%3d%s ", cur_line / total_lines * 100, "%%")
			.. scroll_perc_icon
	end

	return scroll_str
end

M.cursor_position = function()
	local pos = vim.fn.getcurpos(0)
	local row_col = string.format("(%d, %d)", pos[2], pos[3])
	return row_col
end

local format_diagnostics = function(severity, severity_map)
	local count = severity_map[severity].count
	local hl = severity_map[severity].hl
	local icon = severity_map[severity].icon
	if count > 0 then
		return hl .. icon .. count
	end

	return ""
end

M.update_diagnostics = function(bufnr)
	local severity_map = {
		["ERROR"] = { hl = "%#DiagnosticError#", icon = "  ", count = #vim.diagnostic.get(bufnr, { severity = 1 }) },
		["WARN"] = { hl = "%#DiagnosticWarn#", icon = "  ", count = #vim.diagnostic.get(bufnr, { severity = 2 }) },
		["INFO"] = { hl = "%#DiagnosticInfo#", icon = "  ", count = #vim.diagnostic.get(bufnr, { severity = 3 }) },
		["HINT"] = { hl = "%#DiagnosticHint#", icon = "  ", count = #vim.diagnostic.get(bufnr, { severity = 4 }) },
	}

	local diagnostic_str = format_diagnostics("ERROR", severity_map)
		.. format_diagnostics("WARN", severity_map)
		.. format_diagnostics("INFO", severity_map)
		.. format_diagnostics("HINT", severity_map)
	return diagnostic_str .. " "
end

M.buf_is_valid = function(bufnr)
	return vim.fn.expand("%:p") ~= "" and vim.bo[bufnr].buftype == "" and vim.bo[bufnr].filetype ~= ""
end

M.git_parent = git_parent

M.fetch_file_git_stat = function(file_path)
	local parent = git_parent(file_path)

	local git_status = ""

	-- vim.notify("git -C " .. parent .. " diff --numstat " .. file_path)
	--
	parent = parent:match("(.*)/[^/]*$")
	local git_cmd = "git --no-pager --no-optional-locks --literal-pathspecs -c gc.auto= -C "
	local git_diff_cmd = git_cmd .. parent .. " diff --numstat " .. file_path
	local diff_output_obj = vim.system({ "bash", "-c", git_diff_cmd }, { text = true }):wait()
	if diff_output_obj.code ~= 0 then
		return " " .. git_status
	end
	local diff_output = diff_output_obj.stdout
	if diff_output ~= "" and diff_output then
		local diff_split = vim.split(diff_output, "\t")
		git_status = insertions(diff_split[1]) .. deletions(diff_split[2])
	end

	local git_stat_cmd = git_cmd .. parent .. " status --short --porcelain " .. file_path
	local stat_output_obj = vim.system({ "bash", "-c", git_stat_cmd }, { text = true }):wait()
	if stat_output_obj.code ~= 0 then
		return " " .. git_status
	end
	local stat_output = stat_output_obj.stdout or ""
	local file_status = stat_output:match("[^%s]+")
	if not file_status then
		git_status = "%#StatusLineGitUptodate# " .. git_status
	elseif file_status == "??" then
		git_status = "%#StatusLineGitUnstaged# " .. git_status
	end

	return " " .. git_status
end

M.git_branch = function(file_path)
	local parent = git_parent(file_path):match("(.*)/[^/]*$")
	local git_cmd = "git --no-pager --no-optional-locks --literal-pathspecs -c gc.auto= -C "
		.. parent
		.. " branch --no-color --show-current"
	local git_branch_obj = vim.system({ "bash", "-c", git_cmd }, { text = true }):wait()
	local git_branch = git_branch_obj.stdout:gsub("([^%s]+)[\r\n]", "(%1)")
	-- :gsub("%*%s([^%s]+)[\r\n]", "(%1)")
	-- local git_status = vim.fn.system();
	if git_branch_obj.code ~= 0 then
		vim.notify(git_branch_obj.stderr)
		return ""
	end
	return "%#StatusLineGitBranchIcon# %#StatusLineHl#" .. git_branch
end

M.stl_git_cwd = function(file_path)
	local parent = git_parent(file_path)
	if parent then
		parent = vim.fn.fnamemodify(parent:match("(.*)/[^/]*$"), ":~")
		vim.b.stl_cwd = "%#StatusLineCwdIcon# %#StatusLineHl#" .. parent .. " "
	end
end

M.stl_lsp_info = function()
	local client = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() })[1]
	if client == {} or not client then
		vim.print("Error")
		return
	end

	local lsp_client_name = (client.name or "") .. " "

	return "%#StatusLineLspInfo# " .. lsp_client_name .. "%#StatusLineLspIcon#   "
end

return M
