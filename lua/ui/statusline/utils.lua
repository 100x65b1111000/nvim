local states = require("ui.states").statusline_states
local utils = require("ui.utils")
local generate_highlight = utils.generate_highlight
local timer_fn = utils.timer_fn
local api = vim.api
local nvim_get_option_value = api.nvim_get_option_value
local nvim_get_mode = api.nvim_get_mode
local nvim_get_current_buf = api.nvim_get_current_buf
local nvim_buf_set_var = api.nvim_buf_set_var
local expand = vim.fn.expand
local fnamemodify = vim.fn.fnamemodify
local find = vim.fs.find

local M = {}

--- Display readonly and modified status of the current file
---@return StatusLineModuleFnTable
function M.buf_status()
	-- if not M.buf_is_file() then
	-- 	return { hl_group = "", string = "" }
	-- end
	local hl =
		generate_highlight("Constant", "StatusLine", {}, 25, 0, "", "", "StatusLineBufStatus")
	local mo_string = nvim_get_option_value("modified", { buf = 0 }) and " %m " or ""
	local ro_string = nvim_get_option_value("readonly", { buf = 0 }) and " %r " or ""
	local sephl = generate_highlight(
		hl,
		"StatusLine",
		{},
		15,
		0,
		"",
		"",
		"StatusLineBufStatusSep",
		{ use_bg_for_fg = true }
	)
	return { hl_group = hl, string = ro_string .. mo_string, right_sep_hl = sephl, show_right_sep = true }
end

--- Display the current mode
---@return StatusLineModuleFnTable
function M.statusline_mode()
	local mode = nvim_get_mode().mode or "n"
	local mode_string = states.Modes[mode or "n"].name or ""
	local mode_name = states.Modes[mode or "n"].mode_name or ""
	local hl_string = "StatusLine" .. mode_name
	local sephl =
		generate_highlight(hl_string, "StatusLine", {}, 25, 0, "", "", "StatusLineModeSep" .. mode_name)
	return {
		hl_group = hl_string,
		string = mode_string,
		right_sep_hl = sephl,
		show_right_sep = true,
	}
end

--- To check whether the opened buffer is a file
--- @return boolean
local function buf_is_file()
	return expand("%:p") ~= "" and nvim_get_option_value("buftype", { buf = 0 }) == ""
end

M.buf_is_file = buf_is_file

--- Display the filename
---@return StatusLineModuleFnTable
function M.statusline_bufinfo()
	local buf_hl =
		generate_highlight("@variable.parameter", "StatusLine", { italic = true }, 15, 0, "", "", "StatusLineBufname")
	local sephl = generate_highlight(
		buf_hl,
		"StatusLine",
		{},
		10,
		0,
		"",
		"",
		"StatusLineBufNameSep",
		{ use_bg_for_fg = true }
	)
	return { string = " %t ", hl_group = buf_hl, right_sep_hl = sephl, show_right_sep = true }
end

--- Display the filetype information about the buffers
---@return StatusLineModuleFnTable
M.statusline_filetype_info = function()
	local filetype_ = nvim_get_option_value("filetype", { buf = 0 })
	local filetype = (filetype_ == "" and "") or filetype_ .. " "
	local sephl = generate_highlight(
		"StatusLine",
		"StatusLine",
		{},
		0,
		10,
		"",
		"",
		"StatusLinefileTypeSep",
		{ use_bg_for_fg = true }
	)

	if not package.loaded["mini.icons"] then
		return {
			string = filetype,
			hl_group = generate_highlight("@variable.parameter", "StatusLine", {}, 10, 0, "", "", "StatusLineFiletype"),
			icon = "  ",
			icon_hl = "StatusLineFiletype",
			show_right_sep = false,
		}
	end
	if states.cache.filetype_icons[filetype_] then
		local icon_hl = states.cache.filetype_icons[filetype_].icon_hl
			or generate_highlight("@variable.parameter", "StatusLine", {}, 10, 0, "", "", "StatusLineFiletypeIcon")
		states.cache.filetype_icons[filetype_].icon_hl = icon_hl
		return {
			string = filetype,
			hl_group = generate_highlight(
				"@variable.parameter",
				"StatusLine",
				{},
				10,
				0,
				"",
				"",
				"StatusLineFiletype"
			),
			icon = states.cache.filetype_icons[filetype_].icon,
			icon_hl = icon_hl,
			right_sep_hl = sephl,
			show_right_sep = true,
		}
	end
	local icon, icon_hl = MiniIcons.get("filetype", filetype_)
	icon = string.format(" %s ", icon)
	icon_hl = generate_highlight(icon_hl, "StatusLine", {}, 10, 0, "StatusLine", "", nil)
	states.cache.filetype_icons[filetype_] = { icon = icon, icon_hl = icon_hl }
	return {
		string = filetype,
		hl_group = "StatusLineFiletype",
		icon = icon,
		icon_hl = icon_hl,
		show_right_sep = false,
	}
