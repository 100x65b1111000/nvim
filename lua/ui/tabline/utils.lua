local states = require("ui.states").tabline_states
local utils = require("ui.utils")

local api = vim.api
local fn = vim.fn
local nvim_buf_get_name = api.nvim_buf_get_name
local nvim_get_option_value = api.nvim_get_option_value
local nvim_list_bufs = api.nvim_list_bufs
local nvim_strwidth = api.nvim_strwidth
local nvim_eval_statusline = api.nvim_eval_statusline
local nvim_get_current_buf = api.nvim_get_current_buf
local nvim_buf_delete = api.nvim_buf_delete
local nvim_get_mode = api.nvim_get_mode
local timer_fn = utils.timer_fn
local generate_highlight = utils.generate_highlight
local find_index = utils.find_index
local fnamemodify = fn.fnamemodify
local schedule = vim.schedule
local tbl_contains = vim.tbl_contains
local nvim_get_current_tabpage = api.nvim_get_current_tabpage
local nvim_list_tabpages = api.nvim_list_tabpages
local isdirectory = fn.isdirectory

local M = {}

---Checks if a buffer is valid for display in the tabline.
---@param bufnr integer The buffer number to check.
---@return boolean True if the buffer is valid, false otherwise.
local function buf_is_valid(bufnr)
	local listed = nvim_get_option_value("buflisted", { buf = bufnr }) or false
	-- return nvim_buf_is_loaded(bufnr)
	-- 	and nvim_buf_is_valid(bufnr)
	-- 	and (nvim_get_option_value("buftype", { buf = bufnr }) == "")
	return listed and isdirectory(nvim_buf_get_name(bufnr)) == 0 -- and nvim_buf_get_name(bufnr) ~= ""
end

---Filters a list of buffer numbers, returning only the valid ones.
---@param buffers integer[] A table of buffer numbers.
---@return integer[] A table of valid buffer numbers.
local function get_tabline_buffers_list(buffers)
	local buf_list = {}
	for _, i in ipairs(buffers) do
		if buf_is_valid(i) then
			table.insert(buf_list, i)
		end
	end
	return buf_list
end

--@param state integer
local function generate_tabline_highlight(source, state, opts, new_name)
	if states.cache.highlights[new_name] then
		return new_name
	end
	local suffix, prefix, brightness_bg, brightness_fg = nil, nil, 0, 0
	if state == states.BufferStates.ACTIVE then
		suffix, prefix, brightness_bg, brightness_fg = "Active", "TabLine", 75, 0
	elseif state == states.BufferStates.INACTIVE then
		suffix, prefix, brightness_bg, brightness_fg = "Inactive", "TabLine", 25, -55
	elseif state == states.BufferStates.NONE then
		suffix, prefix, brightness_bg, brightness_fg = "None", "TabLine", 0, -50
	elseif state == states.BufferStates.MISC then
		suffix, prefix, brightness_bg, brightness_fg = "None", "TabLine", 25, 0
	end
	return generate_highlight(source, "TabLineFill", opts, brightness_bg, brightness_fg, prefix, suffix, new_name)
end

---Gets the buffer state.
---@param bufnr integer The buffer number.
---@return integer
local function get_buffer_state(bufnr, bufs)
	if bufnr == nvim_get_current_buf() then
		return states.BufferStates.ACTIVE
	elseif tbl_contains(bufs, bufnr) then
		return states.BufferStates.INACTIVE
	end
	return states.BufferStates.NONE
end

---Processes the buffer name for display.
---@param bufnr integer The buffer number.
---@return string The processed buffer name.
local function process_buffer_name(bufnr)
	local buf = nvim_buf_get_name(bufnr)
	local bufname = fnamemodify(buf, ":t")
	local init_files = states.init_files or { "init.lua" }
	if vim.list_contains(init_files, bufname) then
		bufname = string.format("%s%s%s", fnamemodify(nvim_buf_get_name(bufnr), ":h:t"), "/", bufname)
	end
	return bufname
end

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

---Gets left and right padding.
---@param buf_string string The buffer string.
---@return string, string The left and right padding strings.
local function get_lr_padding(buf_string)
	local width = states.tabline_buf_str_max_width
	local padding = width - #buf_string
	local left_padding, right_padding = 2, 2

	if padding <= 3 then
		right_padding = math.floor(padding / 2)
		left_padding = padding - right_padding
	end

	return string.rep(" ", left_padding), string.rep(" ", right_padding)
end

local get_file_icon = function(bufnr)
	local filetype = nvim_get_option_value("filetype", { buf = bufnr })
	local icon, hl = "", ""
	if not package.loaded["mini.icons"] then
		icon, hl = "", "TabLineFill"
		return icon, hl
	end
	if states.cache.fileicons[filetype] == nil then
		icon, hl = MiniIcons.get("filetype", filetype)
		states.cache.fileicons[filetype] = { icon = icon, hl = hl }
	end
	return states.cache.fileicons[filetype].icon, states.cache.fileicons[filetype].hl
