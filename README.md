# NEOVIM CONFIG
This is my personal neovim config that I have developed thoughout my journey of daily driving neovim. It may or may not suit your needs but if it does, I'm happy to hear that.

> [!Note]
> As of right now, this config is somewhat experimental but functional as changes are undergoing onl the fly, the code is a mess rn (I'm trying my best to clean that). Any issues that I tackle, I try to fix them asap.
> However if you try out this setup (which is greatly appreciated) and encounter any issues, I'd be more than happy to fix them up. PR's are more than welcomed.

# SHOWCASE
![image](https://github.com/user-attachments/assets/ae4418d4-3f5a-430f-ba7a-23181e05c2e4)
![image](https://github.com/user-attachments/assets/e9eace77-fc08-4cfc-87c7-b115913fee6e)
![image](https://github.com/user-attachments/assets/3ea0ad23-76eb-4aae-b1c5-49b2f7c25b83)
![image](https://github.com/user-attachments/assets/f13a2d7e-517c-4792-b2d9-096b52d11639)
![image](https://github.com/user-attachments/assets/0501a297-2e16-4fff-bc58-a6345cd72268)





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

# Features
1. Home baked statusline ( ~500 loc ) and tabline ( ~500 loc) with minimalism and aesthetics in mind, however not configurable (yet?).
2. Reasonable defaults for newbies like me.
3. [lazy.nvim](https://github.com/folke/lazy.nvim) for plugin management.
4. Customized dashboard with [dashboard.nvim](https://github.com/nvimdev/dashboard.nvim).
