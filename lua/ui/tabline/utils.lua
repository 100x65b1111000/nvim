local states = require("ui.tabline.states")

local M = {}

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

M.timer_fn = timer_fn

---Checks if a buffer is valid for display in the tabline.
---@param bufnr integer The buffer number to check.
---@return boolean True if the buffer is valid, false otherwise.
local function buf_is_valid(bufnr)
	return vim.api.nvim_buf_is_loaded(bufnr)
		and vim.api.nvim_buf_is_valid(bufnr)
		and vim.api.nvim_buf_get_name(bufnr) ~= ""
		and (vim.api.nvim_get_option_value("buftype", { buf = bufnr }) == "")
		and vim.fn.isdirectory(vim.api.nvim_buf_get_name(bufnr)) == 0
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

---Finds the index of a value in a table.
---@param tbl integer[] The table to search.
---@param n integer The value to find.
---@return integer|nil The index of the value, or nil if not found.
local function find_index(tbl, n)
	for i, v in ipairs(tbl) do
		if v == n then
			return i
		end
	end
	return 1
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
---@return string The name of the generated highlight group.
local function generate_highlight(source_fg, source_bg, opts, brightness_bg, brightness_fg, prefix, suffix, new_name)
	if new_name and vim.tbl_contains(states.cache.highlights) then
		return new_name
	end
	opts = opts or {}
	local source_hl_fg = get_highlight(source_fg).fg
	local source_hl_bg = get_highlight(source_bg).bg
	local fallback_hl = get_highlight("Normal") -- User Normal as default hlgroup as fg and bg values are defined in it
	local fg = "#" .. string.format("%06x", source_hl_fg or fallback_hl.fg)
	local bg = "#" .. string.format("%06x", source_hl_bg or fallback_hl.bg)

	bg = alter_hex_color(bg, brightness_bg)
	fg = alter_hex_color(fg, brightness_fg)
	suffix = suffix or ""
	prefix = prefix or ""
	local hl_opts = vim.tbl_extend("force", { fg = fg, bg = bg }, opts)
	local hl_string = new_name or prefix .. (source_fg or source_bg) .. suffix
	if not vim.tbl_contains(states.cache.highlights, hl_string) then
		-- vim.notify("Tabline: Generating highlight group: " .. hl_string) --debug purposes
		vim.api.nvim_set_hl(0, hl_string, hl_opts)
		table.insert(states.cache.highlights, hl_string)
	end
	return hl_string
end

--@param state integer
local function generate_tabline_highlight(source, state, opts, new_name)
	if vim.tbl_contains(states.cache.highlights, new_name) then
		return new_name
	end
	local suffix, prefix, brightness_bg, brightness_fg = nil, nil, 0, 0
	if state == states.BufferStates.ACTIVE then
		suffix, prefix, brightness_bg, brightness_fg = "Active", "Tabline", 75, 0
	elseif state == states.BufferStates.INACTIVE then
		suffix, prefix, brightness_bg, brightness_fg = "Inactive", "Tabline", 50, -50
	elseif state == states.BufferStates.NONE then
		suffix, prefix, brightness_bg, brightness_fg = "None", "Tabline", 50, 0
	end
	states.highlight_gen_count = states.highlight_gen_count + 1
	return generate_highlight(source, "TabLineFill", opts, brightness_bg, brightness_fg, prefix, suffix, new_name)
end

---Gets the buffer state.
---@param bufnr integer The buffer number.
---@return integer
local function get_buffer_state(bufnr, bufs)
	if bufnr == vim.api.nvim_get_current_buf() then
		return states.BufferStates.ACTIVE
	elseif vim.tbl_contains(bufs, bufnr) then
		return states.BufferStates.INACTIVE
	end
	return states.BufferStates.NONE
end

---Processes the buffer name for display.
---@param bufnr integer The buffer number.
---@return string The processed buffer name.
local function process_buffer_name(bufnr)
	local buf = vim.api.nvim_buf_get_name(bufnr)
	local bufname = vim.fn.fnamemodify(buf, ":t")
	local init_files = states.init_files or { "init.lua" }
	if vim.list_contains(init_files, bufname) then
		bufname = vim.fn.fnamemodify(vim.api.nvim_buf_get_name(bufnr), ":h:t") .. "/" .. bufname
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
	local filetype = vim.api.nvim_buf_get_name(bufnr)
	local icon, hl = "", ""
	if not package.loaded["mini.icons"] then
		icon, hl = "", "TabLineFill"
		return icon, hl
	end
	if states.cache.fileicons[filetype] == nil then
		icon, hl = MiniIcons.get("file", filetype)
		states.cache.fileicons[filetype] = { icon = icon, hl = hl }
	end
	return states.cache.fileicons[filetype].icon, states.cache.fileicons[filetype].hl
end

