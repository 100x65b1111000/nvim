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

	bg = alter_hex_color(bg, brightness_bg)
	fg = alter_hex_color(fg, brightness_fg)
	suffix = suffix or ""
	prefix = prefix or ""
	local hl_opts = vim.tbl_extend("force", { fg = fg, bg = bg }, opts)
	local hl_group = new_name or prefix .. (source_fg or source_bg) .. suffix
	if not vim.tbl_contains(states.cache.highlights, hl_group) then
		vim.api.nvim_set_hl(0, hl_group, hl_opts)
		table.insert(states.cache.highlights, hl_group)
	end
	return hl_group
end

---@return StatusLineModuleFnTable
function M.buf_status()
	local mo_string = vim.bo.modified and "%m " or ""
	local ro_string = vim.bo.readonly and " %r " or " "
	local hl = generate_highlight(
		"MiniIconsOrange",
		"StatusLineNormalMode",
		{},
		-50,
		0,
		"",
		"",
		"StatusLineBufStatus",
		{ use_bg_for_fg = false, use_fg_for_bg = true }
	)
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
	return vim.fn.expand("%:p") ~= "" and vim.bo[0].buftype == ""
end

M.buf_is_file = buf_is_file

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
		-75,
		0,
		"",
		"",
		"StatusLineBufname",
		{ use_bg_for_fg = false, use_fg_for_bg = true }
	)
	return { string = " %t ", hl_group = buf_hl }
end

local find_parent = function(path)
	local git_parent = vim.fs.find({ ".git" }, { path = path, upward = true, stop = vim.env.HOME })[1]
	if git_parent then
		return vim.fn.fnamemodify(git_parent, ":h")
	end
	return nil
end

local insertions = function(ins)
	if ins and ins ~= "0" and ins ~= "" then
		return "%#StatusLineGitInsertions# %#StatusLineHl#" .. ins .. " "
	end
	return ""
end

local deletions = function(del)
	if del and del ~= "0" and del ~= "" then
		return "%#StatusLineGitDeletions# %#StatusLineHl#" .. del .. " "
	end
	return ""
end

---@param timer uv.uv_timer_t|nil
---@param timeout integer
---@param callback function
local timer_fn = function(timer, timeout, callback)
	if timer then
		timer:stop()
		timer:close()
	end

	timer = vim.uv.new_timer()
	assert(timer, "Error creating timer")
	timer:start(timeout, 0, function()
		vim.schedule(callback)
	end)
	return timer
end

M.fetch_git_file_stat = function()
	states.stat_debounce_timer = timer_fn(states.stat_debounce_timer, 50, function()
		local file_path = vim.fn.expand("%:p")
		local parent = find_parent(file_path)
		if not parent then
			return
		end

		local git_stat_cmd = states.git_cmd .. parent .. " status --short --porcelain " .. file_path
		vim.system({ "bash", "-c", git_stat_cmd }, { text = true }, function(out)
			vim.schedule(function()
				vim.b.statusline_git_stat_obj = { code = out.code, stdout = out.stdout, stderr = out.stderr }
				vim.cmd([[redrawstatus]])
			end)
		end)
	end)
end

M.fetch_git_file_diff = function()
	states.diff_debounce_timer = timer_fn(states.diff_debounce_timer, 50, function()
		local file_path = vim.fn.expand("%:p")
		local parent = find_parent(file_path)
		if not parent then
			return
		end

		local git_diff_cmd = states.git_cmd .. parent .. " diff --numstat " .. file_path
		vim.system({ "bash", "-c", git_diff_cmd }, { text = true }, function(out)
			vim.schedule(function()
				vim.b.statusline_git_diff_obj = { code = out.code, stdout = out.stdout, stderr = out.stderr }
				vim.cmd([[redrawstatus]])
			end)
		end)
	end)
end

