local states = require('ui.statusline.states')

vim.api.nvim_create_autocmd({'VimEnter'}, {
	callback = function ()
		require('ui.statusline.autocmds')
		local utils = require('ui.statusline.utils')
		utils.initialize_stl(states.current_config)
	end
})

local M = {}

---@alias StatusLineConfig StatusLineDefaultConfig

---@param opts StatusLineConfig
M.setup = function(opts)
	local config = vim.tbl_deep_extend("force", states.default_config, opts or {})
	states.current_config = config
	vim.o.statusline = [[%!v:lua.require('ui.statusline.utils').set_statusline()]]
end

return M
