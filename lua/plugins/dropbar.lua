local P = {
    'Bekaboo/dropbar.nvim',
    event = { 'BufReadPost', 'BufNewFile' },
    dependencies = {
        -- 'nvim-telescope/telescope-fzf-native.nvim',
    },
	enabled = true,
    config = function()
        require('dropbar').setup({})
        -- vim.ui.select = require('dropbar.utils.menu').select 
    end
}

return P
