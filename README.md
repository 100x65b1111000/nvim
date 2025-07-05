# NEOVIM CONFIG
This is my personal Neovim config that I have developed throughout my journey of daily driving neovim. It may or may not suit your needs but if it does, I'm happy to hear that.

> [!Note]
> This config is currently experimental but functional. As changes are made on the fly, the code is a mess rn (I'm doing my best to clean it up). I try to fix any issues I encounter as soon as possible.
> If you encounter any problems or bugs, please raise an issue, I'll try to fix them as soon as possible. PRs are more than welcome!

# SHOWCASE
## StartupTime: ~17ms 
![for all the startuptime freaks](https://github.com/user-attachments/assets/8178dcfe-1177-42b6-8cb0-91ab920addc7)
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
- Custom statusline (\~500 LOC, \~0.25ms), statuscolumn (\~150 LOC, \~0.03ms), and tabline (\~500 LOC, \~0.20ms) with minimalism and aesthetics in mind. However, not much configurable.
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

> [!NOTE]
> There's a bug in `snacks.picker`, which causes the picker to crash when resizing the neovim window with the specific layout config used in the dotfiles. Unfortunately this won't get fixed in the main any time soon. So, for now you can use my fork of `snacks.nvim`

Other plugins included, are:
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

# You can use the statusline/tabline/statuscolumn in your own config too !!
Doing so is fairly easy, just grab the `ui` folder and place it inside your config, and call the setup functions for any of the statusline/tabline/statuscolumn inside your config and that's just it.


> [!Note]
> The statusline and tabline require the `mini.icons` plugin to generate some highlight groups and display file icons.
> There are also some highlight groups you must define first, or else the colors will look off if you are using any other colorscheme. You can find these highlight groups in the `lua/plugins/tokyonight.lua` spec file (search for `/StatusLine` and `/TabLine` and define the highlight groups).

### Adding Custom Modules to the Statusline

You can extend the statusline with your own custom modules(although its just bare bones). The process involves defining a Lua function that returns information about what to display, and then adding this function to your statusline configuration.

**1. Define Your Module Function**

A custom module is a Lua function that returns a table with specific keys. The main keys are:

*   `string`: (Required) The text content you want the module to display.
*   `hl_group`: (Optional) The highlight group to apply to the `string`. If omitted, it will likely use the default highlight group.
*   `icon`: (Optional) An icon to display in the module.
*   `icon_hl`: (Optional) The highlight group for the `icon`.
*   `reverse`: (Optional) A boolean. If `true`, the `string` is displayed first, then the `icon`. Defaults to `false` (icon first).
*   `show_right_sep`: (Optional) A boolean that defines whether to show the right seperator for the module or not. (Does not show the separator by default).
*   `show_left_sep`: (Optional) Same as `show_right_sep` but for the left separator (useful for modules at right).
*   `right_sep_hl`: (Optional) Highlight group for right separator.
*   `left_sep_hl`: (Optional) Same as `right_sep_hl`, but for the left seperator.

Here's an example of a simple custom module that displays the current date:

```lua
local function my_date_module()
  local date_str = os.date("%Y-%m-%d")
  return {
    string = date_str,
    hl_group = "Comment", -- Example highlight group (optional, would use the `StatusLineNormal` group if not specified)
    icon = " ",          -- Example icon (requires a Nerd Font) (optional)
    icon_hl = "Special"    -- Example highlight group for the icon (optional)
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

**Here's what the above setup results in**
![image](https://github.com/user-attachments/assets/1c17926f-c2d8-430c-9197-72e3da7fcbab)
> Notice that the middle and right modules are blank, once you define the left/middle/right modules, they would be overidden! and default to empty if empty table is passed to them.

# Keybindings

This section outlines the keybindings configured in this Neovim setup.

**Core Keybindings**

**Normal Mode**
| Key         | Description                     |
|-------------|---------------------------------|
| `<leader>a` | Select all                      |
| `<leader>ay`| Select all and copy             |
| `<Esc>`     | Clear search highlight          |
| `<Tab>`     | Switch to the next tab          |
| `<S-Tab>`   | Switch to the previous tab      |
| `<leader>bh`| Previous buffer                 |
| `<leader>bl`| Next buffer                     |
| `<leader>bd`| Delete buffer                   |
| `<leader>bb`| Switch with previous buffer     |
| `<leader>bp`| List buffers                    |
| `<leader>wh`| Focus window (left)             |
| `<leader>wj`| Focus window (right)            |
| `<leader>wk`| Focus window (up)               |
| `<leader>wl`| Focus window (down)             |
| `<leader>wo`| Close all other windows         |
| `<leader>ws`| Split window(horizontally)      |
| `<leader>wv`| Split window(vertically)        |
| `<leader>wq`| Quit window                     |
| `<leader>wT`| Break out to a new tab          |
| `<leader>ww`| Switch windows                  |
| `<leader>wx`| Swap window with next           |
| `<leader>w+`| Increase height                 |
| `<leader>w-`| Decrease height                 |
| `<leader>w_`| Max height                      |
| `<leader>w>`| Increase width                  |
| `<leader>w<`| Decrease width                  |
| `<leader>w|`| Max width                       |
| `<leader>w=`| Equal height and width          |
| `<leader>hv`| Open help (vertical split)      |
| `<leader>hh`| Open help (horizontal split)    |
| `<c-s-R>`   | Restart Neovim                  |
| `<c-j>`     | Move current line down          |
| `<c-k>`     | Move current line up            |

**Visual Mode**
| Key         | Description                          |
|-------------|--------------------------------------|
| `<leader>bd`| Delete buffer                        |
| `<leader>bb`| Switch with previous buffer          |
| `<leader>bp`| List buffers                         |
| `<leader>wh`| Focus window (left)                  |
| `<leader>wj`| Focus window (right)                 |
| `<leader>wk`| Focus window (up)                    |
| `<leader>wl`| Focus window (down)                  |
| `<leader>wo`| Close all other windows              |
| `<leader>ws`| Split window(horizontally)           |
| `<leader>wv`| Split window(vertically)             |
| `<leader>wq`| Quit window                          |
| `<leader>wT`| Break out to a new tab               |
| `<leader>ww`| Switch windows                       |
| `<leader>wx`| Swap window with next                |
| `<leader>w+`| Increase height                      |
| `<leader>w-`| Decrease height                      |
| `<leader>w_`| Max height                           |
| `<leader>w>`| Increase width                       |
| `<leader>w<`| Decrease width                       |
| `<leader>w|`| Max width                            |
| `<leader>w=`| Equal height and width               |
| `<c-j>`     | Move selected lines down             |
| `<c-k>`     | Move selected lines up               |
| `/`         | Search forward within visual selection |
| `?`         | Search backward within visual selection|

**Insert Mode**
| Key     | Description             |
|---------|-------------------------|
| `<c-k>` | Move current line up    |
| `<c-j>` | Move current line down  |
| `<c-d>` | Delete previous word    |

**Plugin: `mini.files` Keybindings**
*(Note: `g.`, `g/`, `go`, `gy` are active when the MiniFiles buffer is open)*

| Key         | Description                |
|-------------|----------------------------|
| `<leader>e` | Toggle mini-files explorer |
| `g.`        | Toggle hidden files        |
| `g/`        | Set cwd                    |
| `go`        | OS open                    |
| `gy`        | Yank path                  |

**Plugin: `snacks.nvim` Keybindings**

| Key         | Description                        |
|-------------|------------------------------------|
| `<leader>sgb`| Open git blame for current line    |
| `<leader>sgB`| Git browse active file             |
| `<leader>sgl`| Open lazygit                       |
| `<m-`>`       | Toggle Terminal (vsplit) (N,I,T) |
| `<leader>fg` | Live Grep                          |
| `<leader>ff` | Find Files                         |
| `<leader>fb` | Find Buffers                       |
| `<leader>fli`| Find LSP Implementations           |
| `<leader>fls`| Find LSP Symbols                   |
| `<leader>fd` | Diagnostics picker (buffer)        |
| `<leader>fh` | Find Help Pages                    |
| `<leader>fc` | Pick Colorschemes                  |
| `<leader>fH` | Find hl_groups                     |
| `<leader>fG` | Git diff                           |

**LSP Keybindings (Normal Mode, buffer-specific)**

| Key         | Description                                           |
|-------------|-------------------------------------------------------|
| `<leader>ld`| Jump to definition                                    |
| `<leader>lD`| Jump to type definition                               |
| `<leader>lh`| Show hover information                                |
| `<leader>lc`| Show code actions                                     |
| `<leader>lF`| Format the code (also Visual mode)                    |
| `<leader>lI`| Toggle lsp inlay hints                                |
| `<leader>li`| Show implementations of the current word              |
| `<leader>lr`| Rename all the instances of the symbol in the current buffer |
| `<leader>lR`| Restart LSP client                                    |
| `<leader>ls`| Open Signature Help                                   |
| `<leader>ll`| Jump to declaration                                   |
| `<leader>lf`| Show float diagnostics                                |

# Things not done yet, but are planned
- [ ] Better error handling for statusline/tabline/statuscolumn.
- [ ] luasnip snippets (right now it just serves the purpose of completing lsp snippets via `blink.cmp`).
- [x] Document existing keybindings.
- [ ] LSP configuration for more LSP servers.
