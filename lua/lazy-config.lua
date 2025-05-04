-- Bootstrap lazy.nvim
local lazypath = vim.fn.stdpath("data") .. "/lazy/lazy.nvim"
if not (vim.uv or vim.loop).fs_stat(lazypath) then
	local lazyrepo = "https://github.com/folke/lazy.nvim.git"
	local out = vim.fn.system({ "git", "clone", "--filter=blob:none", "--branch=stable", lazyrepo, lazypath })
	if vim.v.shell_error ~= 0 then
		vim.api.nvim_echo({
			{ "Failed to clone lazy.nvim:\n", "ErrorMsg" },
			{ out, "WarningMsg" },
			{ "\nPress any key to exit..." },
		}, true, {})
		vim.fn.getchar()
		os.exit(1)
	end
end

vim.opt.rtp:prepend(lazypath)

-- Setup lazy.nvim
require("lazy").setup({
	spec = {
		-- import your plugins
		{ import = "plugins" },
	},
	-- Configure any other settings here. See the documentation for more details.
	-- colorscheme that will be used when installing plugins.
	install = { colorscheme = { "tokyonight-moon" } },
	-- automatically check for plugin updates
	checker = {
		enabled = true,
		notify = false,
	},

	performance = {
		disables_plugins = {
			"gzip",
			-- "matchit",
			-- "matchparen",
			"netrwPlugin",
			"tarPlugin",
			"tohtml",
			"tutor",
			"zipPlugin",
		},
	},

	change_detection = {
		enabled = true,
		notify = false,
	},

	pkg = {
		enabled = true,
		sources = {
			"lazy",
			"packspec",
		},
	},
	ui = {
		size = { width = 0.75, height = 0.70 },
		border = "single",
		backdrop = 50,
		title = "Plugins 󰐱",
	},
})

vim.keymap.set("n", "<leader>L", ":Lazy<CR>", { desc = "Open Lazy plugin manager" })
