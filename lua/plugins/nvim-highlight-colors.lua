local P = {
    'brenoprata10/nvim-highlight-colors',
    cmd = 'HighlightColors',
    config = function ()
        require('nvim-highlight-colors').setup({
            render = 'background',
			virtual_symbol = "",
			virtual_symbol_position = "eow",
			virtual_symbol_prefix = " ",
			virtual_symbol_sufffix = "",
			enable_named_colors = false,
			enable_tailwind = true
        })
    end
}

return P
