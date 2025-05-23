# NEOVIM CONFIG
This is my personal neovim config that I have developed thoughout my journey of daily driving neovim. It may or may not suit your needs but if it does, I'm happy to hear that.

> [!Note]
> As of right now, this config is somewhat experimental but functional, as changes are undergoing on the fly, the code is a mess rn (I'm trying my best to clean that). Any issues that I tackle, I try to fix them asap.
> If you are facing any problem or bugs, just raise an issue, I'll try to fix them asap. PR's are more than welcome !. 

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
mv ~/.config/{nvim,nvim.bak}
mv ~/.local/share/{nvim,nvim.bak}
```

Now, simply clone the repository into your `$XDG_CONFIG_HOME/nvim` directory.

```bash
git clone htps://gitlab.com/100x65b1111000/nvim.git ~/.config/nvim
nvim
```

# Highlights
- Manually baked statusline ( ~500 loc ), statuscolumn ( ~150 loc ) and tabline ( ~500 loc) with minimalism and aesthetics in mind, however not much configurable.
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

There are many more plugins included by default, such as git-signs.nvim, mini.pairs, helpview.nvim, markview.nvim, showkeys.nvim, dropbar.nvim, nvim-treesitter, vim-startuptime, lazydev, conform.nvim, highlight-colors.nvim.

# Things not done yet, but are planned
- [ ] luasnip snippets (right now it just servers the purpose of completing lsp snippets via `blink.cmp`).
- [ ] add more keybinds.
- [ ] Lsp configuration for more lsp servers.
