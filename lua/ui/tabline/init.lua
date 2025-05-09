-- init.lua
local M = {}

M.setup = function()
	vim.api.nvim_create_autocmd({ "VimEnter" }, {
		callback = function()
			require('ui.tabline.autocmds')
			vim.o.tabline = [[%!v:lua.require('ui.tabline.utils').update_tabline_buffer_string()]]
		end,
	})
end

return M