end

---Gets the close button string.
---@param bufnr integer The buffer number.
local function get_close_button(bufnr)
	local close_button_str = "%%%d@v:lua.tabline_close_button_callback@%%#%s#%s%%X"
	local close_btn_inactive_hl =
		generate_tabline_highlight("PreProc", states.BufferStates.INACTIVE, {}, "TabLineCloseButtonInactive")

	if nvim_get_mode().mode == "i" and bufnr == nvim_get_current_buf() then
		local close_btn_insert_mode_hl =
			generate_tabline_highlight("String", states.BufferStates.ACTIVE, {}, "TabLineDotActive")
		return string.format(close_button_str, bufnr, close_btn_insert_mode_hl, states.icons.active_dot)
	end
	if nvim_get_option_value("modified", { buf = bufnr }) and bufnr == nvim_get_current_buf() then
		local close_btn_modified_hl =
			generate_tabline_highlight("Constant", states.BufferStates.ACTIVE, {}, "TabLineModifiedActive")
		return string.format(close_button_str, bufnr, close_btn_modified_hl, states.icons.active_dot)
	end
	if nvim_get_option_value("modified", { buf = bufnr }) then
		local close_btn_modified_hl =
			generate_tabline_highlight("Constant", states.BufferStates.MISC, {}, "TabLineModifiedInactive")
		return string.format(close_button_str, bufnr, close_btn_modified_hl, states.icons.active_dot)
	end
	if bufnr == nvim_get_current_buf() then
		local close_btn_active_hl =
			generate_tabline_highlight("PreProc", states.BufferStates.ACTIVE, {}, "TabLineCloseButtonActive")
		return string.format(close_button_str, bufnr, close_btn_active_hl, states.icons.close)
	end

	return string.format(close_button_str, bufnr, close_btn_inactive_hl, states.icons.close)
end

_G.tabline_click_buffer_callback = function(bufnr)
	if not buf_is_valid(bufnr) and nvim_get_option_value("buflisted", { buf = bufnr }) then
		return
	end

	vim.cmd(string.format("buffer %s", bufnr))
end

