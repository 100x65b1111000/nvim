local M = {}

---@class BufferStates
M.BufferStates = {
	ACTIVE = 1,
	INACTIVE = 2,
	NONE = 3,
}

M.tabline_buf_str_max_width = 18

M["cache.highlights"] = {}

M.cache = {
	tabline_buf_string = "",
	highlights = {},
	fileicons = {},
	last_visible_buffers = {}
}

M.init_files = {
	"init.lua",
}

---@class Icons
M.icons = {
	active_dot = "  ",
	close = " 󰖭 ",
	separator = "▍",
	left_overflow_indicator = "  ",
	right_overflow_indicator = "  "
}

M.end_idx = 1
M.start_idx = 1
M.diff = 0
M.offset = 0
---@type integer[]
M.visible_buffers = {}

M.left_overflow_idicator_length = 0
M.right_overflow_idicator_length = 0

M.buffer_map = {}
M.buffer_count = 0
M.buffers_list = {}
M.buffers_spec = {}

-- M.should_overflow = false

return M

