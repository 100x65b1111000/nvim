# NEOVIM CONFIG

<table>
    <th colspan=2>StartupTime: ~20ms</th>
    <tr>
        <td align="center" colspan=2>
            <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/0892bed6-d315-40dc-ab99-21b5c8b2b01d" />
        </td>
    </tr>
    <tr>
        <td align="center">
          <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c7e422c9-84af-46fa-b925-604a2dd2a53b" />
        </td>
        <td align="center">
          <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/200577fd-fdbb-494d-a4c1-44bee36b1d07" />
        </td>
    </tr>
    <tr>
        <td align="center">
          <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/4107f082-533a-4e47-876d-2f8c6967839f" />
        </td>
        <td align="center">
          <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a800fcfb-c145-4f98-a2ad-138e2c44928c" />
        </td>
    </tr>
    <tr>
        <td align="center">
          <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/85565852-cff8-4ddf-9492-2e9d76467230" />
        </td>
		    <td>
		    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/00faa27d-6037-45fe-91dc-54b51c801051" />
        </td>
    </tr>
    <tr>
        <td align="center">
          <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ecfd9674-0a62-4cf4-a03d-46455761981b" />
		</td>
        <td align="center">
          <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7db2dfec-d207-4fbd-88d0-a12ab77c4bed" />
        </td>
    </tr>
</table>

# Table of Contents