end

--- Returns the root dir if the current file is in a git repo
---@param path string
---@return string?
local find_parent = function(path)
	local git_parent = find({ ".git" }, { path = path, upward = true, stop = vim.env.HOME })[1]
	if git_parent then
		return fnamemodify(git_parent, ":h")
	end
	return nil
end

---@param ins any
---@return string
local insertions = function(ins)
	if ins and ins ~= "0" and ins ~= "" then
		return string.format("%s%s%s", "%#StatusLineGitInsertions# %#StatusLineHl#", ins, " ")
	end
	return ""
end

---@param del any
---@return string
local deletions = function(del)
	if del and del ~= "0" and del ~= "" then
		return string.format("%s%s%s", "%#StatusLineGitDeletions# %#StatusLineHl#", del, " ")
	end
	return ""
end

--- Fetch the git file status info about the current file
M.fetch_git_file_stat = function()
	states.git_stat_debounce_timer = timer_fn(states.git_stat_debounce_timer, 50, function()
		local file_path = expand("%:p")
		local parent = find_parent(file_path)
		if not parent then
			return
		end

		local git_stat_cmd =
			string.format("%s%s%s%s", states.git_cmd, parent, " status --short --porcelain ", file_path)
		vim.system({ "bash", "-c", git_stat_cmd }, { text = true }, function(out)
			vim.schedule(function()
				nvim_buf_set_var(
					0,
					"statusline_git_stat_obj",
					{ code = out.code, stdout = out.stdout, stderr = out.stderr }
				)
				vim.cmd([[redrawstatus]])
			end)
		end)
	end)
end

--- Fetch the git diff status info about the current file
M.fetch_git_file_diff = function()
	states.git_diff_debounce_timer = timer_fn(states.git_diff_debounce_timer, 50, function()
		local file_path = expand("%:p")
		local parent = find_parent(file_path)
		if not parent then
			return
		end

		local git_diff_cmd = string.format("%s%s%s%s", states.git_cmd, parent, " diff --numstat ", file_path)
		vim.system({ "bash", "-c", git_diff_cmd }, { text = true }, function(out)
			vim.schedule(function()
				nvim_buf_set_var(
					0,
					"statusline_git_diff_obj",
					{ code = out.code, stdout = out.stdout, stderr = out.stderr }
				)
				vim.cmd([[redrawstatus]])
			end)
		end)
	end)
end

--- Display the git file status
---@return StatusLineModuleFnTable
M.statusline_git_file_status = function()
	if not buf_is_file() then
		return { hl_group = "", string = "" }
	end
	local git_diff = ""

	local diff_output_obj = vim.b.statusline_git_diff_obj
	if not diff_output_obj or diff_output_obj.code ~= 0 then
		return { hl_group = "", string = "" }
	end

	local diff_output = diff_output_obj.stdout:gsub("([^%s]+)[\r\n]", "%1") or ""
	if diff_output ~= "" and diff_output then
		local diff_split = vim.split(diff_output, "\t")
		git_diff = insertions(diff_split[1]) .. deletions(diff_split[2])
	end

	local stat_output_obj = vim.b.statusline_git_stat_obj
	if not stat_output_obj or stat_output_obj.code ~= 0 then
		return { hl_group = "", string = "" }
	end

	local git_status = ""

	local stat_output = stat_output_obj.stdout or ""

	local first, second = stat_output:sub(1, 1), stat_output:sub(2, 2)
	local changed = second == "M"
	local staged = first == "M"
	local staged_and_changed = staged and changed
	local untracked = first == "?" and second == "?"
	local up_to_date = stat_output == ""

	if staged_and_changed then
		git_status = "%#StatusLineModified#[%#StatusLineGitStaged#%*%#StatusLineModified#]%* "
	elseif staged then
		git_status = "%#StatusLineGitStaged# "
	elseif up_to_date then
		git_status = "%#StatusLineGitUptodate# %*"
	elseif untracked then
		git_status = "%#StatusLineGitUntracked# %*"
	end

	return { hl_group = "", string = git_status .. git_diff }
end

--- Fetch the gir branch of the current file (if inside a git repo)
M.fetch_git_branch = function()
	states.statusline_git_branch_timer = timer_fn(states.statusline_git_branch_timer, 50, function()
		local file_path = expand("%:p")
		local parent = find_parent(file_path)
		if not parent then
			-- nvim_buf_set_var(0, "statusline_git_branch_obj", nil)
			return
		end

		local git_diff_cmd = string.format("%s%s%s", states.git_cmd, parent, " branch --show-current ")
		vim.system({ "bash", "-c", git_diff_cmd }, { text = true }, function(out)
			vim.schedule(function()
				nvim_buf_set_var(
					0,
					"statusline_git_branch_obj",
					{ code = out.code, stdout = out.stdout, stderr = out.stderr }
				)
				vim.cmd("redrawstatus")
			end)
		end)
	end)
