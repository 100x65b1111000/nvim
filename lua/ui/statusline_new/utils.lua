local states = require("ui.statusline_new.states")

local M = {}

---Retrieves highlight information for a given highlight group.
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
---@param brightness_bg integer Brightness value.
---@param brightness_fg integer Brightness value.
---@param prefix? string The hl_group name's prefix
---@param suffix? string The hl_group name's suffix
---@param new_name? string The new highlight group name.
---@param extra_opts? {use_fg_for_bg: boolean, use_bg_for_fg: boolean} Extra opts for misc purposes
---@return string The name of the generated highlight group.
local function generate_highlight(
	source_fg,
	source_bg,
	opts,
	brightness_bg,
	brightness_fg,
	prefix,
	suffix,
	new_name,
	extra_opts
)
	if new_name and vim.tbl_contains(states.cache.highlights, new_name) then
		return new_name
	end
	opts = opts or {}
	local source_hl_fg = (extra_opts and extra_opts.use_bg_for_fg and get_highlight(source_fg).bg)
		or get_highlight(source_fg).fg
	local source_hl_bg = (extra_opts and extra_opts.use_fg_for_bg and get_highlight(source_bg).fg)
		or get_highlight(source_bg).bg
	local fallback_hl = get_highlight("Normal") -- User Normal as default hlgroup if get_highlight return nil
	local fg = "#" .. string.format("%06x", source_hl_fg or fallback_hl.fg)
	local bg = "#" .. string.format("%06x", source_hl_bg or fallback_hl.bg)
	-- vim.notify(bg .. "")

	bg = alter_hex_color(bg, brightness_bg)
	fg = alter_hex_color(fg, brightness_fg)
	suffix = suffix or ""
	prefix = prefix or ""
	local hl_opts = vim.tbl_extend("force", { fg = fg, bg = bg }, opts)
	local hl_group = new_name or prefix .. (source_fg or source_bg) .. suffix
	if not vim.tbl_contains(states.cache.highlights, hl_group) then
		vim.notify("Tabline: Generating highlight group: " .. hl_group) --debug purposes
		vim.api.nvim_set_hl(0, hl_group, hl_opts)
		table.insert(states.cache.highlights, hl_group)
	end
	return hl_group
end

---@return StatusLineModuleFnTable
function M.buf_status()
	local ro_string = vim.bo.readonly and "%r %m " or ""
	local mo_string = vim.bo.modified and "%m " or ""
	local hl = generate_highlight("MiniIconsOrange", "StatusLineNormalMode", {}, -65, 0, "", "", "StatusLineBufStatus", {  use_bg_for_fg = false, use_fg_for_bg = true})
	return { hl_group = hl, string = ro_string .. mo_string }
end

---@return StatusLineModuleFnTable
function M.statusline_mode()
	local mode = vim.api.nvim_get_mode().mode
	states.cache.mode_string = states.Modes[mode].name
	local hl = states.Modes[mode].hl
	return {
		hl_group = hl,
		string = states.cache.mode_string,
	}
end

local function buf_is_file()
	return vim.fn.expand("%:p") ~= "" and vim.bo[0].buftype == "" and vim.bo[0].filetype ~= ""
end

local function get_file_name()
	if buf_is_file() or vim.bo.buftype == "help" then
		return "%t"
	end
	return ""
end

---@return StatusLineModuleFnTable
function M.statusline_bufinfo()
	local buf_hl = generate_highlight(
		"StatusLine",
		"StatusLineNormalMode",
		{},
		-65,
		0,
		"",
		"",
		"StatusLineBufname",
		{ use_bg_for_fg = false, use_fg_for_bg = true }
	)
	return { string = " %t ", hl_group = buf_hl }
end

function M.statusline_filetype()
	local filetype = vim.bo.filetype
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

M.statusline_git_file_stat = function(file_path)
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

function M.initialize_stl(opts)
	local config = vim.tbl_deep_extend("force", states.default_config, opts or {})
	states.current_config = config
	states.modules_map["buf-status"] = M.buf_status
	states.modules_map["mode"] = M.statusline_mode
	states.modules_map["bufinfo"] = M.statusline_bufinfo
end

---@param modules StatusLineModules[] A table containing a list of predefined modules or custom modules that are functions with return type { hl_group = "highlight_group", string = "output from module"}
local generate_module_string = function(modules)
	local modules_string = ""
	for _, i in ipairs(modules) do
		local module_string = ""
		if type(i) == "function" then
			local status, module_info = pcall(i)
			if not status then
				return
			end
			module_string = string.format(
				"%%#%s#%s%%#%s#%s",
				module_info.icon_hl or "",
				module_info.icon or "",
				module_info.hl_group,
				module_info.string
			)
			modules_string = modules_string .. module_string
		else
			local module_fun = states.modules_map[i] or states.modules_map["fallback"]
			local module_info = module_fun()
			module_string = string.format(
				"%%#%s#%s%%#%s#%s",
				module_info.icon_hl or "",
				module_info.icon or "",
				module_info.hl_group,
				module_info.string
			)
			modules_string = modules_string .. module_string .. "%#StatusLine#"
		end
	end
	return modules_string
end

M.set_statusline = function()
	local config = states.current_config
	local left_modules_string = generate_module_string(config.modules.left)
	local middle_modules_string = generate_module_string(config.modules.middle)
	local right_modules_string = generate_module_string(config.modules.right)

	states.cache.statusline_string = left_modules_string
		.. "%=%#StatusLine#"
		.. middle_modules_string
		.. "%=%#StatusLine#"
		.. right_modules_string
	return states.cache.statusline_string
end

return M
