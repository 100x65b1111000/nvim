local M = {}

---@class StatusLineDefaultConfig
---@field use_mini_icons boolean | nil
---@field modules StatusLineModulesConfig | nil

---@alias StatusLineModuleFnTable { string: string, hl_group: string, icon: string, icon_hl: string, reverse: boolean }

---@alias StatusLineModuleFn fun(): StatusLineModuleFnTable
---@alias StatusLineModules "mode"|"buf-status"|"bufinfo"|"root-dir"|"git-branch"|"git-status"|"diagnostic-info"|"lsp-info"|"cursor-pos"|"scroll-pos"|StatusLineModuleFn

---@class StatusLineModulesConfig
---@field left StatusLineModules[]|nil
---@field middle StatusLineModules[]|nil
---@field right StatusLineModules[]|nil

---@type StatusLineDefaultConfig
M.default_config = {
	use_mini_icons = true,
	modules = {
		left = {
			"mode",
			"buf-status",
			"bufinfo",
		},
		middle = {
			"root-dir",
			"git-branch",
			"git-status",
		},
		right = {
			"diagnostic-info",
			"lsp-info",
			"cursor-pos",
			"scroll-pos",
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

return M