end

--- Display the git diff status (insertions + deletions)
---@return StatusLineModuleFnTable
M.statusline_root_dir = function()
	local parent = fnamemodify(find_parent(expand("%:p")) or "", ":~")
	if parent then
		return { hl_group = "StatusLine", string = parent, icon_hl = "StatusLineCwdIcon", icon = "  " }
	end
	return { hl_group = "StatusLine", string = vim.uv.cwd(), icon_hl = "StatusLineCwdIcon", icon = "  " }
end

--- Display the git branch for the current buffer ( if inside a git directory )
---@return StatusLineModuleFnTable
M.statusline_git_branch = function()
	local git_branch_obj = vim.b.statusline_git_branch_obj
	if not git_branch_obj or (git_branch_obj.code ~= 0) then
		return {}
	end

	local git_branch = git_branch_obj.stdout:gsub("([^%s]+)[\r\n]", "(%1)")
	return {
		hl_group = "StatusLine",
		string = git_branch .. " ",
		icon_hl = "StatusLineGitBranchIcon",
		icon = "  ",
	}
end

--- Display an indicator whether treesitter is enabled for the current file or not
---@return StatusLineModuleFnTable
M.statusline_ts_info = function()
	local ts_info = vim.treesitter.highlighter.active[nvim_get_current_buf()]
	local hl_group = generate_highlight(
		"Character",
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

--- Fetch lsp information about the current file
M.fetch_lsp_info = function()
	states.lsp_debounce_timer = timer_fn(states.lsp_debounce_timer, 200, function()
		local clients = vim.lsp.get_clients({ bufnr = nvim_get_current_buf() }) or {}
		local client_names = {}
		for _, i in ipairs(clients) do
			table.insert(client_names, i.name)
		end
		vim.schedule(function()
			nvim_buf_set_var(0, "statusline_lsp_clients", client_names)
			vim.cmd("redrawstatus")
		end)
	end)
end

--- Display the cursor position
---@return StatusLineModuleFnTable
M.statusline_cursor_pos = function()
	return {
		string = " %l:%v ",
		hl_group = "StatusLineCursorPos",
		icon = "  ",
		icon_hl = "StatusLineCursorIcon",
		reverse = true,
	}
end

--- Display how much percentage of file is scrolled in the visible area
---@return StatusLineModuleFnTable
M.statusline_file_percent = function()
	return {
		string = " %P ",
		hl_group = "StatusLineFilePerc",
		icon = "   ",
		icon_hl = "StatusLineFilePercIcon",
		reverse = true,
	}
end

--- Display the name of the lsp server(s) attached to the current buffer
---@return StatusLineModuleFnTable
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

--- Returns the formatted string containing the diagnostic icons and their count
---@param severity any
---@return string
local format_diagnostics = function(severity)
	local count = states.cache.severity_map[severity].count
	local hl = states.cache.severity_map[severity].hl
	local icon = states.cache.severity_map[severity].icon
	if count > 0 then
		return string.format("%s%s%s%%*", hl, icon, count)
	end

	return ""
end

--- Fetch the diagnostic information for the current file
M.fetch_diagnostics = function()
	states.diagnostic_debounce_timer = timer_fn(states.diagnostic_debounce_timer, 100, function()
		local bufnr = nvim_get_current_buf()
		states.cache.severity_map = {
			["ERROR"] = { hl = "%#DiagnosticError#", icon = "  ", count = vim.diagnostic.count(bufnr)[1] or 0 },
			["WARN"] = { hl = "%#DiagnosticWarn#", icon = "  ", count = vim.diagnostic.count(bufnr)[2] or 0 },
			["INFO"] = { hl = "%#DiagnosticInfo#", icon = "  ", count = vim.diagnostic.count(bufnr)[3] or 0 },
			["HINT"] = { hl = "%#DiagnosticHint#", icon = "  ", count = vim.diagnostic.count(bufnr)[4] or 0 },
		}

		local diagnostic_str = string.format(
			"%s%s%s%s",
			format_diagnostics("ERROR"),
			format_diagnostics("WARN"),
			format_diagnostics("INFO"),
			format_diagnostics("HINT")
		)

		vim.schedule(function()
			nvim_buf_set_var(0, "statusline_diagnostic_info", string.format(" %s ", diagnostic_str))
			vim.cmd([[redrawstatus]])
		end)
	end)
end

--- Display the diagnostic information
M.statusline_diagnostics = function()
	return { string = vim.b.statusline_diagnostic_info }
end

--- Initialize all the things needed to set the statusline
---@param opts StatusLineConfig
function M.initialize_stl(opts)
	states.current_config = vim.tbl_deep_extend("force", states.default_config, opts or {})
	vim.print(states.current_config)

	states.modules_map["mode"] = M.statusline_mode
	states.modules_map["buf-status"] = M.buf_status
	states.modules_map["bufinfo"] = M.statusline_bufinfo
	states.modules_map["git-status"] = M.statusline_git_file_status
	states.modules_map["git-branch"] = M.statusline_git_branch
	states.modules_map["root-dir"] = M.statusline_root_dir
	states.modules_map["filetype"] = M.statusline_filetype_info
	-- states.modules_map["ts-info"] = M.statusline_ts_info
	states.modules_map["lsp-info"] = M.statusline_lsp_info
	states.modules_map["cursor-pos"] = M.statusline_cursor_pos
	states.modules_map["file-percent"] = M.statusline_file_percent
	states.modules_map["diagnostic"] = M.statusline_diagnostics
end

--- Takes the hl_group string and returns the formmatted string that can be evaluated by the statusline
--- @param hl_group any
--- @return string
local function format_hl_string(hl_group)
	if not hl_group or hl_group == "" then
		return ""
	end
	return string.format("%%#%s#", hl_group)
end

--- Converts the module information to string
---@param module_type StatusLineModuleTypeConfig A table containing a list of predefined modules or custom modules that are functions with return type { hl_group = "highlight_group", string = "output from module"}
local generate_module_string = function(module_type)
	local modules = module_type.modules
	local meta_string = ""
	for _, module in ipairs(modules) do
		local module_string = ""
		if type(module) == "function" then
			local status, module_info = pcall(module)
			if not status then
				error(
					"an error occurred, sorry its not your fault, please report to upstream [err]: " .. module_info,
					4
				)
			end
			module_string = module_info.reverse
					and string.format(
						"%s%s%s%s%s%s%s%s%%*",
						format_hl_string(module_info.left_sep_hl),
						module_info.show_left_sep and module_type.separator.left or "",
						format_hl_string(module_info.hl_group),
						module_info.string or "",
						format_hl_string(module_info.icon_hl),
						module_info.icon,
						format_hl_string(module_info.right_sep_hl),
						module_info.show_right_sep and module_type.separator.right or ""
					)
				or string.format(
					"%s%s%s%s%s%s%s%s%%*",
					format_hl_string(module_info.left_sep_hl),
					module_info.show_left_sep and module_type.separator.left or "",
					format_hl_string(module_info.icon_hl),
					module_info.icon or "",
					format_hl_string(module_info.hl_group),
					module_info.string or "",
					format_hl_string(module_info.right_sep_hl),
					module_info.show_right_sep and module_type.separator.right or ""
				)
		else
			module = states.modules_map[module] or module
			local status, module_info = pcall(module)
			if not status then
				error(
					"an error occurred, sorry its not your fault, please report to upstream [err]: " .. module_info,
					4
				)
			end
			module_string = module_info.reverse
					and string.format(
						"%s%s%s%s%s%s%s%s%%*",
						format_hl_string(module_info.left_sep_hl),
						module_info.show_left_sep and module_type.separator.left or "",
						format_hl_string(module_info.hl_group),
						module_info.string or "",
						format_hl_string(module_info.icon_hl),
						module_info.icon,
						format_hl_string(module_info.right_sep_hl),
						module_info.show_right_sep and module_type.separator.right or ""
					)
				or string.format(
					"%s%s%s%s%s%s%s%s%%*",
					format_hl_string(module_info.left_sep_hl),
					module_info.show_left_sep and module_type.separator.left or "",
					format_hl_string(module_info.icon_hl),
					module_info.icon or "",
					format_hl_string(module_info.hl_group),
					module_info.string or "",
					format_hl_string(module_info.right_sep_hl),
					module_info.show_right_sep and module_type.separator.right or ""
				)
		end
		meta_string = string.format("%s%s%s", meta_string, module_string, "%#StatusLine#")
	end
	return meta_string
end

--- Meta function to set the statusline
M.set_statusline = function()
	local config = states.current_config
	local left_modules_string = generate_module_string(config.left)
	local middle_modules_string = generate_module_string(config.middle)
	local right_modules_string = generate_module_string(config.right)

	states.cache.statusline_string = string.format(
		"%s%s%s%s%s",
		left_modules_string,
		"%=%#StatusLine#",
		middle_modules_string,
		"%=%#StatusLine#",
		right_modules_string
	)
	return states.cache.statusline_string
end

return M
