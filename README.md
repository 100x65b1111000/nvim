# NEOVIM CONFIG
This is my personal Neovim config that I have developed throughout my journey of daily driving neovim. It may or may not suit your needs but if it does, I'm happy to hear that.

> [!Note]
> This config is currently experimental but functional. As changes are made on the fly, the code is currently a bit messy (I'm doing my best to clean it up). I try to fix any issues I encounter as soon as possible.
> If you encounter any problems or bugs, please raise an issue, and I'll try to fix them as soon as possible. PRs are more than welcome!

# SHOWCASE
![image](https://github.com/user-attachments/assets/a3905980-96c2-48b0-b1ff-f425ee9b1022)
![image](https://github.com/user-attachments/assets/bf625347-6098-4033-8cac-7bd0c71a9aeb)
![image](https://github.com/user-attachments/assets/843ac2c7-1375-4c87-9197-f35bb2f543f2)
![image](https://github.com/user-attachments/assets/e39b5f40-885e-4259-8644-ba217f3b6f93)
![image](https://github.com/user-attachments/assets/70ce54dc-72dc-4e0b-956f-285e6729257e)
![image](https://github.com/user-attachments/assets/31c683c3-74c1-4a03-9245-8fac62587c19)
![image](https://github.com/user-attachments/assets/59c74c96-f067-4ee1-98b8-d0250183eb7b)
![image](https://github.com/user-attachments/assets/258eadf4-8ce0-4337-805f-20084439f0ed)


# Install Instructions

To get the setup up and running.
Firstly backup your current neovim setup:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

Now, simply clone the repository into your `$XDG_CONFIG_HOME/nvim` directory.

```bash
git clone https://gitlab.com/100x65b1111000/nvim.git ~/.config/nvim
nvim
```

# Highlights
- Manually created statusline (~500 LOC), statuscolumn (~150 LOC), and tabline (~500 LOC) with minimalism and aesthetics in mind. However, they are not highly configurable.
![image](https://github.com/user-attachments/assets/a8522a29-dc3e-41af-b23b-c8268ca81a3f)
![image](https://github.com/user-attachments/assets/e0f57119-ba19-4d1b-a8ba-e15b1e8d8f95)
- Reasonable defaults.
- [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.
- Customized dashboard with [dashboard.nvim](https://github.com/nvimdev/dashboard.nvim).
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) theme with tweaked colors for better visibility.
- [which-key](https://github.com/folke/which-key.nvim) to display available key bindings.
- [blink.cmp](https://github.com/Saghen/blink.cmp) for completions.
- [snacks.nvim](https://github.com/folke/snacks.nvim) for tasty snacks.
- [mini.files](https://github.com/echasnovski/mini.files) as the file explorer.
- lsp setup via `vim.lsp.config`.

There are many more plugins included by default, such as:
- [git-signs.nvim](https://github.com/lewis6991/gitsigns.nvim)
- [mini.pairs](https://github.com/echasnovski/mini.nvim)
- [helpview.nvim](https://github.com/OXY2DEV/helpview.nvim)
- [markview.nvim](https://github.com/OXY2DEV/markview.nvim)
- [showkeys.nvim](https://github.com/nvzone/showkeys)
- [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim)
- [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter)
- [vim-startuptime](https://github.com/dstein64/vim-startuptime)
- [lazydev](https://github.com/folke/lazydev.nvim)
- [conform.nvim](https://github.com/stevearc/conform.nvim)
- [highlight-colors.nvim](https://github.com/brenoprata10/nvim-highlight-colors)

# You can also use the statusline/tabline/statuscolumn in your own config too !!
Doing so is fairly easy, just grab the `ui` folder and place it inside your config, and call the setup functions for any of the statusline/tabline/statuscolumn inside your config and that's just it.


> [!Note]
> The statusline and tabline require the `mini.icons` plugin to generate some highlight groups and display file icons.
> There are also some highlight groups you must define first, or else the colors will look off. You can find these highlight groups in the `lua/plugins/tokyonight.lua` spec file (search for `/StatusLine` and `/TabLine` and define the highlight groups).

### Adding Custom Modules to the Statusline

You can extend the statusline with your own custom modules. The process involves defining a Lua function that returns information about what to display, and then adding this function to your statusline configuration.

**1. Define Your Module Function**

A custom module is a Lua function that returns a table with specific keys. The main keys are:

*   `string`: (Required) The text content you want the module to display.
*   `hl_group`: (Optional) The highlight group to apply to the `string`. If omitted, it will likely use a default statusline highlight.
*   `icon`: (Optional) An icon to display for the module.
*   `icon_hl`: (Optional) The highlight group for the `icon`.
*   `reverse`: (Optional) A boolean. If `true`, the `string` and `hl_group` are displayed first, then the `icon` and `icon_hl`. Defaults to `false` (icon first).

Here's an example of a simple custom module that displays the current date:

```lua
local function my_date_module()
  local date_str = os.date("%Y-%m-%d")
  return {
    string = date_str,
    hl_group = "Comment", -- Example highlight group
    icon = " ",          -- Example icon (requires a Nerd Font)
    icon_hl = "Special"    -- Example highlight group for the icon
  }
end
```

**2. Add Your Module to the Statusline Configuration**

When you set up the statusline using `require('ui.statusline').setup(opts)`, you can pass your custom module function in the `opts.modules` table. You can add it to the `left`, `middle`, or `right` sections of the statusline.

For example, to add `my_date_module` to the left section of the statusline:

```lua
-- Define your custom module function 
local function my_date_module()
  local date_str = os.date("%Y-%m-%d")
  return {
    string = date_str,
    hl_group = "Comment",
    icon = " ",
    icon_hl = "Special"
  }
end
```

**3. Now just add this function inside your statusline setup like this**

```lua
-- Assuming the ui directly exists inside ~/.config/nvim/lua/
require('ui.statusline').setup({ modules = { left = { "mode", "buf-status", "buf-info", my_date_module }, middle = { ... }, right = { ... }}})

```

**Here's what the above code results in**
![image](https://github.com/user-attachments/assets/ad092c90-7016-44b5-8aff-741ca2d32dd9)


# Things not done yet, but are planned
- [ ] Better error handling for statusline/tabline/statuscolumn.
- [ ] luasnip snippets (right now it just serves the purpose of completing lsp snippets via `blink.cmp`).
- [ ] Add more keybindings.
- [ ] LSP configuration for more LSP servers.
