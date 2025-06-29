local M = {
	"L3MON4D3/LuaSnip",
	lazy = true,
	version = "v2.*",
	build = "make install_jsregexp",
	opts = function()
		require('snippets')
		local types = require("luasnip.util.types")
		vim.keymap.set({ "i", "s" }, "<Tab>", function()
			if require("luasnip").expandable() then
				require("luasnip").expand({ jump_to_func = true })
			else
				vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
			end
		end)
		return {
			history = true,
			update_events = { "TextChanged", "TextChangedI" },
			enable_autosnippets = true,
			ext_opts = {
				[types.choiceNode] = {
					active = {
						virt_text = { { "<- ", "Error" } },
					},
				},
			},
		}
	end,
}

return M
