local M = {}

local default_config = {
	enabled = true,
	statusline = { enabled = true },
	tabline = { enabled = true, hide_misc_buffers = true },
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
		---@diagnostic disable-next-line: missing-fields
		require("ui.statusline").setup({ enabled = false })
		require("ui.tabline").setup({ enabled = false })
	end
end

return M
