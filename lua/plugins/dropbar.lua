local P = {
	"Bekaboo/dropbar.nvim",
	event = { 'BufNewFile', OptionSet = { 'modified' } },
	dependencies = {
		-- 'nvim-telescope/telescope-fzf-native.nvim',
	},
	config = function()
		local dropbar_api = require("dropbar.api")
		require("dropbar").setup({
			-- bar = {
			-- 	update_events = {
			-- 		buf = { "FileChangedShellPost", "TextChanged", "ModeChanged" },
			-- 	},
			-- },
		})
		vim.keymap.set("n", "<leader>;", dropbar_api.pick, { desc = "Pick symbols from Winbar" })
		-- vim.ui.select = require('dropbar.utils.menu').select
	end,
}

return P