---Gets the close button string.
---@param bufnr integer The buffer number.
local function get_close_button(bufnr)
	local close_btn_inactive_hl =
		generate_tabline_highlight("MiniIconsRed", states.BufferStates.INACTIVE, {}, "TabLineCloseButtonInactive")

	if vim.api.nvim_get_mode().mode == "i" and bufnr == vim.api.nvim_get_current_buf() then
		local close_btn_insert_mode_hl =
			generate_tabline_highlight("MiniIconsGreen", states.BufferStates.ACTIVE, {}, "TabLineDotActive")
		return string.format(
			"%%%d@v:lua.tabline_close_button_callback@%%#%s#%s%%X",
			bufnr,
			close_btn_insert_mode_hl,
			states.icons.active_dot
		)
	end
	if vim.api.nvim_get_option_value("modified", { buf = bufnr }) and bufnr == vim.api.nvim_get_current_buf() then
		local close_btn_modified_hl =
			generate_tabline_highlight("MiniIconsOrange", states.BufferStates.ACTIVE, {}, "TabLineModified")
		return string.format(
			"%%%d@v:lua.tabline_close_button_callback@%%#%s#%s%%X",
			bufnr,
			close_btn_modified_hl,
			states.icons.active_dot
		)
	end
	if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
		local close_btn_modified_hl =
			generate_tabline_highlight("MiniIconsOrange", states.BufferStates.NONE, {}, "TabLineModified")
		return string.format(
			"%%%d@v:lua.tabline_close_button_callback@%%#%s#%s%%X",
			bufnr,
			close_btn_modified_hl,
			states.icons.active_dot
		)
	end
	if bufnr == vim.api.nvim_get_current_buf() then
		local close_btn_active_hl =
			generate_tabline_highlight("MiniIconsRed", states.BufferStates.ACTIVE, {}, "TabLineCloseButtonActive")
		return string.format(
			"%%%d@v:lua.tabline_close_button_callback@%%#%s#%s%%X",
			bufnr,
			close_btn_active_hl,
			states.icons.close
		)
	end

	return string.format(
		"%%%d@v:lua.tabline_close_button_callback@%%#%s#%s%%X",
		bufnr,
		close_btn_inactive_hl,
		states.icons.close
	)
end

-- M.tabline_update_close_button = tabline_update_close_button

-- M.tabline_get_close_button = function()
-- 	states.tabline_close_btn_debounce_timer = timer_fn(states.tabline_close_btn_debounce_timer, 50, function()
-- 		for _, buf in ipairs(states.visible_buffers) do
-- 			tabline_update_close_button(buf)
-- 		end
-- 	end)
-- end

_G.tabline_click_buffer_callback = function(bufnr)
	if not buf_is_valid(bufnr) and vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
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
	local length = vim.fn.strwidth(buf_name)
		+ vim.fn.strwidth(icon)
		+ vim.fn.strwidth(left_padding)
		+ vim.fn.strwidth(right_padding)
		+ vim.fn.strwidth(states.icons.close)
		+ vim.fn.strwidth(states.icons.separator)
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

M.alter_hex_color = alter_hex_color
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

local get_overflow_indicator_info = function(bufs)
	local left_dist = states.start_idx - 1
	local right_dist = #bufs - states.end_idx
	local left_overflow_str = states.icons.left_overflow_indicator
	local right_overflow_str = states.icons.right_overflow_indicator
	local left_overflow_indicator_hl = generate_tabline_highlight(
		"MiniIconsOrange",
		states.BufferStates.INACTIVE,
		{ reverse = false },
		"OverflowIndicatorInactive"
	)
	local right_overflow_indicator_hl = left_overflow_indicator_hl
	if left_dist > 0 then
		left_overflow_indicator_hl = generate_tabline_highlight(
			"MiniIconsOrange",
			states.BufferStates.ACTIVE,
			{ reverse = true },
			"OverflowIndicatorLeftActive"
		)
	end
	if right_dist > 0 then
		right_overflow_indicator_hl = generate_tabline_highlight(
			"MiniIconsOrange",
			states.BufferStates.ACTIVE,
			{ reverse = true },
			"OverflowIndicatorRightActive"
		)
	end
	left_overflow_str = string.format("%%#%s#%s%%#TabLineFill# ", left_overflow_indicator_hl, left_overflow_str)
	right_overflow_str = string.format(" %%#%s#%s", right_overflow_indicator_hl, right_overflow_str)
	states.left_overflow_idicator_length = vim.api.nvim_eval_statusline(left_overflow_str, { use_tabline = true }).width
	states.right_overflow_idicator_length =
		vim.api.nvim_eval_statusline(right_overflow_str, { use_tabline = true }).width
	return {
		left_overflow_str = left_overflow_str,
		right_overflow_str = right_overflow_str,
	}
end

