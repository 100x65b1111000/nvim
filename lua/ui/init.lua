local M = {}

local default_config = {
	enabled = true,
	statusline = { enabled = true },
	tabline = { enabled = true },
	statuscolumn = { enabled = true },
}

M.setup = function(opts)
	opts = vim.tbl_deep_extend("force", default_config, opts or {})
	if opts.enabled then
		require("ui.statusline").setup(opts.statusline)
		require("ui.statuscolumn").setup(opts.statuscolumn)
		require("ui.tabline").setup(opts.tabline)
	else
		require("ui.statuscolumn").setup({ enabled = false })
		require("ui.statusline").setup({ enabled = false })
		require("ui.tabline").setup({ enabled = false })
	end
end

return M
