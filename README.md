# Neovim Config
A clean, blazingly fast and heavily tweaked neovim setup focused on productivity and performance.

> [!note]
> This neovim setup is heavily modified to my liking and my workflow. However, everything is pretty straightforward and clean, so you won't be having any trouble in tinkering with the setup to suit it to your needs.
> The setup's being actively developed and functional. While I strive for stability, some areas might undergo rapid changes or refactoring as improvements are made.
> If you encounter any problems or bugs, please raise an issue; I'll try to fix them as soon as possible. PR's are more than welcome!

> ⚡ **Startup time:** \~20ms

<img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/3231a689-8020-4112-8402-c45dcc42c52e" />


## Table of contents
*   [Screeshots](#screenshots)
*   [Prerequisites](#prerequisites)
*   [Install Instructions](#install-instructions)
*   [Features & plugins](#features--plugins)
*   [How to's](#how-tos)
*   [Add an lsp configuration](#add-an-lsp-configuration-for-your-lsp-server)
*   [Using the ui elements](#using-the-tablinestatuslinestatuscolumn-in-your-personal-config)
*   [Adding custom modules to the statusline](#adding-custom-modules-to-the-statusline)
*   [Keybindings](#keybindings)
*   [Planned features](#planned-features)
*   [Contributing](#contributing)

# Screenshots
<details>
    <summary><h3>picker (click to expand)</h3></summary>
    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/c7e422c9-84af-46fa-b925-604a2dd2a53b" />
</details>
<details>
    <summary><h3>file explorer (click to expand)</h3></summary>
    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/200577fd-fdbb-494d-a4c1-44bee36b1d07" />
</details>
<details>
    <summary><h3>completions (click to expand)</h3></summary>
    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/4107f082-533a-4e47-876d-2f8c6967839f" />
</details>
<details>
    <summary><h3>splits (click to expand)</h3></summary>
    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/a800fcfb-c145-4f98-a2ad-138e2c44928c" />
</details>
<details>
    <summary><h3>whichkey (click to expand)</h3></summary>
    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/85565852-cff8-4ddf-9492-2e9d76467230" />
</details>
<details>
    <summary><h3>diagnostics (click to expand)</h3></summary>
    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/00faa27d-6037-45fe-91dc-54b51c801051" />
</details>
<details>
    <summary><h3>plugin manager (click to expand)</h3></summary>
    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/ecfd9674-0a62-4cf4-a03d-46455761981b" />
</details>
<details>
    <summary><h3>mason (click to expand)</h3></summary>
    <img width="1920" height="1080" alt="image" src="https://github.com/user-attachments/assets/7db2dfec-d207-4fbd-88d0-a12ab77c4bed" />
</details>

# Prerequisites

Before you begin, ensure you have the following installed:

*   **Neovim(obviously):** i use the latest git version but any binaries with version 0.11+ should work just fine.
*   **Git:** for cloning the repository.
*   **A Nerd Font:** required for icons in the ui elements (statusline, tabline, etc.) to display correctly. the one used in the config is `victor mono nerd font propo`.
*   **A C Compiler:** for `nvim-treesitter` and other plugins that might need to build components, typically `gcc` or `clang`.

# Install Instructions

To get the setup up and running,
Firstly backup your current neovim setup:

```bash
mv ~/.config/nvim ~/.config/nvim.bak
mv ~/.local/share/nvim ~/.local/share/nvim.bak
```

Now, simply clone the repository into your `$xdg_config_home/nvim` directory (typically `~/.config/nvim`):

```bash
git clone https://gitlab.com/100x65b1111000/nvim.git ~/.config/nvim
```

Then, launch neovim:
```bash
nvim
```
On the first launch, `lazy.nvim` should automatically install all the plugins.

# Features & Plugins

Following are the main highlights of the configuration.

**Core functionality & ui:**

*   **Custom ui elements:**
*   Statusline: custom-built (\~500 loc, \~0.25ms performance) with a focus on minimalism and aesthetics.
![image](https://github.com/user-attachments/assets/4030f2b2-efea-44dc-bde8-60b319abece2)
*   Tabline: custom-built (\~500 loc, \~0.20ms performance) for a clean and informative tab experience.
![image](https://github.com/user-attachments/assets/2d06e484-7659-4098-b6e5-7250a033a10d)
*   Statuscolumn: custom-built (\~150 loc, \~0.03ms performance) for displaying line-related information.
*   *note: these custom ui elements are highly optimized but offer limited direct configuration. see the "how to's" section for usage.*

*   **Plugin management:** [lazy.nvim](https://github.com/folke/lazy.nvim) for efficient and easy plugin management.
*   **Dashboard:** customized startup dashboard via [dashboard.nvim](https://github.com/nvimdev/dashboard.nvim).
*   **Theme:** [kanagawa.nvim](https://github.com/rebelot/kanagawa.nvim) and [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) with tweaked colors for better visibility.
*   **Keybinding hints:** [which-key](https://github.com/folke/which-key.nvim) to display available key bindings.
*   **File explorer:** [mini.files](https://github.com/echasnovski/mini.files) for a minimalistic and fast file explorer.

**LSP, completion & formatting:**

*   **LSP:** native lsp setup via `vim.lsp.config` for language intelligence.
*   **Completion:** [blink.cmp](https://github.com/saghen/blink.cmp) for code completions.
*   **Formatting:** [conform.nvim](https://github.com/stevearc/conform.nvim) for code formatting.
*   **Treesitter:** [nvim-treesitter](https://github.com/nvim-treesitter/nvim-treesitter) for advanced syntax highlighting and code analysis.

**git integration:**

*   **Git signs:** [git-signs.nvim](https://github.com/lewis6991/gitsigns.nvim) to show git changes in the sign column.
*   **Git utilities:** [snacks.nvim](https://github.com/folke/snacks.nvim) includes various git-related utilities (blame, browse, etc.).

**Productivity & Utility tools:**

*   **General utilities:** [snacks.nvim](https://github.com/folke/snacks.nvim) for tasty snacks (picker, notifier, indent-guides).
*   **Help viewer:** [helpview.nvim](https://github.com/oxy2dev/helpview.nvim) for an improved help viewing experience.
*   **Markdown preview (enhanced):** [markview.nvim](https://github.com/oxy2dev/markview.nvim) for viewing marks and improved markdown navigation/preview.
*   **Keypress display:** [showkeys.nvim](https://github.com/nvzone/showkeys) to display pressed keys (useful for demos/screencasts).
*   **Navigation bar:** [dropbar.nvim](https://github.com/bekaboo/dropbar.nvim) for a context-aware treesitter powered navigation bar.
*   **Startup time analysis:** [vim-startuptime](https://github.com/dstein64/vim-startuptime) for profiling neovim startup time.
*   **Developer utilities for lua:** [lazydev](https://github.com/folke/lazydev.nvim) for assisting with lua development in neovim.
*   **Color highlighter:** [highlight-colors.nvim](https://github.com/brenoprata10/nvim-highlight-colors) to highlight color codes in your files.

# How to's

## Add snippets for x language
You’ll find snippets in `./lua/snippets`. If the snippets are missing for your x language, you’ll need to write it yourself (yeah, no auto-gen magic here). but doing so is fairly easy and straightorward.

## Add an lsp configuration for your lsp server
Here's a step-by-step guide (with an example setup to configure the `basedpyright` language-server) to add a new lsp server configuration:
1.  Create a file inside the `./lua/config/lsp/servers/` directory, say `basedpyright.lua`.
2.  Define the lsp configuration spec like this:
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
                loglevel = "error",
                inlayhints = {
                    generictypes = true,
                },
                uselibraryforcodetypes = true,
                autoimportcompletions = true,
                diagnosticmode = "workspace",
                typecheckingmode = "standard",
            },
            python = {},
        },
    },
})

vim.lsp.enable("basedpyright") -- enable the language server
```
3.  Save the file.
4.  And that's it. the setup will automatically define and add necessary `capabilities` and `on_attach` options to your configuration and include it. the `capabilities` generally refer to what features the lsp client (neovim) supports, and `on_attach` is a function that runs when the lsp server attaches to a buffer, often used to set buffer-local keymaps for lsp actions.

## Using the tabline/statusline/statuscolumn in your personal config

Integrating the custom ui elements (statusline, tabline, statuscolumn) into your own neovim configuration is pretty straightforward.

**Important dependencies & setup:**

> [!important]
> *   **`mini.icons`:** The statusline and tabline require the [mini.icons](https://github.com/echasnovski/mini.nvim/blob/main/readmes/mini-icons.md) plugin (part of the `mini.nvim` suite) to generate some highlight groups and display file icons. ensure this plugin is installed and loaded.
> *   **Nerd Font:** as mentioned in prerequisites, a nerd font is essential for icons to render correctly.
> *   **Highlight groups:** If you are using a colorscheme other than the modified ones included in the setup, you **must** define specific highlight groups for the ui elements to look correct. you can find these highlight groups in the `lua/plugins/tokyonight.lua` spec file (search `/statusline` and `/tabline` for `statusline` and `tabline` specific highlights, and define them directly in the colorscheme spec or via `vim.api.nvim_set_hl`).

**Integration steps:**

1.  **Copy the `ui` directory:** grab the entire `lua/ui` folder from this configuration and place it inside your neovim config's `lua` directory (e.g., `~/.config/nvim/lua/ui`).
2.  **Call the setup function:** in your neovim configuration (e.g., in your `init.lua` or a dedicated ui setup file), call the setup function to enable the ui elements.

```lua
-- enable all custom ui elements
require('ui').setup({ enable = true })

-- or, enable specific elements (e.g., all except statusline)
require('ui').setup({
    enable = true,
    statusline = { enabled = false }
})
```

## Adding custom modules to the statusline

You can extend the statusline with your own custom modules (although it's just bare bones). the process involves defining a lua function that returns a table with a specific spec, and then adding this function to your statusline configuration.

**1. Define a module function**

A custom module is a lua function that returns a table with specific keys. the main keys are:

*   `string`: (required) the text content you want the module to display.
*   `hl_group`: (optional) the highlight group to apply to the `string`. if omitted, it will likely use the default highlight group.
*   `icon`: (optional) an icon to display in the module.
*   `icon_hl`: (optional) the highlight group for the `icon`.
*   `reverse`: (optional) a boolean. if `true`, the `string` is displayed first, then the `icon`. defaults to `false` (icon first).
*   `show_right_sep`: (optional) a boolean that defines whether to show the right separator for the module or not. (does not show the separator by default).
*   `show_left_sep`: (optional) same as `show_right_sep` but for the left separator (useful for modules at right).
*   `right_sep_hl`: (optional) highlight group for right separator.
*   `left_sep_hl`: (optional) same as `right_sep_hl`, but for the left separator.

Here's an example of a simple custom module that displays the current date:

```lua
local function my_date_module()
    local date_str = os.date("%y-%m-%d")
    return {
        string = date_str,
        hl_group = "comment", -- example highlight group (optional, would use the `statuslinenormal` group if not specified)
        icon = " ",          -- example icon (requires a nerd font) (optional)
        icon_hl = "special"    -- example highlight group for the icon (optional)
    }
end
```

**2. Now just add this function inside your statusline setup like this**

```lua
-- assuming the ui directory exists inside ~/.config/nvim/lua/
require('ui').setup({enabled = true, statusline = { enabled = true, modules = { left = { "mode", "buf-status", "buf-info", my_date_module }, middle = { ... }, right = { ... }}}})
```

**Here's what the above setup results in**
![image](https://github.com/user-attachments/assets/cb20e4b5-c8d9-47c2-8f69-1cc5ef9a0d81)

# Keybindings

This section outlines the keybindings configured in this neovim setup.


<details>
    <summary><h3>Core Keybindings (click to expand)</h3></summary>
    <details>
        <summary>Normal Mode (click to expand)</summary>
        <table>
            <thead>
                <tr>
                    <th>Key</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>&lt;leader&gt;a</code></td>
                    <td>select all</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;ay</code></td>
                    <td>select all and copy</td>
                </tr>
                <tr>
                    <td><code>&lt;esc&gt;</code></td>
                    <td>clear search highlight</td>
                </tr>
                <tr>
                    <td><code>&lt;tab&gt;</code></td>
                    <td>switch to the next tab</td>
                </tr>
                <tr>
                    <td><code>&lt;s-tab&gt;</code></td>
                    <td>switch to the previous tab</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;bh</code></td>
                    <td>previous buffer</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;bl</code></td>
                    <td>next buffer</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;bd</code></td>
                    <td>delete buffer</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;bb</code></td>
                    <td>switch with previous buffer</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;bp</code></td>
                    <td>list buffers</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wh</code></td>
                    <td>focus window (left)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wj</code></td>
                    <td>focus window (right)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wk</code></td>
                    <td>focus window (up)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wl</code></td>
                    <td>focus window (down)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wo</code></td>
                    <td>close all other windows</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;ws</code></td>
                    <td>split window (horizontally)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wv</code></td>
                    <td>split window (vertically)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wq</code></td>
                    <td>quit window</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wt</code></td>
                    <td>break out to a new tab</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;ww</code></td>
                    <td>switch windows</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wx</code></td>
                    <td>swap window with next</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w+</code></td>
                    <td>increase height</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w-</code></td>
                    <td>decrease height</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w_</code></td>
                    <td>max height</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w&gt;</code></td>
                    <td>increase width</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w&lt;</code></td>
                    <td>decrease width</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w\|</code></td>
                    <td>max width</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w=</code></td>
                    <td>equal height and width</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;hv</code></td>
                    <td>open help (vertical split)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;hh</code></td>
                    <td>open help (horizontal split)</td>
                </tr>
                <tr>
                    <td><code>&lt;c-s-r&gt;</code></td>
                    <td>restart neovim</td>
                </tr>
                <tr>
                    <td><code>&lt;c-j&gt;</code></td>
                    <td>move current line down</td>
                </tr>
                <tr>
                    <td><code>&lt;c-k&gt;</code></td>
                    <td>move current line up</td>
                </tr>
            </tbody>
        </table>
    </details>
    <details>
        <summary>Visual Mode (click to expand)</summary>
        <table>
            <thead>
                <tr>
                    <th>Key</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>&lt;leader&gt;bd</code></td>
                    <td>delete buffer</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;bb</code></td>
                    <td>switch with previous buffer</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;bp</code></td>
                    <td>list buffers</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wh</code></td>
                    <td>focus window (left)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wj</code></td>
                    <td>focus window (right)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wk</code></td>
                    <td>focus window (up)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wl</code></td>
                    <td>focus window (down)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wo</code></td>
                    <td>close all other windows</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;ws</code></td>
                    <td>split window (horizontally)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wv</code></td>
                    <td>split window (vertically)</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wq</code></td>
                    <td>quit window</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wt</code></td>
                    <td>break out to a new tab</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;ww</code></td>
                    <td>switch windows</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;wx</code></td>
                    <td>swap window with next</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w+</code></td>
                    <td>increase height</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w-</code></td>
                    <td>decrease height</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w_</code></td>
                    <td>max height</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w&gt;</code></td>
                    <td>increase width</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w&lt;</code></td>
                    <td>decrease width</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w\|</code></td>
                    <td>max width</td>
                </tr>
                <tr>
                    <td><code>&lt;leader&gt;w=</code></td>
                    <td>equal height and width</td>
                </tr>
                <tr>
                    <td><code>&lt;c-j&gt;</code></td>
                    <td>move selected lines down</td>
                </tr>
                <tr>
                    <td><code>&lt;c-k&gt;</code></td>
                    <td>move selected lines up</td>
                </tr>
                <tr>
                    <td><code>/</code></td>
                    <td>search forward within visual selection</td>
                </tr>
                <tr>
                    <td><code>?</code></td>
                    <td>search backward within visual selection</td>
                </tr>
            </tbody>
        </table>
    </details>
    <details>
        <summary>Insert Mode (click to expand)</summary>
        <table>
            <thead>
                <tr>
                    <th>Key</th>
                    <th>Description</th>
                </tr>
            </thead>
            <tbody>
                <tr>
                    <td><code>&lt;c-k&gt;</code></td>
                    <td>move current line up</td>
                </tr>
                <tr>
                    <td><code>&lt;c-j&gt;</code></td>
                    <td>move current line down</td>
                </tr>
                <tr>
                    <td><code>&lt;c-d&gt;</code></td>
                    <td>delete previous word</td>
                </tr>
            </tbody>
        </table>
</details>

</details>

<details>
    <summary><h3>Plugin: `mini.files` keybindings (click to expand)</h3></summary>
    <code>(note: `g.`, `g/`, `go`, `gy` are active when the minifiles buffer is open)</code>
    <table>
        <thead>
            <tr>
                <th>Key</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><code>&lt;leader&gt;e</code></td>
                <td>toggle mini-files explorer</td>
            </tr>
            <tr>
                <td><code>g.</code></td>
                <td>toggle hidden files</td>
            </tr>
            <tr>
                <td><code>g/</code></td>
                <td>set cwd</td>
            </tr>
            <tr>
                <td><code>go</code></td>
                <td>os open</td>
            </tr>
            <tr>
                <td><code>gy</code></td>
                <td>yank path</td>
            </tr>
        </tbody>
    </table>
</details>

<details>
    <summary><h3>Plugin: `snacks.nvim` keybindings (click to expand)</h3></summary>
    <table>
        <thead>
            <tr>
                <th>Key</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><code>&lt;leader&gt;sgb</code></td>
                <td>open git blame for current line</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;sgb</code></td>
                <td>git browse active file</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;sgl</code></td>
                <td>open lazygit</td>
            </tr>
            <tr>
                <td><code>&lt;m-`&gt;</code></td>
                <td>toggle terminal (vsplit) (n,i,t)</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fg</code></td>
                <td>live grep</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;ff</code></td>
                <td>find files</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fb</code></td>
                <td>find buffers</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fli</code></td>
                <td>find lsp implementations</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fls</code></td>
                <td>find lsp symbols</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fd</code></td>
                <td>diagnostics picker (buffer)</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fh</code></td>
                <td>find help pages</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fc</code></td>
                <td>pick colorschemes</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fh</code></td>
                <td>find hl_groups</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;fg</code></td>
                <td>git diff</td>
            </tr>
        </tbody>
    </table>
</details>

<details>
    <summary><h3>LSP Keybindings (normal mode, buffer-specific) (click to expand)</h3></summary>
    <table>
        <thead>
            <tr>
                <th>Key</th>
                <th>Description</th>
            </tr>
        </thead>
        <tbody>
            <tr>
                <td><code>&lt;leader&gt;ld</code></td>
                <td>jump to definition</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;ld</code></td>
                <td>jump to type definition</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;lh</code></td>
                <td>show hover information</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;lc</code></td>
                <td>show code actions</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;lf</code></td>
                <td>format the code (also visual mode)</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;li</code></td>
                <td>toggle lsp inlay hints</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;li</code></td>
                <td>show implementations of the current word</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;lr</code></td>
                <td>rename all the instances of the symbol in the current buffer</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;lr</code></td>
                <td>restart lsp client</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;ls</code></td>
                <td>open signature help</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;ll</code></td>
                <td>jump to declaration</td>
            </tr>
            <tr>
                <td><code>&lt;leader&gt;lf</code></td>
                <td>show float diagnostics</td>
            </tr>
        </tbody>
    </table>
</details>

# Planned features
- [ ] better error handling for statusline/tabline/statuscolumn.
- [x] luasnip snippets.
- [x] document existing keybindings.
- [x] lsp configuration for more lsp servers.

# Contributing

Contributions are highly welcome! whether it's reporting a bug, suggesting an enhancement, or submitting a pull request.

*   **Reporting issues:** if you encounter any bugs or have suggestions for improvements, please open an issue on the gitlab repository. provide as much detail as possible, including steps to reproduce, your neovim version, and any relevant error messages.
*   **Pull requests:**
    *   For small fixes or enhancements, feel free to submit a pr directly.
    *   For more significant changes, it's a good idea to open an issue first to discuss the proposed changes and ensure they align with the project's direction.
    *   Please try to follow the existing coding style and provide a clear description of your changes in the pr.
