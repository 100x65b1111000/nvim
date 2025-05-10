local M = {}

M.setup = function()
	require("ui.tabline.autocmds")
	vim.o.tabline = [[%!v:lua.require('ui.tabline.utils').update_tabline_buffer_string()]]
end

return M
