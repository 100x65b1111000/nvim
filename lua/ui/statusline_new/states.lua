local M = {}

---@class StatusLineDefaultConfig
---@field use_mini_icons boolean
---@field modules StatusLineModules

---@alias LeftModules "mode"|"modified-status"|"bufinfo"|fun(): { string: string, hl_string: string, icon: string|nil, icon_hl: string|nil }
---@alias MiddleModules "root-dir"|"git-branch"|"git-status"|fun(): { string: string, hl_string: string, icon: string|nil, icon_hl: string|nil }
---@alias RightModules "diagnostic-info"|"lsp-info"|"cursor-pos"|"scroll-pos"|fun(): { string: string, hl_string: string, icon: string|nil, icon_hl: string|nil }

---@class StatusLineModules
---@field left LeftModules[]
---@field middle MiddleModules[]
---@field right RightModules[]

---@type StatusLineDefaultConfig
M.default_config = {
	use_mini_icons = true,
	modules = {
		left = {
			"mode",
			"modified-status",
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

M.cache = {
	highlights = {},
	statusline_string = "",
	mode_string = "",
	modified_status_string = "",
	bufname_string = "",
	root_dir_string = "",
	git_branch_string = "",
	git_status_string = "",
	diagnostic_info_string = "",
	lsp_info_string = "",
	cursor_pos_string = "",
	scroll_pos_string = "",
}

M.modules_map = {
	["mode"] = M.cache.mode_string,
	["modified-status"] = M.cache.modified_status_string,
	["bufinfo"] = M.cache.bufname_string,
	["root-dir"] = M.cache.root_dir_string,
	["git-branch"] = M.cache.git_branch_string,
	["git-status"] = M.cache.git_status_string,
	["diagnostic-info"] = M.cache.diagnostic_info_string,
	["lsp-info"] = M.cache.lsp_info_string,
	["cursor-pos"] = M.cache.cursor_pos_string,
	["scroll-pos"] = M.cache.scroll_pos_string,
}

return M