---Gets buffer information.
---@param bufnr integer The buffer number.
---@return { buf_name: string, buf_name_length: integer, icon_hl: string,icon:  string,length: integer,state: integer, left_padding: string, right_padding: string, close_btn: string }|nil
local function get_buffer_info(bufnr, bufs)
	local buf_name = process_buffer_name(bufnr)
	local state = get_buffer_state(bufnr, bufs)
	local icon, icon_hl = get_file_icon(bufnr)
	icon = icon .. " "
	icon_hl = generate_tabline_highlight(icon_hl, state, {}, nil)
	local left_padding, right_padding = get_lr_padding(buf_name)
	buf_name = truncate_string(buf_name, #buf_name, states.tabline_buf_str_max_width)
	local length = nvim_strwidth(buf_name)
		+ nvim_strwidth(icon)
		+ nvim_strwidth(left_padding)
		+ nvim_strwidth(right_padding)
		+ nvim_strwidth(states.icons.close)
		+ nvim_strwidth(states.icons.separator)
	local close_btn = get_close_button(bufnr)
	return {
		buf_name = buf_name,
		padding_length = #left_padding + #right_padding,
		icon_hl = icon_hl,
		icon = icon,
		length = length,
		state = state,
		left_padding = left_padding,
		right_padding = right_padding,
		close_btn = close_btn,
	}
end

M.buf_is_valid = buf_is_valid
M.get_buffer_info = get_buffer_info

---Gets valid buffers.
---@return {buf_name: string, icon: string, icon_hl: string, length: integer, state: integer, left_padding: string, right_padding: string}
local function get_buffers_with_specs(bufs)
	local valid_bufs = {}
	for _, i in ipairs(bufs) do
		local info = get_buffer_info(i, bufs)
		valid_bufs[i] = info
	end
	return valid_bufs
end

local calculate_buf_space = function(bufs)
	local length = 0
	for _, i in ipairs(bufs) do
		local buf_len = get_buffer_info(i, bufs).length
		length = length + buf_len
	end
	return length
end

M.update_overflow_info = function(bufs)
	local left_dist = states.start_idx - 1
	local right_dist = #bufs - states.end_idx
	states.left_overflow_str = ""
	states.right_overflow_str = ""
	states.left_overflow_idicator_length = 0
	states.right_overflow_idicator_length = 0
	if left_dist > 0 then
		states.left_overflow_str = string.format(
			"%s%s%s %d %%* ",
			"%#TabLineOverflowIndicator#",
			states.icons.left_overflow_indicator,
			"%#TabLineOverflowCount#",
			left_dist
		)
		states.left_overflow_idicator_length =
			nvim_eval_statusline(states.left_overflow_str, { use_tabline = true }).width
	end
	if right_dist > 0 then
		states.right_overflow_str = string.format(
			" %s %d %s%s%%*",
			"%#TabLineOverflowCount#",
			right_dist,
			"%#TabLineOverflowIndicator#",
			states.icons.right_overflow_indicator
		)
		states.right_overflow_idicator_length =
			nvim_eval_statusline(states.right_overflow_str, { use_tabline = true }).width
	end
end

M.calculate_buf_space = calculate_buf_space

local fetch_visible_buffers = function(bufnr, bufs, buf_specs)
	local columns = nvim_get_option_value("columns", {})
	local available_space = columns
		- (states.left_overflow_idicator_length + states.right_overflow_idicator_length + states.tabpages_str_length)
	local buf_space = calculate_buf_space(bufs)
	states.visible_buffers = bufs
	states.start_idx = 1
	states.end_idx = #states.visible_buffers

	if buf_space <= available_space then
		return
	end

	local current_buf_index = find_index(bufs, bufnr)
	local visible_buffers = { bufnr }
	local occupied_space = buf_specs[bufnr].length
	local left = current_buf_index - 1
	local right = current_buf_index + 1
	local left_space = 0
	local right_space = 0

	while occupied_space <= available_space do
		local left_buf = bufs[left]
		local right_buf = bufs[right]
		local left_len = left_buf and buf_specs[left_buf].length or nil
		local right_len = right_buf and buf_specs[right_buf].length or nil

		local can_add_left = left_len and (occupied_space + left_len <= available_space)
		local can_add_right = right_len and (occupied_space + right_len <= available_space)

		if can_add_left and (not can_add_right or left_space <= right_space) then
			table.insert(visible_buffers, 1, left_buf)
			left_space = left_space + left_len
			occupied_space = occupied_space + left_len
			left = left - 1
		elseif can_add_right then
			table.insert(visible_buffers, right_buf)
			right_space = right_space + right_len
			occupied_space = occupied_space + right_len
			right = right + 1
		else
			break
		end
	end

	states.occupied_space = occupied_space
	states.start_idx = find_index(bufs, visible_buffers[1])
	states.end_idx = find_index(bufs, visible_buffers[#visible_buffers])
	states.visible_buffers = visible_buffers
end

M.fetch_visible_buffers = fetch_visible_buffers

---Gets buffer highlight.
---@param bufnr integer The buffer number.
---@return string The highlight group name.
local function get_buffer_highlight(bufnr) -- changed from get_buf_hl
	if nvim_get_current_buf() == bufnr then
		return generate_tabline_highlight(
			"TabLineFill",
			states.BufferStates.ACTIVE,
			{ italic = true, bold = true },
			"TabLineActive"
		)
	end
	return generate_tabline_highlight("TabLineFill", states.BufferStates.INACTIVE, {}, "TabLineInactive")
end

_G.tabline_close_button_callback = function(bufnr)
	-- states.close_button_click_timer = timer_fn(states.close_button_click_timer, 50, function()
	if not buf_is_valid(bufnr) and nvim_get_option_value("buflisted", { buf = bufnr }) then
		return
	end
	if nvim_get_option_value("modified", { buf = bufnr }) then
		local choice = vim.fn.confirm("This buffer's been modified!! Wanna save first before closing?", "&Yes\n&No", 2)
		if choice == 1 then
			vim.cmd([[ silent! w ]])
		end
	end
	schedule(function()
		nvim_buf_delete(bufnr, { force = false })
		states.buffers_list = get_tabline_buffers_list(nvim_list_bufs())
		states.buffers_spec = get_buffers_with_specs(states.buffers_list)
		local bufs = states.buffers_list
		local buf_specs = states.buffers_spec
		fetch_visible_buffers(nvim_get_current_buf(), bufs, buf_specs)
	end)
end

---Generates the buffer string for the tabline.
---@param bufnr integer The buffer number.
---@return string The formatted buffer string.
local function generate_buffer_string(bufnr, bufs)
	local buf_spec = get_buffer_info(bufnr, bufs)
	if not buf_spec then
		return ""
	end
	local buf_hl = get_buffer_highlight(bufnr)
	local left_padding, right_padding = buf_spec.left_padding, buf_spec.right_padding
	local buf_string = string.format(
		"%%%d@v:lua.tabline_click_buffer_callback@%%#%s#%s%s%s%%#%s#%s%s%%X%s%%*",
		bufnr,
		buf_spec.icon_hl,
		states.icons.separator,
		left_padding,
		buf_spec.icon,
		buf_hl,
		buf_spec.buf_name,
		right_padding,
		buf_spec.close_btn
	)
	return buf_string
end

---Updates the global tabline buffer string.
local function update_tabline_buffer_string()
	states.tabline_update_buffer_string_timer = timer_fn(states.tabline_update_buffer_string_timer, 50, function()
		states.timer_count = states.timer_count + 1
		local str = ""
		local bufs = states.buffers_list
		for _, bufnr in ipairs(states.visible_buffers) do
			str = str .. generate_buffer_string(bufnr, bufs)
		end
		states.cache.tabline_string = string.format(
			"%s%s%s%s%s",
			states.left_overflow_str,
			str,
			states.right_overflow_str,
			"%#TabLineFill#%=",
			states.tabpages_str
		)
		vim.cmd([[redrawtabline]])
	end)
end

M.get_tabline = function()
	return states.cache.tabline_string
end

M.tab_info = function()
	states.tabs = api.nvim_list_tabpages()
	states.current_tab = api.nvim_get_current_tabpage()
end

local get_tabpage_hl = function(tab)
	local status_icon_active_hl = generate_tabline_highlight(
		"TabLineTabPageActive",
		states.BufferStates.ACTIVE,
		{ reverse = false },
		"TablineTabPageStatusIcon"
	)
	local status_icon_inactive_hl = generate_tabline_highlight(
		"TabLineTabPageActive",
		states.BufferStates.INACTIVE,
		{ reverse = false },
		"TablineTabPageStatusIconInactive"
	)
	local tabnr_inactive_hl = generate_tabline_highlight(
		"TabLineTabPageActive",
		states.BufferStates.INACTIVE,
		{ reverse = true },
		"TabLineTabPageInactive"
	)
	if nvim_get_current_tabpage() == tab then
		return "%#TabLineTabPageActive#",
			string.format("%%#%s#", status_icon_active_hl),
			states.icons.tabpage_status_icon_active
	end
	return string.format("%%#%s#", tabnr_inactive_hl),
		string.format("%%#%s#", status_icon_inactive_hl),
		states.icons.tabpage_status_icon_inactive
end

M.tabline_update_tab_string = function(tabs)
	local str = ""
	for idx, tab in ipairs(tabs) do
		local hl, close_hl, close_icon = get_tabpage_hl(tab)
		str = string.format(
			"%s%%%d@v:lua.tabline_click_tabpage_callback@%s%%T %s %d %s",
			close_hl,
			idx,
			close_icon,
			hl,
			idx,
			str
		)
	end
	states.tabpages_str = string.format(
		"%s%%@v:lua.tabline_click_tabpage_icon_callback@ %s %%T%%* %s",
		"%#TabLineTabPageIcon#",
		states.icons.tabpage_icon,
		str
	)
end

_G.tabline_click_tabpage_callback = function(tabnr, n_clicks, type)
	if type == "r" then
		if #(vim.api.nvim_list_tabpages()) <= 1 then
			vim.notify("Cannot close the last tabpage !!", "error", { title = "Invalid Tabpage Action" })
			return
		end
		vim.cmd(string.format("tabclose %d", tabnr))
	elseif type == "l" and n_clicks == 2 then
		vim.cmd("tabnew")
	elseif type == "l" and n_clicks == 1 then
		vim.cmd(string.format("tabnext %s", tabnr))
	end
end

_G.tabline_click_tabpage_icon_callback = function()
	vim.cmd([[tabnew]])
end

M.tabline_update_tabpages_info = function()
	states.tabline_tabpage_timer = timer_fn(states.tabline_tabpage_timer, 50, function()
		states.timer_count = states.timer_count + 1
		local tabs = nvim_list_tabpages() or {}
		M.tabline_update_tab_string(tabs)
		states.tabpages_str_length = nvim_eval_statusline(states.tabpages_str, { use_tabline = true }).width
	end)
end

M.get_tabline_buffers_list = get_tabline_buffers_list
M.update_tabline_buffer_string = update_tabline_buffer_string
M.get_buffers_with_specs = get_buffers_with_specs
M.generate_buffer_string = generate_buffer_string

M.update_tabline_buffer_info = function()
	states.tabline_update_buffer_info_timer = timer_fn(states.tabline_update_buffer_info_timer, 50, function()
		local bufnr = nvim_get_current_buf()
		if not buf_is_valid(bufnr) then
			return
		end
		states.timer_count = states.timer_count + 1
		states.buffers_list = get_tabline_buffers_list(nvim_list_bufs())
		states.buffers_spec = get_buffers_with_specs(states.buffers_list)
		states.left_overflow_idicator_length = 0
		states.right_overflow_idicator_length = 0
		local bufs = states.buffers_list
		local buf_specs = states.buffers_spec
		fetch_visible_buffers(bufnr, bufs, buf_specs)
		M.update_overflow_info(bufs)
		fetch_visible_buffers(bufnr, bufs, buf_specs) -- overflow indicators might shorten the available width
	end)
end

return M
