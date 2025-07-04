local M = {}

M.setup = function()
	require("ui.tabline.autocmds")
	vim.api.nvim_set_option_value("tabline", [[%!v:lua.require('ui.tabline.utils').get_tabline()]], {})
end

return M
