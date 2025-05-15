---@diagnostic disable: missing-fields
local P = {
	"folke/snacks.nvim",
	enabled = true,
	priority = 999,
	lazy = false,
}

---@type snacks.Config
P.opts = {
	-- your configuration comes here
	-- or leave it empty to use the default settings
	-- refer to the configuration section below
	bigfile = { enabled = true },
	image = { enabled = true },
	dashboard = { enabled = false },
	explorer = { enabled = false },
	---@type snacks.indent.Config
	indent = { enabled = false },
	input = { enabled = true },
	picker = {
		prompt = " ",
		layout = {
			layout = {
				box = "horizontal",
				backdrop = false,
				width = 0.8,
				height = 0.9,
				border = "none",
				{
					box = "vertical",
					{
						win = "input",
						height = 1,
						border = "rounded",
						title = "{title} {live} {flags}",
						title_pos = "center",
					},
					{
						win = "list",
						title = " Results ",
						wo = {
						},
						title_pos = "center",
						border = "rounded",
						resize = true,
						text = function ()
							return "djfls"
						end,
						keys = {
							["<M-j>"] = function (self)
								self.action(self, "list_down")
							end,
						},
					},
				},
				{
					win = "preview",
					title = "{preview:Preview}",
					width = 0.5,
					border = "rounded",
					title_pos = "center",
				},
			},
		},
	},
	notifier = { enabled = true },
	quickfile = { enabled = true },
	---@type snacks.scope.Config
	scope = {
		enabled = false,
		cursor = true,
		edge = false,
		min_size = 2,
		siblings = true,
		max_size = 0,
	},
	scroll = { enabled = false },
	---@type snacks.statuscolumn.Config
	statuscolumn = {
		enabled = true,
		left = { "sign", "mark" },
		right = { "fold", "git" },
		folds = {
			open = true, -- show open fold icons
			git_hl = true, -- use Git Signs hl for fold icons
		},
		git = {
			-- patterns to match Git signs
			patterns = { "GitSign" },
		},
		refresh = 100, -- refresh at most every 50ms
	},
	words = { enabled = false },
}

P.keys = {
	{
		"<leader>sgb",
		function()
			Snacks.git.blame_line()
		end,
		desc = "Open git blame for current line",
	},
	{
		"<leader>sgB",
		function()
			Snacks.gitbrowse()
		end,
		desc = "Git browse active file",
	},
	{
		"<leader>sgl",
		function()
			Snacks.lazygit.open()
		end,
		desc = "Open lazygit",
	},
	{
		"<leader>th",
		function()
			Snacks.terminal()
		end,
		desc = "Toggle Terminal(vsplit)",
	},
	{
		"<leader>fg",
		function()
			Snacks.picker.grep({
				hidden = true,
				supports_live = true,
				show_empty = false,
			})
		end,
		desc = "Live Grep",
	},
	{
		"<leader>ff",
		function()
			Snacks.picker.files({
				hidden = true,
			})
		end,
		desc = "Find Files",
	},
	{
		"<leader>fb",
		function()
			Snacks.picker.buffers()
		end,
		desc = "Find Buffers",
	},
	{
		"<leader>fli",
		function()
			Snacks.picker.lsp_implementations()
		end,
		desc = "Find LSP Implementations",
	},
	{
		"<leader>fls",
		function()
			Snacks.picker.lsp_symbols()
		end,
		desc = "Find LSP Symbols",
	},
	{
		"<leader>fd",
		function()
			Snacks.picker.diagnostics_buffer()
		end,
		desc = "Diagnostics picker(buffer)",
	},
	{
		"<leader>fh",
		function()
			Snacks.picker.help()
		end,
		desc = "Find Help Pages",
	},
	{
		"<leader>fc",
		function()
			Snacks.picker.colorschemes()
		end,
		desc = "Pick Colorschemes",
	},
	{
		"<leader>fH",
		function()
			Snacks.picker.highlights()
		end,
		desc = "Find hl_groups",
	},
}

return P
