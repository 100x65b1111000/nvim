local P = {
	"rebelot/kanagawa.nvim",
	-- lazy = true
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
		dimInactive = false,
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
				sumiInk3 = "#1d1d26",
				sumiInk5 = "#30303f",
			},
		},
		---@param colors KanagawaColors Kanagwa colors
		overrides = function(colors)
			local c = colors.palette
			return {
				TabLineFill = {
					bg = c.sumiInk1,
					fg = c.fujiWhite,
				},
				WinBarFill = {
					bg = c.sumiInk2,
					fg = c.oniViolet2,
				},
				WinSeparator = {
					bg = c.sumiInk3,
					fg = c.sumiInk6
				},
				WinBar = {
					bg = c.sumiInk1
				},
				CursorLineNr = {
					-- winblend = 50
					bold = true,
					italic = true,
				},
				LineNrAbove = {
					bg = c.sumiInk1,
					fg = c.sumiInk6,
				},
				LineNrBelow = {
					bg = c.sumiInk1,
					fg = c.sumiInk6,
				},
				TabLineTabPageIcon = {
					fg = c.waveAqua1,
					bg = c.sumiInk1,
					reverse = true,
				},
				TabLineTabPageActive = {
					fg = c.roninYellow,
					bg = c.sumiInk1,
					reverse = true,
				},
				TabLineOverFlowIndicator = {
					fg = c.surimiOrange,
					bg = c.sumiInk1,
					reverse = true,
				},
				TabLineOverflowCount = {
					fg = c.surimiOrange,
					bg = c.waveBlue1,
				},
				Pmenu = {
					bg = "none",
				},
				PmenuSel = {
					bg = c.dragonBlue,
					fg = c.sumiInk2,
				},
				PmenuSbar = {
					bg = c.sumiInk5,
				},
				PmenuThumb = {
					bg = c.katanaGray,
				},
				StatusLine = {
					bg = c.sumiInk1,
					fg = c.fujiWhite
				},
				StatusLineNormalMode = {
					fg = c.crystalBlue,
					bold = true,
					bg = c.sumiInk0,
					reverse = true,
				},
				StatusLineVisualMode = {
					fg = c.oniViolet,
					bold = true,
					reverse = true,
					bg = c.sumiInk0,
				},
				StatusLineOperatorMode = {
					fg = c.oniViolet2,
					bold = true,
					reverse = true,
					bg = c.sumiInk0,
				},
				StatusLineTerminalMode = {
					fg = c.autumnYellow,
					bold = true,
					reverse = true,
					bg = c.sumiInk0,
				},
				StatusLineReplaceMode = {
					fg = c.surimiOrange,
					bold = true,
					reverse = true,
					bg = c.sumiInk0,
				},
				StatusLineSelectMode = {
					fg = c.sakuraPink,
					bold = true,
					reverse = true,
					bg = c.sumiInk0,
				},
				StatusLineShellMode = {
					fg = c.waveRed,
					bold = true,
					reverse = true,
					bg = c.sumiInk0,
				},
				StatusLineCommandMode = {
					fg = c.roninYellow,
					bold = true,
					reverse = true,
					bg = c.sumiInk0,
				},
				StatusLineInsertMode = {
					fg = c.springBlue,
					bold = true,
					reverse = true,
					bg = c.sumiInk0,
				},
				StatusLineMode = {
					link = "StatusLineNormalMode"
				},
				StatusLineCwdIcon = {
					bg = c.sumiInk0,
					fg = c.springBlue,
				},
				StatusLineGitBranchIcon = {
					bg = c.sumiInk0,
					fg = c.sakuraPink,
				},
				StatusLineGitInsertions = {
					fg = c.springGreen,
					bg = c.sumiInk0,
				},
				StatusLineGitDeletions = {
					fg = c.waveRed,
					bg = c.sumiInk0,
				},
				StatusLineGitUptodate = {
					fg = c.springGreen,
					bg = c.sumiInk0,
				},
				StatusLineFilePerc = {
					fg = c.autumnGreen,
					-- bg = c.bg_highlight
				},
				StatusLineFilePercIcon = {
					fg = c.sumiInk0,
					bg = c.autumnGreen
				},
				StatusLineCursorPos = {
					fg = c.sakuraPink,
					-- bg = c.bg_highlight
				},
				StatusLineCursorIcon = {
					fg = c.sumiInk0,
					bg = c.sakuraPink,
				},
				StatusLineLspInfo = {
					fg = c.oniViolet,
					-- bg = c.bg_highlight
				},
				StatusLineLspIcon = {
					fg = c.sumiInk0,
					bg = c.oniViolet,
				},
				StatusLineModified = {
					fg = c.surimiOrange,
				},
				StatusLineGitStaged = {
					fg = c.crystalBlue,
				},
				StatusLineGitUntracked = {
					fg = c.surimiOrange,
				},
				MiniFilesTitle = {
					fg = c.springViolet1,
					bg = c.sumiInk0,
					reverse = true,
				},
				MiniFilesTitleFocused = {
					fg = c.springGreen,
					bg = c.sumiInk0,
					reverse = true,
				},
				MiniFilesBorder = {
					fg = c.sumiInk0,
					bg = c.sumiInk0,
				},
				MiniFilesBorderModified = {
					fg = c.surimiOrange,
					bg = c.sumiInk1,
				},
				FoldStart = {
					fg = c.oniViolet,
					bg = "none",
				},
				FoldEnd = {
					fg = c.boatYellow1,
				},
				Folded = {
					bg = c.sumiInk5,
				},
				SnacksPickerTotals = {
					fg = c.surimiOrange,
					bg = "none",
				},
				MasonMutedBlock = {
					fg = c.sumiInk0,
					bg = c.katanaGray,
				},
				MasonMuted = {
					fg = c.surimiOrange,
					bg = "none",
				},
				MasonHighlightBlockBold = {
					fg = c.sumiInk0,
					bg = c.springBlue,
					bold = true,
				},
				MasonHighlight = {
					fg = c.autumnGreen,
					bg = "none",
				},
				MasonHeader = {
					fg = c.sumiInk0,
					bg = c.sakuraPink,
				},
				DashboardMRUIcon = {
					fg = c.roninYellow
				},
				DashboardMRUTitle = {
					fg = c.oniViolet2
				},
				DashboardProjectTitle = {
					fg = c.oniViolet2
				},
				DashboardProjectTitleIcon = {
					fg = c.surimiOrange
				},
				DashboardProjectIcon = {
					fg = c.surimiOrange
				},
				DashboardHeader = {
					fg = c.crystalBlue
				},
				DashboardFooter = {
					fg = c.springBlue
				},
				SnacksPickerInputTitle = {
					fg = c.sakuraPink,
					bg = c.sumiInk0,
					reverse = true
				},
				SnacksPickerPreview = {
					bg = c.sumiInk0,
				},
				SnacksPickerPreviewTitle = {
					fg = c.springGreen,
					bg = c.sumiInk0,
					reverse = true
				},
				SnacksPickerPreviewBorder = {
					bg = c.sumiInk0,
					fg = c.sumiInk0
				},
				SnacksPickerInput = {
					bg = c.sumiInk4,
					fg = c.oniViolet2
				},
				SnacksPickerInputBorder = {
					bg = c.sumiInk4,
					-- fg = c.oniViolet2
				},
				SnacksPickerList = {
					bg = c.sumiInk0,
				},
				SnacksPickerListTitle = {
					bg = c.sumiInk0,
					fg = c.springViolet1,
					reverse = true
				},
				SnacksPickerListBorder = {
					bg = c.sumiInk0,
					fg = c.sumiInk0,
				},
				SnacksPickerListCursorLine = {
					bg = c.sumiInk5,
				},
				WhichKeyNormal = {
					bg = c.sumiInk0
				},
				WhichKeyBorder = {
					bg = c.sumiInk0,
					fg = c.sumiInk0
				},
				WhichKeyTitle = {
					fg = c.sakuraPink,
					bg = c.sumiInk0,
					reverse = true
				},
				BlinkCmpMenuBorder = {
					bg = "none",
					fg = c.sumiInk6
				},
				["@markup.link.label.markdown_inline"] = {
					underline = false,
					bold = true,
					fg = c.sakuraPink
				}
			}
		end,
	})
	require("kanagawa").load("wave")
end
return P
