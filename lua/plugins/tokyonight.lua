local P = {
	"folke/tokyonight.nvim",
	enabled = true,
	-- priority = 1000,
	lazy = true,
}

-- P.opts =
P.config = function(_, opts)
	require("tokyonight").setup({
		style = "moon",
		light_stype = "storm",
		transparent = false,
		undercurl = false,
		terminal_colors = true,
		styles = {
			sidebars = "dark",
			floats = "dark",
		},
		dim_inactive = false,
		cache = true,
		plugins = {
			telescope = true,
		}, -- This is a fucking ugly comment
		---@param colors ColorScheme
		on_colors = function(colors)
			colors.bg_dark = "#181928"
			colors.bg = "#1c1e30"
			colors.bg_dark1 = "#151623"
			colors.bg_float = colors.bg_dark
			colors.bg_highlight = "#2e314e"
			colors.fg = "#b8ceff"
			-- colors.fg_dark = "#cad5ed"
			colors.blue = "#7aa5ff"
			colors.purple = "#fb93e5"
			colors.magenta = "#ba8fff"
			-- colors.bg_light = "#262840"
		end,
		---@param hl tokyonight.Highlights
		---@param c ColorScheme
		on_highlights = function(hl, c)
			local highlight = "#2e314e"
			hl["@module.python"] = {
				fg = c.green1,
				italic = true,
			}
			hl.BlinkCmpScrollBarThumb = {
				bg = c.dark5,
			}
			hl.BlinkCmpScrollBarGutter = {
				bg = c.fg_gutter,
			}
			hl.BlinkCmpDocBorder = {
				fg = c.bg_dark,
				bg = c.bg_dark,
			}
			hl.BlinkCmpDoc = {
				bg = c.bg_float,
			}
			hl.BlinkCmpKindFile = {
				bg = "NONE",
				fg = c.fg,
			}
			hl.BlinkCmpMenuBorder = {
				fg = c.comment,
				bg = c.none
			}
			hl.BlinkCmpMenuSelection = {
				link = "CursorLine"
			}
			-- hl.BlinkCmpMenu = {
			-- 	bg = c.bg_float,
			-- }
			hl.BlinkCmpKindVariable = {
				fg = c.purple,
				bg = "NONE",
			}
			hl.DiagnosticError = {
				fg = c.error,
			}
			hl.DiagnosticUnderlineError = {
				fg = c.error,
				underline = true,
				undercurl = false,
			}
			hl.SnacksPickerPreviewTitle = {
				reverse = true,
				fg = c.blue,
				bg = c.bg_dark,
			}
			hl.SnacksPickerListTitle = {
				reverse = true,
				fg = c.purple,
				bg = c.bg_dark,
			}
			hl.SnacksPickerInputTitle = {
				reverse = true,
				fg = c.orange,
				bg = c.bg_dark,
			}
			hl.SnacksPickerInputBorder = {
				bg = c.blue7,
				fg = c.blue7,
			}
			hl.SnacksPickerListBorder = {
				bg = c.bg_dark,
				fg = c.bg_dark,
			}
			hl.SnacksPickerList = {
				bg = c.bg_dark,
			}
			hl.SnacksPickerPreviewBorder = {
				bg = c.bg_dark,
				fg = c.bg_dark,
			}
			hl.SnacksPickerPreview = {
				bg = c.bg_dark,
			}
			hl.SnacksPickerInput = {
				bg = c.blue7,
				fg = c.fg,
			}
			hl.TelescopePromptTitle = {
				fg = c.orange,
				bg = c.bg_dark,
				reverse = true,
			}
			hl.TelescopePromptBorder = {
				fg = c.blue7,
				bg = c.blue7,
			}
			hl.TelescopePromptNormal = {
				fg = c.fg,
				bg = c.blue7,
			}
			hl.TelescopePromptCounter = {
				bg = c.none,
				fg = c.fg_dark,
			}
			hl.TelescopePreviewTitle = {
				fg = c.blue,
				bg = c.bg_dark,
				reverse = true,
			}
			hl.TelescopePreviewBorder = {
				fg = c.bg_dark,
				bg = c.bg_dark,
			}
			hl.TelescopeResultsBorder = {
				fg = c.bg_dark,
				bg = c.bg_dark,
			}
			hl.TelescopeResultsTitle = {
				fg = c.purple,
				bg = c.bg_dark,
				reverse = true,
			}
			hl.TelescopeSelectionCaret = {
				fg = c.cyan,
				bg = c.bg_highlight,
			}
			hl.TelescopeSelection = {
				bg = c.bg_highlight,
			}
			hl.LspReferencesText = {
				bg = c.bg_highlight,
			}
			hl.LspReferencesRead = {
				bg = c.bg_highlight,
			}
			hl.LspReferencesWrite = {
				bg = c.bg_highlight,
			}
			hl.MatchParen = {
				bold = true,
				fg = c.orange,
				italic = true,
			}
			hl.MarkviewCode = {
				bg = c.bg_float,
			}
			hl.PreProc = {
				fg = c.red,
			}
			hl.SignColumn = {
				bg = c.bg_dark,
			}
			hl.StatusLine = {
				bg = c.bg_dark,
			}
			hl.CursorLineNr = {
				-- bg = c.bg_highlight,
				fg = c.orange,
				bold = true,
				italic = true,
			}
			hl.LineNrAbove = {
				bg = c.bg_dark,
				fg = c.comment,
			}
			hl.LineNrBelow = {
				bg = c.bg_dark,
				fg = c.comment,
			}
			hl.WinBar = {
				bg = c.bg_dark,
			}
			hl.WinBarNC = {
				link = "WinBar",
			}
			hl.WinSeparator = {
				fg = c.fg_gutter,
				bg = c.bg_dark,
			}
			hl.WhichKeyNormal = {
				fg = c.fg,
				bg = c.bg_dark1,
			}
			hl.WhichKeyBorder = {
				fg = c.bg_dark1,
				bg = c.bg_dark1,
			}
			hl.WhichKeyTitle = {
				fg = c.bg_dark,
				bg = c.purple,
			}
			hl.StatusLineNC = {
				link = "StatusLine",
			}
			hl.StatusLineNormalMode = {
				fg = c.blue,
				bold = true,
				bg = c.bg_dark,
				reverse = true,
			}
			hl.StatusLineVisualMode = {
				fg = c.magenta,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineOperatorMode = {
				fg = c.magenta,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineTerminalMode = {
				fg = c.yellow,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineReplaceMode = {
				fg = c.orange,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineSelectMode = {
				fg = c.teal,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineShellMode = {
				fg = c.red,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineCommandMode = {
				fg = c.green1,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineInsertMode = {
				fg = c.blue2,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineMode = {
				fg = c.blue5,
				bold = true,
				reverse = true,
				bg = c.bg_dark,
			}
			hl.StatusLineCwdIcon = {
				bg = c.bg_dark,
				fg = c.blue,
			}
			hl.StatusLineGitBranchIcon = {
				bg = c.bg_dark,
				fg = c.purple,
			}
			hl.StatusLineGitInsertions = {
				fg = c.green,
				bg = c.bg_dark,
			}
			hl.StatusLineGitDeletions = {
				fg = c.red,
				bg = c.bg_dark,
			}
			hl.StatusLineGitUptodate = {
				fg = c.green,
				bg = c.bg_dark,
			}
			hl.StatusLineFilePerc = {
				fg = c.green,
				-- bg = c.bg_highlight
			}
			hl.StatusLineFilePercIcon = {
				fg = c.bg_dark,
				bg = c.green,
			}
			hl.StatusLineCursorPos = {
				fg = c.purple,
				-- bg = c.bg_highlight
			}
			hl.StatusLineCursorIcon = {
				fg = c.bg_dark,
				bg = c.purple,
			}
			hl.StatusLineLspInfo = {
				fg = c.magenta,
				-- bg = c.bg_highlight
			}
			hl.StatusLineLspIcon = {
				fg = c.bg_dark,
				bg = c.magenta,
			}
			hl.StatusLineModified = {
				fg = c.orange,
			}
			hl.StatusLineGitStaged = {
				fg = c.blue2,
			}
			hl.StatusLineGitUntracked = {
				fg = c.orange,
			}
			hl.TabLineFill = {
				bg = c.bg_dark,
				fg = c.fg,
			}
			hl.MiniFilesTitle = {
				fg = c.blue,
				bg = c.bg,
				reverse = true,
			}
			hl.MiniFilesTitleFocused = {
				fg = c.green,
				bg = c.bg,
				reverse = true,
			}
			hl.MiniFilesBorder = {
				fg = c.bg_float,
				bg = c.bg_float,
			}
			hl.MiniFilesBorderModified = {
				fg = c.orange,
				bg = c.bg_float,
			}
			hl.FoldStart = {
				fg = c.magenta,
				bg = c.none,
			}
			hl.FoldEnd = {
				fg = c.yellow,
			}
			hl.Folded = {
				bg = highlight,
			}
			hl.SnacksPickerTotals = {
				fg = c.orange,
				bg = c.none,
			}
			hl.MasonMutedBlock = {
				fg = c.bg,
				bg = c.comment,
			}
			hl.MasonMuted = {
				fg = c.orange,
				bg = c.none,
			}
			hl.MasonHighlightBlockBold = {
				fg = c.bg,
				bg = c.blue,
				bold = true,
			}
			hl.MasonHighlight = {
				fg = c.green1,
				bg = c.none,
			}
			hl.MasonHeader = {
				fg = c.bg,
				bg = c.purple,
			}
			hl.FloatTitle = {
				bg = c.purple,
				fg = c.bg,
			}
			hl.TabLineOverflowIndicator = {
				fg = c.yellow,
				bg = c.bg,
				reverse = true,
			}
			hl.TabLineOverflowCount = {
				fg = c.yellow,
				bg = c.bg_visual,
			}
			hl.TabLineTabPageIcon = {
				fg = c.magenta,
				bg = c.none,
				reverse = true,
			}
			hl.TabLineTabPageActive = {
				fg = c.orange,
				bg = c.bg,
				reverse = true,
			}
			hl["@lsp.typemod.variable.global.lua"] = {
				fg = c.red,
			}
			hl.Number = {
				fg = c.purple,
				bg = c.none,
			}
		end,
	})
	-- require("tokyonight").load()
end

return P