M.statusline_git_file_status = function()
	if not buf_is_file() then
		return { hl_group = "", string = "" }
	end
	local git_status = ""

	local diff_output_obj = vim.b.statusline_git_diff_obj
	if not diff_output_obj or diff_output_obj.code ~= 0 then
		return { hl_group = "", string = "" }
	end

	local diff_output = diff_output_obj.stdout:gsub("([^%s]+)[\r\n]", "%1") or ""
	if diff_output ~= "" and diff_output then
		local diff_split = vim.split(diff_output, "\t")
		git_status = insertions(diff_split[1]) .. deletions(diff_split[2])
	end

	local stat_output_obj = vim.b.statusline_git_stat_obj
	if not stat_output_obj or stat_output_obj.code ~= 0 then
		return { hl_group = "", string = "" }
	end

	local stat_output = stat_output_obj.stdout or ""

	local file_status = stat_output:match("[^%s]+")

	if not file_status then
		git_status = "%#StatusLineGitUptodate# " .. git_status
	elseif file_status == "??" then
		git_status = "%#StatusLineGitUnstaged#" .. git_status
	end

	return { hl_group = "", string = git_status }
end

M.fetch_git_branch = function()
	states.statusline_git_branch = timer_fn(states.statusline_git_branch, 50, function()
		local file_path = vim.fn.expand("%:p")
		local parent = find_parent(file_path)
		if not parent then
			vim.b.statusline_git_branch_obj = nil
			return
		end

		local git_diff_cmd = states.git_cmd .. parent .. " branch --show-current "
		vim.system({ "bash", "-c", git_diff_cmd }, { text = true }, function(out)
			vim.schedule(function()
				vim.b.statusline_git_branch_obj = out
				vim.cmd("redrawstatus")
			end)
		end)
	end)
end

M.statusline_root_dir = function()
	local parent = vim.fn.fnamemodify(find_parent(vim.fn.expand("%:p")) or "", ":~")
	if parent then
		return { hl_group = "StatusLine", string = parent .. " ", icon_hl = "StatusLineCwdIcon", icon = "  " }
	end
	return { hl_group = "StatusLine", string = vim.uv.cwd() .. " ", icon_hl = "StatusLineCwdIcon", icon = "  " }
end

M.statusline_filetype_info = function()
	local filetype_ = vim.bo.filetype
	local filetype = (filetype_ == "" and "") or filetype_ .. " "
	-- if states.cache.filetype_icons[vim.bo.buftype] and not states.cache.filetype_icons[filetype_] then
	-- 	filetype_ = vim.bo.buftype
	-- end

	if not package.loaded["mini.icons"] then
		return {
			string = filetype,
			hl_group = generate_highlight(
				"StatusLine",
				"StatusLineNormalMode",
				{},
				-65,
				0,
				"",
				"",
				"StatusLineFiletype",
				{ use_bg_for_fg = false, use_fg_for_bg = true }
			),
			icon = "  ",
			icon_hl = "StatusLineFiletypeIcon",
		}
	end
	if states.cache.filetype_icons[filetype_] then
		local icon_hl = states.cache.filetype_icons[filetype_].icon_hl
			or generate_highlight(
				"statuslineinsertmode",
				"statuslinenormalmode",
				{},
				-65,
				0,
				"",
				"",
				"StatusLineFiletypeIcon",
				{ use_bg_for_fg = false, use_fg_for_bg = true }
			)
		states.cache.filetype_icons[filetype_].icon_hl = icon_hl
		return {
			string = filetype,
			hl_group = generate_highlight(
				"StatusLine",
				"StatusLineNormalMode",
				{},
				-65,
				0,
				"",
				"",
				"StatusLineFiletype",
				{ use_bg_for_fg = false, use_fg_for_bg = true }
			),
			icon = states.cache.filetype_icons[filetype_].icon,
			icon_hl = icon_hl,
		}
	end
	local icon, icon_hl = MiniIcons.get("filetype", filetype_)
	icon = " " .. icon .. " "
	icon_hl = generate_highlight(
		icon_hl,
		"StatusLineNormalMode",
		{},
		-65,
		0,
		"StatusLine",
		"",
		nil,
		{ use_fg_for_bg = true }
	)
	states.cache.filetype_icons[filetype_] = { icon = icon, icon_hl = icon_hl }
	return {
		string = filetype,
		hl_group = "StatusLineFiletype",
		icon = icon,
		icon_hl = icon_hl,
	}
end

---@return StatusLineModuleFnTable
M.statusline_git_branch = function()
	local git_branch_obj = vim.b.statusline_git_branch_obj
	if not git_branch_obj or git_branch_obj.code ~= 0 then
		return {}
	end

	local git_branch = git_branch_obj.stdout:gsub("([^%s]+)[\r\n]", "(%1) ")
	return {
		hl_group = "StatusLine",
		string = git_branch,
		icon_hl = "StatusLineGitBranchIcon",
		icon = "  ",
	}
