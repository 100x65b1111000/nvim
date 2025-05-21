vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.scrolloff = 8
vim.o.number = true
vim.o.updatetime = 300
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.swapfile = false
vim.o.whichwrap = "<,>,[,],s,b"
vim.o.showtabline = 2
vim.o.termguicolors = true
vim.o.expandtab = false
vim.o.incsearch = true -- Makes search act like search in modern browsers
vim.o.showmatch = true -- show matching brackets when text indicator is over theme
vim.o.smartindent = true
vim.o.smarttab = true
vim.o.wildignore =
	"*.docx,*.png,*.jpg,*.jpeg,*.gif,*.pdf,*.svg,*.mp4,*.mkv,*.avi,*.mp3,*.wav,*.ogg,*.zip,*.tar.gz,*.tar.bz2,*.tar.xz,*.tar.zst,*.rar,*.7z,*.exe,*.msi,*.apk,*.iso,*.img,*.bin,*.db,*.sqlite,*.db3,*.sql,*.dbf,*.mdb,*.log,*.cache,*.tmp,*.temp,*.o,*.obj,*.dll,*.class,*.pyc,*.pyo,*.rbc,*.jar,*.war,*.ear,*.sar"
vim.o.splitright = true -- Vertical splits will automatically be to the right
vim.o.background = "dark" -- tell vim what the background color looks like
vim.o.wrap = false
vim.o.title = true
vim.o.spell = false
vim.o.cursorlineopt = "line,number"
vim.o.cursorline = true
-- vim.o.completeopt = "menu,menuone,preview,popup,fuzzy"

vim.o.list = true
vim.o.listchars = "tab:  ,eol:,space: ,extends:"

vim.o.scrolloff = 10
vim.o.sidescrolloff = 10
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.laststatus = 3
vim.o.cmdheight = 1

vim.o.undodir = vim.fn.stdpath("cache") .. "/undo"

vim.api.nvim_create_augroup("AutoSave", {
	clear = true,
})
vim.api.nvim_create_autocmd({ "FocusLost", "InsertLeave" }, {
	group = "AutoSave",
	desc = "Replicate the auto save feature in some text editors",
	callback = function(args)
		if vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly and vim.bo.buftype == "" then
			vim.schedule(function ()
				vim.cmd("w")
			end)
		end
	end,
})

vim.api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 250 })
	end,
})

vim.api.nvim_create_autocmd("VimLeave", {
	group = vim.api.nvim_create_augroup("SetCursor", {
		clear = true,
	}),
	once = true,
	callback = function()
		vim.opt.guicursor = "a:hor20,a:blinkwait500-blinkoff400-blinkon250"
	end,
})

-- The following section for 'UserCmdlineToggle' (CmdlineEnter/CmdlineLeave autocommands)
-- is currently commented out. You can uncomment it if you wish to enable the feature
-- that automatically adjusts cmdheight, or remove this block if it's no longer needed.
-- local cmdlineToggleGroup = vim.api.nvim_create_augroup("UserCmdlineToggle", { clear = true })
--
-- vim.api.nvim_create_autocmd("CmdlineEnter", {
-- 	group = cmdlineToggleGroup,
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.o.cmdheight = 1
-- 	end,
-- })
--
-- vim.api.nvim_create_autocmd("CmdlineLeave", {
-- 	group = cmdlineToggleGroup,
-- 	pattern = "*",
-- 	callback = function()
-- 		vim.o.cmdheight = 0
-- 	end,
-- })
--
-- The following 'smart_help' function, which aimed to open help in a vertical split
-- if the screen is wide enough, is currently commented out. You can uncomment it
-- if you wish to enable this feature, or remove this block if it's no longer needed.
-- Note: You would also need to map this function to a keybinding for it to be useful.
-- local smart_help = function()
--     if vim.o.columns > 80 then
--         vim.cmd [[ vert help ]]
--     else
--         vim.cmd[[ help ]]
--     end
-- end
