# NEOVIM CONFIG
This is my personal neovim config that I have developed thoughout my journey of daily driving neovim. It may or may not suit your needs but if it does, I'm happy to hear that.

> [!Note]
> As of right now, this config is somewhat experimental but functional, as changes are undergoing on the fly, the code is a mess rn (I'm trying my best to clean that). Any issues that I tackle, I try to fix them asap.
> If you are facing any problem or bugs, just raise an issue, I'll try to fix them asap. PR's are more than welcome !. 

# SHOWCASE
![image](https://github.com/user-attachments/assets/225bf5a2-fa93-443a-8253-ca3315fdb233)
![image](https://github.com/user-attachments/assets/45cb8d9f-ed50-4768-be81-b5faa6c31aff)
![image](https://github.com/user-attachments/assets/36d85487-9804-4948-a70a-422d972e3483)
![image](https://github.com/user-attachments/assets/f6295ec9-60e7-40d4-b31c-9cf03873d86f)
![image](https://github.com/user-attachments/assets/24d388c8-50e5-41f1-9a46-35efb957f51b)
![image](https://github.com/user-attachments/assets/eec8d707-b1b3-4c46-8531-7dd4124975e7)
![image](https://github.com/user-attachments/assets/e23b0e56-67db-4301-af54-3a9e4fac650b)



# Install Instructions

To get the setup up and running.
Firstly backup your current neovim setup.
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
- Home baked statusline ( ~500 loc ) and tabline ( ~500 loc) with minimalism and aesthetics in mind, however not much configurable.
![image](https://github.com/user-attachments/assets/a8522a29-dc3e-41af-b23b-c8268ca81a3f)


- Reasonable defaults.
- [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.
- Customized dashboard with [dashboard.nvim](https://github.com/nvimdev/dashboard.nvim).
- [tokyonight.nvim](https://github.com/folke/tokyonight.nvim) theme with tweaked colors for better visibility.
- [which-key](https://github.com/folke/which-key.nvim) to display available key bindings.
- [blink.cmp](https://github.com/Saghen/blink.cmp) for completions.
- [snacks.nvim](https://github.com/folke/snacks.nvim) for tasty snacks.
- [mini.files](https://github.com/echasnovski/mini.files) as the file explorer.
- lsp setup via `vim.lsp.config`.

There are many more plugins included by default, such as git-signs.nvim, mini.pairs, helpview.nvim, markview.nvim, showkeys.nvim, dropbar.nvim, nvim-treesitter, vim-startuptime, lazydev, conform.nvim,highlight-colors.nvim.

# Things not done yet, but are planned
- [x] luasnip snippets (right now it just servers the purpose of completing lsp snippets via `blink.cmp`).
- [ ] add more keybinds.
