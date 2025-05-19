local M = {}

M.setup = function()
	local tabline_augroup = vim.api.nvim_create_augroup("TablineBuffers", { clear = true })

	vim.api.nvim_create_autocmd(
		{ "BufEnter", "BufUnload", "TextChanged", "InsertEnter", "InsertLeave", "BufWrite", "VimResized" },
		{
			group = tabline_augroup,
			callback = function()
				local utils = require("ui.tabline.utils")
				local update_tabline_buffer_info = utils.update_tabline_buffer_info
				local update_tabline_buffer_string = utils.update_tabline_buffer_string
				vim.schedule(function()
					update_tabline_buffer_info()
					update_tabline_buffer_string()
					vim.cmd([[redrawtabline]])
				end)
			end,
		}
	)
	vim.api.nvim_set_option_value("tabline", [[%!v:lua.require('ui.tabline.utils').get_tabline()]], {})
end

return M
