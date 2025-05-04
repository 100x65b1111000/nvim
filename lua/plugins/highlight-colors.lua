local P = {
    'brenoprata10/nvim-highlight-colors',
    cmd = 'HighlightColors',
    config = function ()
        require('nvim-highlight-colors').setup({
            render = 'background'
        })
    end
}

return P
