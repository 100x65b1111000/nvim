local P = {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
        -- 'nvim-telescope/telescope-fzf-native.nvim',
    },
	enabled = true,
    config = function()
		local dropbar_api = require('dropbar.api')
        require('dropbar').setup({})
		vim.keymap.set('n', '<leader>;', dropbar_api.pick, { desc = "Pick symbols from Winbar"})
        -- vim.ui.select = require('dropbar.utils.menu').select 
    end
}

return P
