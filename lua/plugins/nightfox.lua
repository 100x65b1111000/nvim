local P = {
	"rebelot/kanagawa.nvim",
	priority = 1000,
}

P.config = function()
	---@type KanagawaConfig
	require("kanagawa").setup({
		undercurl = true,
		commentStyle = { italic = true },
		compile = false,
		background = "dark",
		functionStyle = {},
		keywordStyle = { italic = true },
		statementStyle = { bold = true },
		transparent = false,
		dimInactive = true,
		terminalColors = true,
		typeStyle = {},
		theme = "wave",
		---@type KanagawaColors
		colors = {
			---@diagnostic disable-next-line: missing-fields
			theme = {
				all = {
					---@diagnostic disable-next-line: missing-fields
					ui = {
						bg_gutter = "none",
					},
				},
			},
			palette = {
				sumiInk0 = "#16161c",
				sumiInk3 = "#1d1d26"
			},
		},
		---@param colors KanagawaColors Kanagwa colors
		overrides = function(colors)
			local c = colors.palette
			local bg = colors.palette.sumiInk1
			return {
				TabLineFill = {
					bg = c.sumiInk1,
					fg = c.oniViolet2,
				},
				WinBarFill = {
					bg = c.sumiInk2,
					fg = c.oniViolet2,
				},
				CursorLineNr = {
					-- winblend = 50
					bold = true,
					italic = true
				},
				LineNrAbove = {
					bg = c.sumiInk1,
					fg = c.sumiInk6
				},
				LineNrBelow = {
					bg = c.sumiInk1,
					fg = c.sumiInk6
				},
				TabLineTabPageIcon = {
					fg = c.waveAqua1,
					bg = c.sumiInk1,
					reverse = true
				},
				TabLineTabPageActive = {
					fg = c.carpYellow,
					bg = c.sumiInk1,
					reverse = true
				},
				TabLineOverFlowIndicator = {
					fg = c.surimiOrange,
					bg = c.sumiInk1,
					reverse = true
				},
				TabLineOverflowCount = {
					fg = c.surimiOrange,
					bg = c.waveBlue1,
				},
				Pmenu = {
					bg = c.sumiInk1
				},
				PmenuSel = {
					bg = c.dragonBlue,
					fg = c.sumiInk2,
				},
				PmenuSbar = {
					bg = c.sumiInk5
				},
				PmenuThumb = {
					bg = c.katanaGray
				}
			}
		end,
	})
	require("kanagawa").load("wave")
end
return P
