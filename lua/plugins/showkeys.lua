local P = {
    'nvzone/showkeys',
    cmd = 'ShowkeysToggle',
    opts = {
        config = {
            -- :h nvim_open_win params
            winopts = {
                focusable = false,
                relative = "editor",
                style = "minimal",
                border = "single",
                height = 1,
                row = 1,
                col = 0,
            },

            timeout = 3, -- in secs
            maxkeys = 4,
            show_count = false,
            excluded_modes = { }, -- example: {"i"}

            -- bottom-left, bottom-right, bottom-center, top-left, top-right, top-center
            position = "top-right",

            keyformat = {
                ["<BS>"] = "󰭜 ",
                ["<CR>"] = "󰘌",
                ["<Space>"] = "󱁐",
                ["<Up>"] = "󰁝",
                ["<Down>"] = "󰁅",
                ["<Left>"] = "󰁍",
                ["<Right>"] = "󰁔",
                ["<PageUp>"] = "Page 󰁝",
                ["<PageDown>"] = "Page 󰁅",
                ["<M>"] = "Alt",
                ["<C>"] = "Ctrl",
            },
        },
    }
}

return P
