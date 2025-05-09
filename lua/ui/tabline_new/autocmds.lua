local utils = require("ui.tabline.utils")
local states = require("ui.tabline.states")

local tabline_augroup = vim.api.nvim_create_augroup("TablineBuffers", { clear = true })
vim.api.nvim_create_autocmd({ "BufEnter", "BufUnload", "BufDelete", "VimResized" }, {
	callback = function()
		states.buffers_list = utils.get_tabline_buffers_list(vim.api.nvim_list_bufs())
		states.buffers_spec = utils.get_buffers_with_specs(states.buffers_list)
		local bufnr = vim.api.nvim_get_current_buf()
		local bufs = states.buffers_list
		local buf_specs = states.buffers_spec
		utils.fetch_visible_buffers(bufnr, bufs, buf_specs)
		states.buffer_count = states.buffer_count + 1
	end,
	group = tabline_augroup,
})

vim.api.nvim_create_autocmd("BufDelete", {
	callback = function(args)
		local bufnr = args.buf
		states.buffers_list = utils.get_tabline_buffers_list(vim.api.nvim_list_bufs())
		states.buffers_spec = utils.get_buffers_with_specs(states.buffers_list)
		local bufs = states.buffers_list
		local buf_specs = states.buffers_spec
		utils.fetch_visible_buffers(bufnr, bufs, buf_specs)
	end,
	group = tabline_augroup,
})
