local tabline_augroup = vim.api.nvim_create_augroup("TablineBuffers", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufUnload", "BufDelete" }, {
	callback = function()
		local utils = require("ui.tabline.utils")
		vim.schedule(function()
			utils.update_tabline_buffer_info()
			vim.cmd([[redrawtabline]])
		end)
	end,
	group = tabline_augroup,
})

vim.api.nvim_create_autocmd({ "VimResized" }, {
	-- group = tabline_augroup,
	callback = function()
		local utils = require("ui.tabline.utils")
		utils.update_tabline_buffer_info()
		vim.cmd([[redrawtabline]])
	end,
})

vim.api.nvim_create_autocmd({ "BufEnter", "BufUnload", "TextChanged", "InsertEnter", "InsertLeave", "BufWrite" }, {
	callback = function()
		local utils = require("ui.tabline.utils")
		vim.schedule(function()
			utils.update_tabline_buffer_string()
			vim.cmd([[redrawtabline]])
		end)
	end,
})
