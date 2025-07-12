local g = vim.g
local o = vim.o
local opt = vim.opt
local api = vim.api

g.loaded_netrw = 1
g.loaded_netrwPlugin = 1
o.tabstop = 4
o.shiftwidth = 4
o.number = true
o.updatetime = 300
o.relativenumber = true
o.undofile = true
o.backup = false
o.writebackup = false
o.clipboard = "unnamedplus"
o.swapfile = false
o.whichwrap = "<,>,[,],s,b"
g.copilot_no_tab_map = false
o.showtabline = 2
o.termguicolors = true
o.expandtab = false
o.incsearch = true -- Makes search act like search in modern browsers
o.inccommand = 'split'
o.showmatch = true -- show matching brackets when text indicator is over theme
o.smartindent = true
o.smarttab = true
o.wildignore =
	"*.docx,*.png,*.jpg,*.jpeg,*.gif,*.pdf,*.svg,*.mp4,*.mkv,*.avi,*.mp3,*.wav,*.ogg,*.zip,*.tar.gz,*.tar.bz2,*.tar.xz,*.tar.zst,*.rar,*.7z,*.exe,*.msi,*.apk,*.iso,*.img,*.bin,*.db,*.sqlite,*.db3,*.sql,*.dbf,*.mdb,*.log,*.cache,*.tmp,*.temp,*.o,*.obj,*.dll,*.class,*.pyc,*.pyo,*.rbc,*.jar,*.war,*.ear,*.sar"
o.splitright = true -- Vertical splits will automatically be to the right
o.background = "dark" -- tell vim what the background color looks like
o.wrap = false
o.title = true
o.spell = false
o.cursorlineopt = "line,number"
o.cursorline = true
o.cursorcolumn = false
-- o.completeopt = "menu,menuone,preview,popup,fuzzy"

o.list = true
o.listchars = "tab:  ,eol:,space: ,extends:"

o.scrolloff = 10
o.sidescrolloff = 10
o.ignorecase = true
o.smartcase = true
o.laststatus = 3
o.cmdheight = 0
o.foldopen = "hor,insert,percent,search,undo"
o.foldminlines = 2
o.foldmethod = "manual"
o.formatexpr = "v:lua.require'conform'.formatexpr()"

o.undodir = vim.fn.stdpath("cache") .. "/undo"

api.nvim_create_augroup("AutoSave", {
	clear = true,
})

api.nvim_create_autocmd({ "FocusLost", "InsertLeave" }, {
	group = "AutoSave",
	desc = "AutoSave file",
	callback = function()
		if vim.bo.modified and vim.bo.modifiable and not vim.bo.readonly and vim.bo.buftype == "" then
			vim.schedule(function()
				vim.cmd("w")
			end)
		end
	end,
})

api.nvim_create_autocmd("TextYankPost", {
	callback = function()
		vim.highlight.on_yank({ higroup = "IncSearch", timeout = 250 })
	end,
})

local cmdlineToggleGroup = api.nvim_create_augroup("UserCmdlineToggle", { clear = true })

api.nvim_create_autocmd("CmdlineEnter", {
	group = cmdlineToggleGroup,
	pattern = "*",
	callback = function()
		o.cmdheight = 1
	end,
})

api.nvim_create_autocmd("CmdlineLeave", {
	group = cmdlineToggleGroup,
	pattern = "*",
	callback = function()
		o.cmdheight = 0
	end,
})

-- local smart_help = function()
--     if o.columns > 80 then
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
	local start = api.nvim_buf_get_lines(0, vim.v.foldstart - 1, vim.v.foldstart, false)[1]
	local end_str = api.nvim_buf_get_lines(0, vim.v.foldend - 1, vim.v.foldend, false)[1]
	local end_ = vim.trim(end_str)
	local result = {}
	fold_virt_text(result, start, vim.v.foldstart - 1)
	table.insert(result, { " ... ", "Delimiter" })
	fold_virt_text(result, end_, vim.v.foldend - 1, #(end_str:match("^(%s+)") or ""))
	return result
end

opt.fillchars = "fold: "
opt.foldtext = "v:lua.custom_foldtext()"

-- api.nvim_create_user_command("TabNew", function()
-- 	local bufnr = api.nvim_get_current_buf()
-- 	if bufnr == -1 then
-- 		vim.cmd("tabnew")
-- 	else
-- 		vim.cmd("tab split")
-- 	end
-- end, {})
--

for _, plugin in pairs({
	"netrwFileHandlers",
	"getscript",
	"getscriptPlugin",
	"vimball",
	"vimballPlugin",
	"2html_plugin",
	"logipat",
	"rrhelper",
	"spellfile_plugin",
	"matchit",
}) do
	g["loaded_" .. plugin] = 1
end
