local M = {}

M.cache = { highlights = {}}

-- *** Tabline Cache ***
M.tabline_states = {}
M.tabline_states.BufferStates = {
	ACTIVE = 1,
	INACTIVE = 2,
	NONE = 3,
}

M.tabline_states.tabline_buf_str_max_width = 18

M.tabline_states.cache = {
	tabline_buf_string = "",
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
}

M.tabline_states.end_idx = 1
M.tabline_states.start_idx = 1
M.tabline_states.diff = 0
M.tabline_states.offset = 0
---@type integer[]
M.tabline_states.visible_buffers = {}

M.tabline_states.left_overflow_idicator_length = 0
M.tabline_states.right_overflow_idicator_length = 0

M.tabline_states.buffer_map = {}
M.tabline_states.buffer_count = 0
M.tabline_states.buffers_list = {}
M.tabline_states.buffers_spec = {}
M.tabline_states.highlight_gen_count = 0
M.tabline_states.available_width = vim.o.columns


M.statusline_states = {}
---@class StatusLineDefaultConfig
---@field modules StatusLineModulesConfig | nil

---@alias StatusLineModuleFnTable { string: string, hl_group: string, icon: string, icon_hl: string, reverse: boolean, max_len: integer }

---@alias StatusLineModuleFn fun(): StatusLineModuleFnTable
---@alias StatusLineBuiltinModules "mode"|"buf-status"|"bufinfo"|"root-dir"|"ts-info"|"git-branch"|"file-percent"|"git-status"|"filetype"|"diagnostic"|"lsp-info"|"cursor-pos"|"scroll-pos"

---@class StatusLineModulesConfig
---@field left StatusLineBuiltinModules[]|nil
---@field middle StatusLineBuiltinModules[]|nil
---@field right StatusLineBuiltinModules[]|nil

---@type StatusLineDefaultConfig
M.statusline_states.default_config = {
	modules = {
		left = {
			"mode",
			"buf-status",
			-- "ts-info",
			"bufinfo",
			"filetype",
		},
		middle = {
			"root-dir",
			"git-branch",
			"git-status",
		},
		right = {
			"diagnostic",
			"lsp-info",
			"cursor-pos",
			"file-percent",
		},
	},
}

---@type StatusLineConfig
M.statusline_states.current_config = {}

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
---@return StatusLineModuleFnTable
local fallback_fn = function()
	return { hl_group = "", string = "", icon = "", icon_hl = "" }
end

---@type StatusLineModuleFn[]
M.statusline_states.modules_map = {
	["mode"] = fallback_fn,
	["buf-status"] = fallback_fn,
	["bufinfo"] = fallback_fn,
	["root-dir"] = fallback_fn,
	["git-status"] = fallback_fn,
	["git-branch"] = fallback_fn,
	["diagnostic-info"] = fallback_fn,
	["lsp-info"] = fallback_fn,
	["cursor-pos"] = fallback_fn,
	["scroll-pos"] = fallback_fn,
	["filetype"] = fallback_fn,
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
	["ic"] = { name = "  INSERT ", hl = "StatusLineInsertMode" },
	["R"] = { name = "  REPLACE ", hl = "StatusLineReplaceMode" },
	["Rv"] = { name = "  [V] REPLACE ", hl = "StatusLineReplaceMode" },
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
return M
