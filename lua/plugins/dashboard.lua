local P = {
	"nvimdev/dashboard-nvim",
	dependencies = {
		"echasnovski/mini.icons",
	},
	-- event = "VimEnter",
}

P.init = function()
	local dashboard_headers = require("config.utils").dashboard_headers
	local dashboard_footers = require("config.utils").dashboard_footers
	local g = vim.g
	math.randomseed(os.time())
	g.dashboard_custom_header = dashboard_headers.neovim_4
	local dashboard_footer_art = dashboard_footers.cat2
	local dashboard_footer_text = " " .. dashboard_footers.lyrics[math.random(#dashboard_footers.lyrics)] .. "  "
	table.insert(dashboard_footer_art, 1, dashboard_footer_text)
	table.insert(dashboard_footer_art, 2, "")
	table.insert(dashboard_footer_art, 1, "")
	g.dashboard_custom_footer = dashboard_footer_art
end

P.config = function()
	require("dashboard").setup({
		theme = "hyper",
		disable_move = true,
		shortcut_type = "letter",
		shuffle_letter = false,
		change_to_vcs_root = false,
		config = {
			header = vim.g.dashboard_custom_header,
			week_header = {
				enable = false,
			},
			packages = { enable = true },
			shortcut = {
				{ desc = " Updates", group = "@boolean", key = "u", action = "Lazy update" },
				{
					desc = "󰥨 Find",
					group = "@comment.hint",
					key = "f",
					action = function()
						Snacks.picker.files({ cwd = "~/" })
					end,
				},
				{
					desc = " Dotfiles",
					group = "@function",
					key = "d",
					action = function()
						Snacks.picker.files({ cwd = "~/.config" })
					end,
				},
				{
					desc = " Config",
					group = "@attribute.builtin",
					key = "c",
					action = function(path)
						Snacks.picker.files({ cwd = path })
					end,
				},
				{ desc = " Recents", group = "@constructor", key = "r", action = "lua Snacks.picker.recent()" },
			},
			project = {
				action = function(path)
					---@class snacks.picker.files.Config
					Snacks.picker.files({ cwd = path })
				end,
				enable = true,
				limit = 5,
				icon = " ",
				label = "Recent Projects",
			},
			mru = { enable = true, icon = " ", limit = 8, label = "Recently edited", cwd_only = false },
			footer = vim.g.dashboard_custom_footer,
		},
		hide = {
			statusline = true,
			tabline = true,
			winbar = true,
		},
		preview = {},
	})
end

return P
