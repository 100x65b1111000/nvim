local M = {}

---@alias StatusLineConfig StatusLineDefaultConfig

---@param opts StatusLineConfig
M.setup = function(opts)
	vim.api.nvim_create_autocmd({ "VimEnter" }, {
		callback = function()
			require("ui.statusline.autocmds")
			local utils = require("ui.statusline.utils")
			utils.initialize_stl(opts)
			vim.o.statusline = [[%!v:lua.require('ui.statusline.utils').set_statusline()]]
		end,
	})
end

return M