*   [Introduction](#about-the-project)
*   [Prerequisites](#prerequisites)
*   [Install Instructions](#install-instructions)
*   [Features & Plugins](#features--plugins)
*   [How to's](#how-tos)
    *   [Add an LSP Configuration](#add-an-lsp-configuration-for-your-lsp-server)
    *   [Using the UI Elements](#using-the-tablinestatuslinestatuscolumn-in-your-personal-config)
    *   [Adding Custom Modules to the Statusline](#adding-custom-modules-to-the-statusline)
*   [Keybindings](#keybindings)
*   [Planned Features](#planned-features)
*   [Contributing](#contributing)

# About the project

I wanted a Neovim setup that looks good, runs fast, and feels like *mine*. If someone's into clean looks, custom UI bits (like the statusline, tabline, and statuscolumn), and want something that just works nicely from the get-go, this might be for them. It's definitely **heavily tweaked** to my liking, but I've tried to keep things straightforward enough if someone wants to tinker with it or use it as a starting point.

> [!Note]
> This configuration is actively developed and functional. While I strive for stability, some areas might undergo rapid changes or refactoring as improvements are made. I'll try to do my best to address any encountered issues.
> If you encounter any problems or bugs, please raise an issue; I'll try to fix them as soon as possible. PRs are more than welcome!

# Prerequisites

Before you begin, ensure you have the following installed:

*   **Neovim(obviously):** I use the latest git version but any binaries with version 0.11+ should work just fine.
*   **Git:** For cloning the repository.
*   **A Nerd Font:** Required for icons in the UI elements (statusline, tabline, etc.) to display correctly. The one used in the config is `Victor Mono Nerd Font Propo`.
*   **A C Compiler:** For `nvim-treesitter` and other plugins that might need to build components, typically `gcc` or `clang`.

# Install Instructions

To get the setup up and running,
Firstly backup your current neovim setup:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

Now, simply clone the repository into your `$XDG_CONFIG_HOME/nvim` directory (typically `~/.config/nvim`):

```bash
git clone https://gitlab.com/100x65b1111000/nvim.git ~/.config/nvim
```

Then, launch Neovim:
```bash
nvim
```
On the first launch, `lazy.nvim` should automatically install all the plugins.

# Features & Plugins

Following are the main highlights of the configuration.

**Core Functionality & UI:**

*   **Custom UI Elements:**
    *   Statusline: Custom-built (\~500 LOC, \~0.25ms performance) with a focus on minimalism and aesthetics.
        ![image](https://github.com/user-attachments/assets/4030f2b2-efea-44dc-bde8-60b319abece2)
    *   Tabline: Custom-built (\~500 LOC, \~0.20ms performance) for a clean and informative tab experience.
        ![image](https://github.com/user-attachments/assets/2d06e484-7659-4098-b6e5-7250a033a10d)
    *   Statuscolumn: Custom-built (\~150 LOC, \~0.03ms performance) for displaying line-related information.
    *   *Note: These custom UI elements are highly optimized but offer limited direct configuration. See the "How to's" section for usage.*
*   **Plugin Management:** [lazy.nvim](https://github.com/folke/lazy.nvim) for efficient and easy plugin management.
*   **Dashboard:** Customized startup dashboard via [dashboard.nvim](https://github.com/nvimdev/dashboard.nvim).
*   **Theme:** [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) with tweaked colors for better visibility.
*   **Keybinding Hints:** [which-key](https://github.com/folke/which-key.nvim) to display available key bindings.
*   **File Explorer:** [mini.files](https://github.com/echasnovski/mini.files) for a minimalistic and fast file explorer.
*   **Auto Pairs:** [mini.pairs](https://github.com/echasnovski/mini.nvim) for automatic insertion of matching pairs.

**LSP, Completion & Formatting:**

*   **LSP:** Native LSP setup via `vim.lsp.config` for language intelligence.
*   **Completion:** [blink.cmp](https://github.com/Saghen/blink.cmp) for code completions.
*   **Formatting:** [conform.nvim](https://github.com/stevearc/conform.nvim) for code formatting.
*   **Treesitter:** [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for advanced syntax highlighting and code analysis.

**Git Integration:**

*   **Git Signs:** [git-signs.nvim](https://github.com/lewis6991/gitsigns.nvim) to show git changes in the sign column.
*   **Git Utilities:** [snacks.nvim](https://github.com/folke/snacks.nvim) includes various git-related utilities (blame, browse, etc. - also listed under "Productivity Tools").

**Productivity & Utility Tools:**

*   **General Utilities:** [snacks.nvim](https://github.com/folke/snacks.nvim) for tasty snacks (picker, notifier, indent-guides).
*   **Help Viewer:** [helpview.nvim](https://github.com/OXY2DEV/helpview.nvim) for an improved help viewing experience.
*   **Markdown Preview (enhanced):** [markview.nvim](https://github.com/OXY2DEV/markview.nvim) for viewing marks and improved markdown navigation/preview.
*   **Keypress Display:** [showkeys.nvim](https://github.com/nvzone/showkeys) to display pressed keys (useful for demos/screencasts).
*   **Navigation Bar:** [dropbar.nvim](https://github.com/Bekaboo/dropbar.nvim) for a context-aware treesitter powered navigation bar.
*   **Startup Time Analysis:** [vim-startuptime](https://github.com/dstein64/vim-startuptime) for profiling Neovim startup time.
*   **Developer Utilities for Lua:** [lazydev](https://github.com/folke/lazydev.nvim) for assisting with Lua development in Neovim.
*   **Color Highlighter:** [highlight-colors.nvim](https://github.com/brenoprata10/nvim-highlight-colors) to highlight color codes in your files.

# How To's

## Add an LSP Configuration for Your LSP Server
Here's a step-by-step guide (with an example setup to configure the `basedpyright` language-server) to add a new LSP server configuration:
1.  Create a file inside the `~/.config/nvim/lua/config/lsp/servers/` directory, say `basedpyright.lua`.
2.  Define the LSP configuration spec like this:
    ```lua
    vim.lsp.config("basedpyright", {
        cmd = {
            "basedpyright-langserver", -- command to start the language server
            "--stdio", -- arguments
        },
        filetypes = { "python" }, -- filetypes to attach the lsp server to
        settings = { -- extra options you might want to pass to the lsp server (consult the lsp server documentation)
            basedpyright = {
                analysis = {
                    logLevel = "Error",
                    inlayHints = {
                        genericTypes = true,
                    },
                    useLibraryForCodeTypes = true,
                    autoImportCompletions = true,
                    diagnosticMode = "workspace",
                    typeCheckingMode = "standard",
                },
                python = {},
            },
        },
    })

    vim.lsp.enable("basedpyright") -- Enable the language server
    ```
3.  Save the file.
4.  And that's it. The setup will automatically define and add necessary `capabilities` and `on_attach` options to your configuration and include it. The `capabilities` generally refer to what features the LSP client (Neovim) supports, and `on_attach` is a function that runs when the LSP server attaches to a buffer, often used to set buffer-local keymaps for LSP actions.

## Using the Tabline/Statusline/Statuscolumn in Your Personal Config

Integrating the custom UI elements (statusline, tabline, statuscolumn) into your own Neovim configuration is pretty straightforward.

**Important Dependencies & Setup:**

> [!Important]
> *   **`mini.icons`:** The statusline and tabline require the [mini.icons](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-icons.md) plugin (part of the `mini.nvim` suite) to generate some highlight groups and display file icons. Ensure this plugin is installed and loaded.
> *   **Nerd Fonts:** As mentioned in Prerequisites, a Nerd Font is essential for icons to render correctly.
> *   **Highlight Groups:** If you are using a colorscheme other than the modified ones included in the setup, you **must** define specific highlight groups for the UI elements to look correct. You can find these highlight groups in the `lua/plugins/tokyonight.lua` spec file (search `/StatusLine` and `/TabLine` for `StatusLine` and `TabLine` specific highlights, and define them directly in the colorscheme spec or via `vim.api.nvim_set_hl`).

**Integration Steps:**

1.  **Copy the `ui` directory:** Grab the entire `lua/ui` folder from this configuration and place it inside your Neovim config's `lua` directory (e.g., `~/.config/nvim/lua/ui`).
2.  **Call the setup function:** In your Neovim configuration (e.g., in your `init.lua` or a dedicated UI setup file), call the setup function to enable the UI elements.

    ```lua
    -- Enable all custom UI elements
    require('ui').setup({ enable = true })
    
    -- Or, enable specific elements (e.g., all except statusline)
    require('ui').setup({
        enable = true,
        statusline = { enabled = false }
    })
    ```

### Adding Custom Modules to the Statusline

You can extend the statusline with your own custom modules (although it's just bare bones). The process involves defining a Lua function that returns a table with a specific spec, and then adding this function to your statusline configuration.

**1. Define Your Module Function**

A custom module is a Lua function that returns a table with specific keys. The main keys are:

*   `string`: (Required) The text content you want the module to display.
*   `hl_group`: (Optional) The highlight group to apply to the `string`. If omitted, it will likely use the default highlight group.
*   `icon`: (Optional) An icon to display in the module.
*   `icon_hl`: (Optional) The highlight group for the `icon`.
*   `reverse`: (Optional) A boolean. If `true`, the `string` is displayed first, then the `icon`. Defaults to `false` (icon first).
*   `show_right_sep`: (Optional) A boolean that defines whether to show the right separator for the module or not. (Does not show the separator by default).
*   `show_left_sep`: (Optional) Same as `show_right_sep` but for the left separator (useful for modules at right).
*   `right_sep_hl`: (Optional) Highlight group for right separator.
*   `left_sep_hl`: (Optional) Same as `right_sep_hl`, but for the left separator.

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

**2. Now Just Add This Function Inside Your Statusline Setup Like This**

```lua
-- Assuming the ui directory exists inside ~/.config/nvim/lua/
require('ui').setup({enabled = true, statusline = { enabled = true, modules = { left = { "mode", "buf-status", "buf-info", my_date_module }, middle = { ... }, right = { ... }}}})
```

**Here's What the Above Setup Results In**
![image](https://github.com/user-attachments/assets/cb20e4b5-c8d9-47c2-8f69-1cc5ef9a0d81)
> Notice that the middle and right modules are blank. Once you define the `left`, `middle`, or `right` modules, they will be overridden and will default to empty if an empty table is passed to them.

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
| `<leader>ws`| Split window (horizontally)     |
| `<leader>wv`| Split window (vertically)       |
| `<leader>wq`| Quit window                     |
| `<leader>wT`| Break out to a new tab          |
| `<leader>ww`| Switch windows                  |
| `<leader>wx`| Swap window with next           |
| `<leader>w+`| Increase height                 |
| `<leader>w-`| Decrease height                 |
| `<leader>w_`| Max height                      |
| `<leader>w>`| Increase width                  |
| `<leader>w<`| Decrease width                  |
| `<leader>w\|`| Max width                       |
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
| `<leader>ws`| Split window (horizontally)          |
| `<leader>wv`| Split window (vertically)            |
| `<leader>wq`| Quit window                          |
| `<leader>wT`| Break out to a new tab               |
| `<leader>ww`| Switch windows                       |
| `<leader>wx`| Swap window with next                |
| `<leader>w+`| Increase height                      |
| `<leader>w-`| Decrease height                      |
| `<leader>w_`| Max height                           |
| `<leader>w>`| Increase width                       |
| `<leader>w<`| Decrease width                       |
| `<leader>w\|`| Max width                            |
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

# Planned Features
- [ ] Better error handling for statusline/tabline/statuscolumn.
- [x] luasnip snippets.
- [x] Document existing keybindings.
- [x] LSP configuration for more LSP servers.

# Contributing

Contributions are highly welcome! Whether it's reporting a bug, suggesting an enhancement, or submitting a pull request, your input is valued.

*   **Reporting Issues:** If you encounter any bugs or have suggestions for improvements, please open an issue on the GitLab repository. Provide as much detail as possible, including steps to reproduce, your Neovim version, and any relevant error messages.
*   **Pull Requests:**
    *   For small fixes or enhancements, feel free to submit a PR directly.
    *   For more significant changes, it's a good idea to open an issue first to discuss the proposed changes and ensure they align with the project's direction.
    *   Please try to follow the existing coding style and provide a clear description of your changes in the PR.
