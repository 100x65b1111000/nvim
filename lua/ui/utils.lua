local M = {}
local states  = require('ui.states')

---Retrieves highlight information for a given highlight group.
---@param hl_name string The name of the highlight group.
---@return vim.api.keyset.get_hl_info The highlight information.
M.get_highlight = function(hl_name)
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
M.find_index = function(tbl, n)
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
M.alter_color = function(c, val)
	return math.min(255, math.max(0, c * (1 + val / 100)))
end

---Alters the color of a hex string.
---@param hex string The hex color string (e.g., "#rrggbb").
---@param val integer The percentage to alter the color by.
---@return string The altered hex color string.
M.alter_hex_color = function(hex, val)
	hex = hex:gsub("#", "")
	local r = tonumber(hex:sub(1, 2), 16)
	local g = tonumber(hex:sub(3, 4), 16)
	local b = tonumber(hex:sub(5, 6), 16)

	r, g, b = M.alter_color(r, val), M.alter_color(g, val), M.alter_color(b, val)

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
M.generate_highlight = function(
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
	if new_name and states.cache.highlights[new_name] then
		return new_name
	end
	opts = opts or {}
	local source_hl_fg = (extra_opts and extra_opts.use_bg_for_fg and M.get_highlight(source_fg).bg)
		or M.get_highlight(source_fg).fg
	local source_hl_bg = (extra_opts and extra_opts.use_fg_for_bg and M.get_highlight(source_bg).fg)
		or M.get_highlight(source_bg).bg
	local fallback_hl = M.get_highlight("Normal") -- User Normal as default hlgroup if get_highlight return nil
	local fg = "#" .. string.format("%06x", source_hl_fg or fallback_hl.fg)
	local bg = "#" .. string.format("%06x", source_hl_bg or fallback_hl.bg)

	bg = M.alter_hex_color(bg, brightness_bg)
	fg = M.alter_hex_color(fg, brightness_fg)
	suffix = suffix or ""
	prefix = prefix or ""
	local hl_opts = vim.tbl_extend("force", { fg = fg, bg = bg }, opts)
	local hl_group = new_name or prefix .. (source_fg or source_bg) .. suffix
	if not states.cache.highlights[hl_group] then
		vim.api.nvim_set_hl(0, hl_group, hl_opts)
		states.cache.highlights[hl_group] = true
	end
	return hl_group
end

---@param timer uv.uv_timer_t|nil
---@param timeout integer
---@param callback function
M.timer_fn = function(timer, timeout, callback)
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

return M
