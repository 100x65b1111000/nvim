local M = {}

M.cache = { highlights = {} }

--- *** Tabline Cache ***
M.tabline_states = {}
M.tabline_states.BufferStates = {
	ACTIVE = 1,
	INACTIVE = 2,
	NONE = 3,
}

M.tabline_states.tabline_buf_str_max_width = 18

M.tabline_states.cache = {
	tabline_string = "",
	highlights = M.cache.highlights,
	fileicons = {},
	last_visible_buffers = {},
	close_button_string = "",
}

M.tabline_states.init_files = {
	"init.lua",
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
M.tabline_states.diff = 0
M.tabline_states.offset = 0

---@type integer[]
M.tabline_states.visible_buffers = {}

M.tabline_states.left_overflow_str = ""
M.tabline_states.right_overflow_str = ""
M.tabline_states.left_overflow_idicator_length = 0
M.tabline_states.right_overflow_idicator_length = 0

M.tabline_states.buffer_map = {}
M.tabline_states.timer_count = 0
M.tabline_states.buffers_list = {}
M.tabline_states.buffers_spec = {}
M.tabline_states.highlight_gen_count = 0

M.tabline_states.tabpages_str = ""
M.tabline_states.tabpages_str_length = 0

M.tabline_states.tabline_update_buffer_string_timer = nil
M.tabline_states.tabline_update_buffer_info_timer = nil
M.tabline_states.tabline_tabpage_timer = nil

M.statusline_states = {}
---@alias StatusLineModuleFnTable { string: string, hl_group: string, icon: string, icon_hl: string, reverse: boolean, max_len: integer, sep: string, sep_hl: string }

---@alias StatusLineModuleFn fun(): StatusLineModuleFnTable
---@alias StatusLineBuiltinModules "mode"|"buf-status"|"bufinfo"|"root-dir"|"ts-info"|"git-branch"|"file-percent"|"git-status"|"filetype"|"diagnostic"|"lsp-info"|"cursor-pos"|"scroll-pos"
---@alias StatusLineSeparator { left: string, right: string }

---@class StatusLineModulesConfig
---@field left StatusLineBuiltinModules[]|nil
---@field middle StatusLineBuiltinModules[]|nil
---@field right StatusLineBuiltinModules[]|nil

---@alias StatusLineModules StatusLineBuiltinModules
---
---@class StatusLineModuleTypeConfig
---@field separator StatusLineSeparator
---@field modules StatusLineModules[]|nil

---@class StatusLineConfig
---@field left StatusLineModuleTypeConfig
---@field middle StatusLineModuleTypeConfig
---@field right StatusLineModuleTypeConfig

---@type StatusLineConfig
M.statusline_states.default_config = {
	left = {
		separator = { left = "", right = "" },
		modules = {
			"mode",
			"buf-status",
			-- "ts-info",
			"bufinfo",
			"filetype",
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
M.statusline_states.active_config = M.statusline_states.default_config

---@class StatusLineDefaultModuleConfig
---@field init fun(): StatusLineModuleFn

---@return {left_sep: table, right_sep: table, init: fun(): StatusLineModuleFn}
local default_module_config = function()
	return {
		init = function() end,
	}
end

---@type table<string, StatusLineDefaultModuleConfig>
M.statusline_states.modules_map = {
	["mode"] = default_module_config(),
	["buf-status"] = default_module_config(),
	["bufinfo"] = default_module_config(),
	["root-dir"] = default_module_config(),
	["git-status"] = default_module_config(),
	["git-branch"] = default_module_config(),
	["diagnostic-info"] = default_module_config(),
	["lsp-info"] = default_module_config(),
	["cursor-pos"] = default_module_config(),
	["scroll-pos"] = default_module_config(),
	["file-percent"] = default_module_config(),
	["filetype"] = default_module_config(),
	["diagnostic"] = default_module_config(),
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
	["n"] = { name = "  NORMAL ", hl = "StatusLineNormalMode" },
	["no"] = { name = "  OPERATOR ", hl = "StatusLineMode" },
	["v"] = { name = "  VISUAL ", hl = "StatusLineVisualMode" },
	["V"] = { name = "  VISUAL LINE ", hl = "StatusLineVisualMode" },
	[""] = { name = "  VISUAL BLOCK ", hl = "StatusLineVisualMode" },
	["s"] = { name = "  [V] SELECT ", hl = "StatusLineSelectMode" },
	["s"] = { name = "  SELECT ", hl = "StatusLineSelectMode" },
	["S"] = { name = "  SELECT LINE ", hl = "StatusLineSelectMode" },
	[""] = { name = "  SELECT BLOCK ", hl = "StatusLineSelectMode" },
	["i"] = { name = "  INSERT ", hl = "StatusLineInsertMode" },
	["niI"] = { name = "  INSERT ", hl = "StatusLineInsertMode" },

	["ic"] = { name = "  INSERT ", hl = "StatusLineInsertMode" },
	["R"] = { name = "  REPLACE ", hl = "StatusLineReplaceMode" },
	["niR"] = { name = "  REPLACE ", hl = "StatusLineInsertMode" },
	["Rv"] = { name = "  [V] REPLACE ", hl = "StatusLineReplaceMode" },
	["niV"] = { name = "  [V] REPLACE ", hl = "StatusLineReplaceMode" },
	["c"] = { name = "  COMMAND ", hl = "StatusLineCommandMode" },
	["cr"] = { name = "  COMMAND ", hl = "StatusLineCommandMode" },
	["cv"] = { name = "  VIM EX ", hl = "StatusLineCommandMode" },
	["cvr"] = { name = "  VIM EX ", hl = "StatusLineCommandMode" },
	["ce"] = { name = "  EX ", hl = "StatusLineCommandMode" },
	["r"] = { name = "  PROMPT ", hl = "StatusLineMode" },
	["rm"] = { name = "  MOAR ", hl = "StatusLineMode" },
	["r?"] = { name = "  CONFIRM ", hl = "StatusLineMode" },
	["!"] = { name = "  SHELL ", hl = "StatusLineShellMode" },
	["t"] = { name = "  TERMINAL ", hl = "StatusLineTerminalMode" },
	["nt"] = { name = "  TERMINAL ", hl = "StatusLineTerminalMode" },
	["ntT"] = { name = "  TERMINAL ", hl = "StatusLineTerminalMode" },
}

M.statusline_states.git_cmd = "git --no-pager --no-optional-locks --literal-pathspecs -c gc.auto= -C "
M.statusline_states.timer_count = 0

return M