local calculate_buf_range = function(bufs, current_buf_index, nbufs)
	states.diff = #bufs - current_buf_index
	states.offset = math.floor(nbufs / 2)
	if states.diff >= states.offset then
		states.start_idx = math.max(1, current_buf_index - states.offset)
		states.end_idx = math.min(#bufs, states.start_idx + nbufs)
	else
		states.end_idx = current_buf_index + states.diff
		states.start_idx = math.max(1, states.end_idx - nbufs + 1)
	end
end

M.calculate_buf_range = calculate_buf_range
M.calculate_buf_space = calculate_buf_space

local fetch_visible_buffers = function(bufnr, bufs, buf_specs)
	local available_space = vim.o.columns
		- (states.left_overflow_idicator_length + states.right_overflow_idicator_length)
	vim.schedule(function()
		available_space = vim.o.columns - (states.left_overflow_idicator_length + states.right_overflow_idicator_length)
	end)
	local buf_space = calculate_buf_space(bufs)
	local average_buf_width = math.floor(buf_space / #bufs)
	local nbufs = math.floor(available_space / average_buf_width) -- guess the number of buffers to be displayed based on the average width
	local current_buf_index = find_index(bufs, bufnr)

	local occupied_space = 0
	local visible_buffers = {}
	states.start_idx = 1
	states.end_idx = #bufs
	states.visible_buffers = bufs

	if buf_space <= available_space then
		return
	end

	local right_offset = #bufs - current_buf_index
	local left_offset = math.floor(nbufs / 2)
	local initial_idx = #bufs

	if right_offset >= left_offset then
		initial_idx = math.max(1, current_buf_index - left_offset)
		while occupied_space + buf_specs[bufs[initial_idx]].length <= available_space do
			local buf = bufs[initial_idx]
			local info = buf_specs[buf]
			occupied_space = occupied_space + info.length
			table.insert(visible_buffers, buf)
			initial_idx = math.min(#bufs, initial_idx + 1)
		end
	else
		initial_idx = math.min(#bufs, current_buf_index + right_offset)
		while occupied_space + buf_specs[bufs[initial_idx]].length <= available_space do
			local buf = bufs[initial_idx]
			local info = buf_specs[buf]
			occupied_space = occupied_space + info.length
			table.insert(visible_buffers, 1, buf)
			initial_idx = math.max(1, initial_idx - 1)
		end
	end

	states.start_idx = find_index(bufs, visible_buffers[1])
	states.end_idx = find_index(bufs, visible_buffers[#visible_buffers])
	states.visible_buffers = visible_buffers
end

M.fetch_visible_buffers = fetch_visible_buffers

---Gets buffer highlight.
---@param bufnr integer The buffer number.
---@return string The highlight group name.
local function get_buffer_highlight(bufnr) -- changed from get_buf_hl
	if vim.api.nvim_get_current_buf() == bufnr then
		return generate_tabline_highlight(
			"TabLineFill",
			states.BufferStates.ACTIVE,
			{ italic = true, bold = true },
			"TabLineBufActive"
		)
	end
	return generate_tabline_highlight("TabLineFill", states.BufferStates.INACTIVE, {}, "TabLineBufInactive")
end

_G.tabline_close_button_callback = function(bufnr)
	timer_fn(states.close_button_click_timer, 50, function()
		if not buf_is_valid(bufnr) and vim.api.nvim_get_option_value("buflisted", { buf = bufnr }) then
			return
		end
		if vim.api.nvim_get_option_value("modified", { buf = bufnr }) then
			local choice =
				vim.fn.confirm("This buffer's been modified!! Wanna save first before closing?", "&Yes\n&No", 2)
			if choice == 1 then
				vim.cmd([[ silent! w ]])
			end
		end
		vim.schedule(function()
			vim.api.nvim_buf_delete(bufnr, { force = true })
			states.buffers_list = get_tabline_buffers_list(vim.api.nvim_list_bufs())
			states.buffers_spec = get_buffers_with_specs(states.buffers_list)
			local bufs = states.buffers_list
			local buf_specs = states.buffers_spec
			fetch_visible_buffers(vim.api.nvim_get_current_buf(), bufs, buf_specs)
		end)
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
		"%%%d@v:lua.tabline_click_buffer_callback@%%#%s#%s%s%s%%#%s#%s%s%s",
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
	timer_fn(states.tabline_update_debounce_timer, 50, function()
		local str = ""
		local bufs = states.buffers_list
		for _, bufnr in ipairs(states.visible_buffers) do
			str = str .. generate_buffer_string(bufnr, bufs)
		end
		local overflow_info = get_overflow_indicator_info(bufs)
		states.cache.tabline_buf_string = overflow_info.left_overflow_str
			.. str
			.. "%#TabLineFill#"
			.. "%="
			.. overflow_info.right_overflow_str
		vim.cmd([[redrawtabline]])
	end)
end

M.get_tabline = function()
	return states.cache.tabline_buf_string
end

M.get_tabline_buffers_list = get_tabline_buffers_list
M.update_tabline_buffer_string = update_tabline_buffer_string
M.get_buffers_with_specs = get_buffers_with_specs
M.generate_buffer_string = generate_buffer_string
M.find_index = find_index

M.update_tabline_buffer_info = function()
	timer_fn(states.tabline_debounce_timer, 50, function()
		states.buffers_list = get_tabline_buffers_list(vim.api.nvim_list_bufs())
		states.buffers_spec = get_buffers_with_specs(states.buffers_list)
		local bufnr = vim.api.nvim_get_current_buf()
		local bufs = states.buffers_list
		local buf_specs = states.buffers_spec
		states.buffer_count = states.buffer_count + 1
		fetch_visible_buffers(bufnr, bufs, buf_specs)
	end)
end

return M
