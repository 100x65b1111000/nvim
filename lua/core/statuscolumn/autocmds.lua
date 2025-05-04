local augroup = vim.api.nvim_create_augroup("StatusColumnInit", { clear = true })
vim.api.nvim_create_autocmd({ 'WinEnter', 'WinLeave', 'WinClosed', 'WinNew', 'WinResized' }, {
	group = augroup,
	callback = function ()
		require('core.statuscolumn').render_statuscolumn()
	end
})
