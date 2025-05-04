local P = {
    "folke/lazydev.nvim",
	enabled = true,
    ft = "lua",
	-- enabled = false,
    opts = {
        library = {
            "lazy.nvim",
			"snacks.nvim",
            { path = '${3rd}/luv/library', words = {'vim%.uv' }},
        },
        -- disable when a .luarc.json file is found
        enabled = function(root_dir)
            return not vim.uv.fs_stat(root_dir .. "/.luarc.json")
        end,
    }
}

return P
