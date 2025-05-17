local M = {}

M.setup = function()
	local tabline_augroup = vim.api.nvim_create_augroup("TablineBuffers", { clear = true })

	vim.api.nvim_create_autocmd(
		{ "BufEnter", "BufUnload", "TextChanged", "InsertEnter", "InsertLeave", "BufWrite", "VimResized" },
		{
			group = tabline_augroup,
			callback = function(args)
				local utils = require("ui.tabline.utils")
				-- if not utils.buf_is_valid(args.buf) then
				-- 	return
				-- end
				vim.schedule(function()
					utils.update_tabline_buffer_info()
					utils.update_tabline_buffer_string()
					vim.cmd([[redrawtabline]])
				end)
			end,
		}
	)
	vim.api.nvim_set_option_value("tabline", [[%!v:lua.require('ui.tabline.utils').get_tabline()]], {})
end

return M
