vim.g.loaded_netrw = 1
vim.g.loaded_netrwPlugin = 1
vim.o.tabstop = 4
vim.o.shiftwidth = 4
vim.o.number = true
vim.o.updatetime = 300
vim.o.relativenumber = true
vim.o.undofile = true
vim.o.backup = false
vim.o.clipboard = "unnamedplus"
vim.o.swapfile = false
vim.o.whichwrap = "<,>,[,],s,b"
vim.g.copilot_no_tab_map = false
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

-- vim.o.scrolloff = 10
-- vim.o.sidescrolloff = 10
vim.o.ignorecase = true
vim.o.smartcase = true
vim.o.laststatus = 3
vim.o.cmdheight = 1
vim.o.foldopen = "hor,insert,percent,search,undo"
vim.o.foldminlines = 2
vim.o.foldmethod = "manual"

vim.o.undodir = vim.fn.stdpath("cache") .. "/undo"

vim.api.nvim_create_augroup("AutoSave", {
	clear = true,
})
vim.api.nvim_create_autocmd({ "FocusLost", "InsertLeave" }, {
	group = "AutoSave",
	desc = "Replicate the auto save feature in some text editors",
	callback = function(args)
		if vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly and vim.bo.buftype == "" then
			vim.schedule(function()
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
-- local smart_help = function()
--     if vim.o.columns > 80 then
--         vim.cmd [[ vert help ]]
--     else
--         vim.cmd[[ help ]]
--     end
-- end
--
_G.init_files = { "init.lua", "main.c", "main.cpp", "init.py", "__init__.py" }

local function fold_virt_text(result, s, lnum, coloff)
	if not coloff then
		coloff = 0
	end
	local text = ""
	local hl
	for i = 1, #s do
		local char = s:sub(i, i)
		local hls = vim.treesitter.get_captures_at_pos(0, lnum, coloff + i - 1)
		local _hl = hls[#hls]
		if _hl then
			local new_hl = "@" .. _hl.capture
			if new_hl ~= hl then
				table.insert(result, { text, hl })
				text = ""
				hl = nil
			end
			text = text .. char
			hl = new_hl
		else
			text = text .. char
		end
	end
	table.insert(result, { text, hl })
end

function _G.custom_foldtext()
	local start = vim.api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, false)[1]
	local end_str =vim.api.nvim_buf_get_lines(0, vim.v.foldend - 1, vim.v.foldend, false)[1]
	local end_ = vim.trim(end_str)
	local result = {}
	fold_virt_text(result, start, vim.v.foldstart - 1)
	table.insert(result, { " ... ", "Delimiter" })
	fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match("^(%s+)") or ""))
	return result
end

vim.opt.fillchars = "fold: "
-- vim.opt.foldtext = "v:lua.custom_foldtext()"
