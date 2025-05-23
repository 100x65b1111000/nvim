local tabline_augroup_buffers = vim.api.nvim_create_augroup("TabLineBuffers", { clear = true })

vim.api.nvim_create_autocmd(
	{ "BufEnter", "BufUnload", "TextChanged", "InsertEnter", "InsertLeave", "BufWrite", "VimResized" },
	{
		group = tabline_augroup_buffers,
		callback = function()
			local utils = require("ui.tabline.utils")
			local update_tabline_buffer_string = utils.update_tabline_buffer_string
			local update_tabline_buffer_info = utils.update_tabline_buffer_info
			vim.schedule(function()
				update_tabline_buffer_info()
				update_tabline_buffer_string()
				vim.cmd([[redrawtabline]])
			end)
		end,
	}
)

local tabline_augroup_tabpages = vim.api.nvim_create_augroup("TabLineTabPages", { clear = true })
vim.api.nvim_create_autocmd(
	{ "UIEnter", "TabEnter", "TabClosed", "TabNew" },
	{
		group = tabline_augroup_tabpages,
		callback = function ()
			local utils = require('ui.tabline.utils')
			local update_tabline_buffer_string = utils.update_tabline_buffer_string
			local update_tabline_buffer_info = utils.update_tabline_buffer_info
			local tabline_update_tabpages_info = utils.tabline_update_tabpages_info

			vim.schedule(function()
				tabline_update_tabpages_info()
				update_tabline_buffer_info()
				update_tabline_buffer_string()
				vim.cmd[[redrawtabline]]
			end)
		end
	}
)
