local M = {}
local states = require("ui.states")

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

--------------------------------------------------------------------------------
-- Color Space Conversion Helpers
--------------------------------------------------------------------------------

--- Converts RGB color values to HSL.
-- @local
-- @param r integer Red component (0-255).
-- @param g integer Green component (0-255).
-- @param b integer Blue component (0-255).
-- @return number Hue (0-360), Saturation (0-1), Lightness (0-1).
local function rgb_to_hsl(r, g, b)
	r, g, b = r / 255, g / 255, b / 255
	local max, min = math.max(r, g, b), math.min(r, g, b)
	local h, s, l

	l = (max + min) / 2

	if max == min then
		h, s = 0, 0 -- achromatic (grayscale)
	else
		local d = max - min
		s = l > 0.5 and d / (2 - max - min) or d / (max + min)
		if max == r then
			h = (g - b) / d + (g < b and 6 or 0)
		elseif max == g then
			h = (b - r) / d + 2
		else -- max == b
			h = (r - g) / d + 4
		end
		h = h * 60
	end

	return h, s, l
end

--- Converts HSL color values to RGB.
-- @local
-- @param h number Hue (0-360).
-- @param s number Saturation (0-1).
-- @param l number Lightness (0-1).
-- @return integer Red, Green, and Blue components (0-255).
local function hsl_to_rgb(h, s, l)
	local r, g, b

	if s == 0 then
		r, g, b = l, l, l -- achromatic
	else
		local function hue_to_rgb(p, q, t)
			if t < 0 then
				t = t + 1
			end
			if t > 1 then
				t = t - 1
			end
			if t < 1 / 6 then
				return p + (q - p) * 6 * t
			end
			if t < 1 / 2 then
				return q
			end
			if t < 2 / 3 then
				return p + (q - p) * (2 / 3 - t) * 6
			end
			return p
		end

		local q = l < 0.5 and l * (1 + s) or l + s - l * s
		local p = 2 * l - q
		h = h / 360
		r = hue_to_rgb(p, q, h + 1 / 3)
		g = hue_to_rgb(p, q, h)
		b = hue_to_rgb(p, q, h - 1 / 3)
	end

	-- Round to nearest integer
	return math.floor(r * 255 + 0.5), math.floor(g * 255 + 0.5), math.floor(b * 255 + 0.5)
end

--------------------------------------------------------------------------------
-- Core Logic
--------------------------------------------------------------------------------

--- Alters the lightness of a hex color string by a given percentage.
-- @local
-- @param hex string The hex color string (e.g., "#rrggbb", "#rgb", "#rrggbbaa").
-- @param percentage number The percentage to alter the lightness by.
-- @return string|nil The altered hex color string, or nil if an error occurred.
-- @return string|nil An error message if the input was invalid.
local function alter_hex(hex, brightness, saturation)
	-- 1. --- Input Validation ---
	if type(hex) ~= "string" or type(brightness) ~= "number" then
		return nil, "Invalid argument types: expected (string, number)."
	end

	-- 2. --- Parsing and Normalization ---
	local clean_hex = hex:gsub("#", "")
	local len = #clean_hex
	local r_hex, g_hex, b_hex, a_hex

	if len == 3 then -- Shorthand hex: #rgb -> #rrggbb
		r_hex, g_hex, b_hex = clean_hex:sub(1, 1):rep(2), clean_hex:sub(2, 2):rep(2), clean_hex:sub(3, 3):rep(2)
	elseif len == 4 then -- Shorthand hex with alpha: #rgba -> #rrggbbaa
		r_hex, g_hex, b_hex, a_hex =
			clean_hex:sub(1, 1):rep(2),
			clean_hex:sub(2, 2):rep(2),
			clean_hex:sub(3, 3):rep(2),
			clean_hex:sub(4, 4):rep(2)
	elseif len == 6 then -- Standard hex: #rrggbb
		r_hex, g_hex, b_hex = clean_hex:sub(1, 2), clean_hex:sub(3, 4), clean_hex:sub(5, 6)
	elseif len == 8 then -- Standard hex with alpha: #rrggbbaa
		r_hex, g_hex, b_hex, a_hex = clean_hex:sub(1, 2), clean_hex:sub(3, 4), clean_hex:sub(5, 6), clean_hex:sub(7, 8)
	else
		error("Invalid hex string format. Must be 3, 4, 6, or 8 characters (excluding '#').")
	end

	local r, g, b = tonumber(r_hex, 16), tonumber(g_hex, 16), tonumber(b_hex, 16)
	if not (r and g and b) then
		error("Invalid characters found in hex string.")
	end

	-- 3. --- Color Alteration via HSL ---
	-- Convert to HSL, modify lightness, and convert back to RGB.
	local h, s, l = rgb_to_hsl(r, g, b)

	-- Adjust lightness by the percentage.
	if brightness and brightness > 0 then
		l = l + (1 - l) * (brightness / 100)
	else
		l = l + l * (brightness / 100)
	end

	if saturation and saturation > 0 then
		s = saturation and s + (1 - s) * (saturation / 100) or s
	else
		s = saturation and s + s * (saturation / 100) or s
	end

	l = math.max(0, math.min(1, l)) -- Clamp lightness between 0 and 1.

	local new_r, new_g, new_b = hsl_to_rgb(h, s, l)

	-- 4. --- Reformatting ---
	if a_hex then
		return string.format("#%02x%02x%02x%s", new_r, new_g, new_b, a_hex)
	else
		return string.format("#%02x%02x%02x", new_r, new_g, new_b)
	end
end

--------------------------------------------------------------------------------
-- Public API
--------------------------------------------------------------------------------

--- Darkens a hex color by a given percentage.
---@param hex string The hex color string (e.g., "#rrggbb").
---@param percentage number The percentage to darken by (0-100).
---@return string|nil The darkened hex color string, or nil on error.
---@return string|nil An error message if the input was invalid.
M.darken = function(hex, percentage)
	return alter_hex(hex, -math.abs(percentage))
end

--- Lightens a hex color by a given percentage.
---@param hex string The hex color string (e.g., "#rrggbb").
---@param percentage number The percentage to lighten by (0-100).
---@return string|nil The lightened hex color string, or nil on error.
---@return string|nil An error message if the input was invalid.
M.lighten = function(hex, percentage)
	return alter_hex(hex, math.abs(percentage))
end

--- Alters the color of a hex string by a given percentage.
-- A positive `val` lightens the color, a negative `val` darkens it.
---@param hex string The hex color string (e.g., "#rrggbb").
---@param brightness integer The percentage to alter the color by.
---@return string|nil The altered hex color string, or nil on error.
---@return string|nil An error message if the input was invalid.
M.alter_hex_color = function(hex, brightness, saturation)
	return alter_hex(hex, brightness, saturation)
end
---Generates a highlight group.
---@param source_fg string The source highlight group for fg.
---@param source_bg string The source highlight group for bg.
---@param opts table Additional highlight options.
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
	fg = M.alter_hex_color(fg, brightness_fg, math.floor(brightness_fg * 1.75))
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
	assert(timer)
	timer:start(timeout, 0, function()
		vim.schedule(callback)
	end)
	return timer
end

return M
