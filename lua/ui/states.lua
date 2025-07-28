local M = {}

M.cache = { highlights = {} }

--- *** Tabline Cache ***
M.tabline_states = {}

M.tabline_states.BufferStates = {
	ACTIVE = 1,
	INACTIVE = 2,
	NONE = 3,
	MISC = 4, -- Added for miscellaneous states like modified inactive
}

M.tabline_states.tabline_buf_str_max_width = math.huge

M.tabline_states.cache = {
	tabline_string = "",
	highlights = M.cache.highlights,
	fileicons = {},
	-- last_visible_buffers = {}, -- Unused
	-- close_button_string = "", -- Unused
}

M.tabline_states.init_files = {
	["init.lua"] = true
}

---@class Icons
M.tabline_states.icons = {
	active_dot = "  ",
	close = "  ",
	separator = "▎",
	left_overflow_indicator = "  ",
	right_overflow_indicator = "  ",
	tabpage_icon = "󰝜 ",
	tabpage_status_icon_active = "  ",
	tabpage_status_icon_inactive = "  ",
}

M.tabline_states.end_idx = 1
M.tabline_states.start_idx = 1
-- M.tabline_states.diff = 0 -- Unused
-- M.tabline_states.offset = 0 -- Unused

---@type integer[]
M.tabline_states.visible_buffers = {}
-- M.tabline_states.bufname_count = {} -- Replaced by duplicate_buf_names logic

M.tabline_states.left_overflow_str = ""
M.tabline_states.right_overflow_str = ""
M.tabline_states.left_overflow_idicator_length = 0
M.tabline_states.right_overflow_idicator_length = 0

M.tabline_states.buffer_map = {}
M.tabline_states.timer_count = 0
M.tabline_states.buffers_list = {}
M.tabline_states.buffers_spec = {}
M.tabline_states.duplicate_buf_names = {} -- Added for caching duplicate buffer names
M.tabline_states.has_mini_icons = false -- Added for caching mini.icons check
-- M.tabline_states.highlight_gen_count = 0 -- Unused

M.tabline_states.tabpages_str = ""
M.tabline_states.tabpages_str_length = 0

M.tabline_states.tabline_update_buffer_string_timer = nil
M.tabline_states.tabline_update_buffer_info_timer = nil
M.tabline_states.tabline_tabpage_timer = nil

M.statusline_states = {}

---@alias StatusLineModuleFnTable { string: string, hl_group: string, icon: string, icon_hl: string, reverse: boolean, left_sep_hl: string, right_sep_hl: string, show_right_sep: boolean, show_left_sep: boolean }

---@alias StatusLineBuiltinModules "mode"|"buf-status"|"bufinfo"|"root-dir"|"ts-info"|"git-branch"|"file-percent"|"git-status"|"filetype"|"diagnostic"|"lsp-info"|"cursor-pos"|"scroll-pos"|"search-status"
---@alias StatusLineSeparator { left: string, right: string }

---@class StatusLineModulesConfig
---@field left StatusLineBuiltinModules[]|nil
---@field middle StatusLineBuiltinModules[]|nil
---@field right StatusLineBuiltinModules[]|nil

---@alias StatusLineModules StatusLineBuiltinModules
---
---@class StatusLineModuleTypeConfig
---@field separator StatusLineSeparator
---@field modules StatusLineModules[]

---@class StatusLineConfig
---@field enabled boolean
---@field left StatusLineModuleTypeConfig
---@field middle StatusLineModuleTypeConfig
---@field right StatusLineModuleTypeConfig

---@type StatusLineConfig
M.statusline_states.default_config = {
	enabled = true,
	left = {
		separator = { left = "", right = "" },
		modules = {
			"mode",
			"buf-status",
			-- "ts-info",
			"bufinfo",
			"filetype",
			"search-status",
		},
	},
	middle = {
		separator = { left = "", right = "" },
		modules = {
			"root-dir",
			"git-branch",
			"git-status",
		},
	},
	right = {
		separator = { left = "", right = "" },
		modules = {
			"diagnostic",
			"lsp-info",
			"cursor-pos",
			"file-percent",
		},
	},
}

