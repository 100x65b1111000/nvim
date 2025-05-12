local tabline_augroup = vim.api.nvim_create_augroup("TablineBuffers", { clear = true })

vim.api.nvim_create_autocmd({ "BufEnter", "BufUnload", "TextChanged", "InsertEnter", "InsertLeave", "BufWrite", "VimResized" }, {
	group = tabline_augroup,
	callback = function()
		local utils = require("ui.tabline.utils")
		vim.schedule(function()
			utils.update_tabline_buffer_info()
			utils.update_tabline_buffer_string()
			vim.cmd([[redrawtabline]])
		end)
	end,
})
