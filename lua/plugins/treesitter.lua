local P = {
    "nvim-treesitter/nvim-treesitter",
    version = false,
    event = { "BufReadPost" },
    cmd = { 'TSUpdateSync', 'TSInstall', 'TSDisable', 'TSEnable' },
    build = ":TSUpdate",
    config = function()
        local configs = require("nvim-treesitter.configs")

        configs.setup({
            ensure_installed = { "c", "cpp", "lua", "vim", "python", "vimdoc", "markdown", "regex" },
            modules = {},
            ignore_install = {},
            sync_install = false,
            auto_install = true,
            incremental_selection = {
                enable = true,
                keymaps = {
                    init_selection = '<C-space>',
                    node_incremental = '<C-space>',
                    scope_incremental = false,
                    node_decremental = '<bs>'
                },
            },
            highlight = {
                enable = true,
                -- disable = function( buf)
                --     local max_filesize = 1000 * 1024
                --     local ok, stats = pcall(vim.uv.fs_stat, vim.api.nvim_buf_get_name(buf))
                --     if ok and stats and stats.size > max_filesize then
                --         return true
                --     end
                -- end,
            },
        })
    end,
}

return P