---@type StatusLineConfig
M.statusline_states.active_config = nil

---@return StatusLineModuleFnTable
local default_module_config = function()
	return {
		string = "",
	}
end

---@alias StatusLineModuleFn fun(): StatusLineModuleFnTable

---@type table<string, StatusLineModuleFn>
M.statusline_states.modules_map = {
	["mode"] = default_module_config,
	["buf-status"] = default_module_config,
	["bufinfo"] = default_module_config,
	["root-dir"] = default_module_config,
	["git-status"] = default_module_config,
	["git-branch"] = default_module_config,
	["diagnostic-info"] = default_module_config,
	["lsp-info"] = default_module_config,
	["cursor-pos"] = default_module_config,
	["scroll-pos"] = default_module_config,
	["file-percent"] = default_module_config,
	["filetype"] = default_module_config,
	["diagnostic"] = default_module_config,
}

M.statusline_states.cache = {
	highlights = M.cache.highlights,
	statusline_string = nil,
	mode_string = nil,
	buf_status = nil,
	bufname_string = nil,
	root_dir_string = nil,
	git_branch_string = nil,
	git_status_string = nil,
	diagnostic_info_string = nil,
	lsp_info_string = nil,
	cursor_pos_string = nil,
	scroll_pos_string = nil,
	filetype_icons = {
		["terminal"] = { icon = "  " },
		["prompt"] = { icon = " 󰘎 " },
		["nofile"] = { icon = " 󱀶 " },
		["minifiles"] = { icon = " 󰙅 " },
	},
}
M.statusline_states.Modes = {
	["n"] = { name = "  NORMAL ", mode_name = "NormalMode" },
	["no"] = { name = "  OPERATOR ", mode_name = "OperatorMode" },
	["v"] = { name = "  VISUAL ", mode_name = "VisualMode" },
	["V"] = { name = "  VISUAL LINE ", mode_name = "VisualMode" },
	[""] = { name = "  VISUAL BLOCK ", mode_name = "VisualMode" },
	["s"] = { name = "  [V] SELECT ", mode_name = "SelectMode" },
	["s"] = { name = "  SELECT ", mode_name = "SelectMode" },
	["S"] = { name = "  SELECT LINE ", mode_name = "SelectMode" },
	[""] = { name = "  SELECT BLOCK ", mode_name = "SelectMode" },
	["i"] = { name = "  INSERT ", mode_name = "InsertMode" },
	["niI"] = { name = "  INSERT ", mode_name = "InsertMode" },

	["ic"] = { name = "  INSERT ", mode_name = "InsertMode" },
	["R"] = { name = "  REPLACE ", mode_name = "ReplaceMode" },
	["niR"] = { name = "  REPLACE ", mode_name = "InsertMode" },
	["Rv"] = { name = "  [V] REPLACE ", mode_name = "ReplaceMode" },
	["niV"] = { name = "  [V] REPLACE ", mode_name = "ReplaceMode" },
	["c"] = { name = "  COMMAND ", mode_name = "CommandMode" },
	["cr"] = { name = "  COMMAND ", mode_name = "CommandMode" },
	["cv"] = { name = "  VIM EX ", mode_name = "CommandMode" },
	["cvr"] = { name = "  VIM EX ", mode_name = "CommandMode" },
	["ce"] = { name = "  EX ", mode_name = "CommandMode" },
	["r"] = { name = "  PROMPT ", mode_name = "Mode" },
	["rm"] = { name = "  MOAR ", mode_name = "Mode" },
	["r?"] = { name = "  CONFIRM ", mode_name = "ConfirmMode" },
	["!"] = { name = "  SHELL ", mode_name = "ShellMode" },
	["t"] = { name = "  TERMINAL ", mode_name = "TerminalMode" },
	["nt"] = { name = "  TERMINAL ", mode_name = "TerminalMode" },
	["ntT"] = { name = "  TERMINAL ", mode_name = "TerminalMode" },
}

M.statusline_states.git_cmd = "git --no-pager --no-optional-locks --literal-pathspecs -c gc.auto= -C "
M.statusline_states.timer_count = 0

return M
