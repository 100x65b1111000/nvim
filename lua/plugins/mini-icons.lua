local P = {
	"echasnovski/mini.icons",
    lazy = false,
	opts = function()
		require("mini.icons").mock_nvim_web_devicons()
		return {
			lsp = {
				["function"] = { glyph = "󰡱" },
				null = { glyph = "󰟢" },
				keyword = { glyph = "" },
				number = { glyph = "" },
                copilot = { glyph = 'cp' }
			},
			directory = { glyph = "" },
		}
	end,
}

return P
