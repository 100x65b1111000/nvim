local M = {}

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
M.default_config = {
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
M.current_config = {}

M.cache = {
	highlights = {},
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
	}
}
---@return StatusLineModuleFnTable
local fallback_fn = function()
	return { hl_group = "", string = "", icon = "", icon_hl = "" }
end

---@type StatusLineModuleFn[]
M.modules_map = {
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
	["filetype"] = fallback_fn
}

M.Modes = {
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

M.git_cmd = "git --no-pager --no-optional-locks --literal-pathspecs -c gc.auto= -C "

return M