end

M.statusline_ts_info = function()
	local ts_info = vim.treesitter.highlighter.active[vim.api.nvim_get_current_buf()]
	local hl_group = generate_highlight(
		"MiniIconsGreen",
		"StatusLineNormalMode",
		{ reverse = false },
		-75,
		0,
		"",
		"",
		"StatusLineTSInfoActive",
		{ use_fg_for_bg = true }
	)
	if not ts_info then
		hl_group = generate_highlight(
			"Comment",
			"StatusLineNormalMode",
			{ reverse = false },
			-75,
			0,
			"",
			"",
			"StatusLineTSInfoInactive",
			{ use_fg_for_bg = true }
		)
	end

	return {
		hl_group = hl_group,
		string = "  ",
	}
end

M.fetch_lsp_info = function()
	states.lsp_debounce_timer = timer_fn(states.lsp_debounce_timer, 200, function()
		local clients = vim.lsp.get_clients({ bufnr = vim.api.nvim_get_current_buf() }) or {}
		local client_names = {}
		for _, i in ipairs(clients) do
			table.insert(client_names, i.name)
		end
		vim.schedule(function()
			vim.b.statusline_lsp_clients = client_names
			vim.cmd("redrawstatus")
		end)
	end)
end

M.statusline_cursor_pos = function()
	return {
		string = " %l:%v ",
		hl_group = "StatusLineCursorPos",
		icon = '  ',
		icon_hl = "StatusLineCursorIcon",
		reverse = true,
	}
end


M.statusline_file_percent = function()
	return {
		string = " %p ",
		hl_group = "StatusLineFilePerc",
		icon = '  ',
		icon_hl = "StatusLineFilePercIcon",
		reverse = true,
	}
end

M.statusline_lsp_info = function()
	local clients = table.concat(vim.b.statusline_lsp_clients or {}, ", ")
	local icon = (clients == "" and "") or "   "
	return {
		string = clients .. " ",
		hl_group = "StatusLineLspInfo",
		icon = icon,
		icon_hl = "StatusLineLspIcon",
		reverse = true,
	}
end

function M.initialize_stl(opts)
	local config = vim.tbl_deep_extend("force", states.default_config, opts or {})
	states.current_config = config
	states.modules_map["buf-status"] = M.buf_status
	states.modules_map["mode"] = M.statusline_mode
	states.modules_map["bufinfo"] = M.statusline_bufinfo
	states.modules_map["git-status"] = M.statusline_git_file_status
	states.modules_map["git-branch"] = M.statusline_git_branch
	states.modules_map["root-dir"] = M.statusline_root_dir
	states.modules_map["filetype"] = M.statusline_filetype_info
	states.modules_map["ts-info"] = M.statusline_ts_info
	states.modules_map["lsp-info"] = M.statusline_lsp_info
	states.modules_map["cursor-pos"] = M.statusline_cursor_pos
	states.modules_map["file-percent"] = M.statusline_file_percent
end

local function format_hl_string(hl_group)
	if not hl_group or hl_group == "" then
		return ""
	end
	return "%#" .. hl_group .. "#"
end

---@param modules StatusLineModules[] A table containing a list of predefined modules or custom modules that are functions with return type { hl_group = "highlight_group", string = "output from module"}
local generate_module_string = function(modules)
	local modules_string = ""
	for _, i in ipairs(modules) do
		local module_string = ""
		if type(i) == "function" then
			local status, module_info = pcall(i)
			if not status then
				error("module fn not callable")
			end
			module_string = string.format(
				"%s%s%s%s",
				format_hl_string(module_info.icon_hl or ""),
				module_info.icon or "",
				format_hl_string(module_info.hl_group or ""),
				module_info.string or ""
			)
			modules_string = modules_string .. module_string
		else
			local module_fun = states.modules_map[i] or states.modules_map["fallback"]
			local module_info = module_fun()
			module_string = (
				module_info.reverse
				and string.format(
					"%s%s%s%s",
					format_hl_string(module_info.hl_group or ""),
					module_info.string or "",
					format_hl_string(module_info.icon_hl or ""),
					module_info.icon or ""
				)
			)
				or string.format(
					"%s%s%s%s",
					format_hl_string(module_info.icon_hl or ""),
					module_info.icon or "",
					format_hl_string(module_info.hl_group or ""),
					module_info.string or ""
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
