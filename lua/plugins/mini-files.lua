---@type LazySpec
local P = {
	"echasnovski/mini.files",
	lazy = true,
	enabled = true,
}
-- Define the toggle function for mini.files
function ToggleMiniFiles()
	local MiniFiles = require("mini.files")
	local file_path = vim.api.nvim_buf_get_name(vim.api.nvim_get_current_buf())
	local buftype = vim.api.nvim_get_option_value("buftype", { buf = vim.api.nvim_get_current_buf() })
	if buftype ~= "" or "" == file_path or not vim.uv.fs_stat(file_path) then
		if "" ~= file_path then
			file_path = vim.fn.fnamemodify(file_path, ":h")
		else
			file_path = vim.fn.getcwd(0)
		end
	end
	if not MiniFiles.close() then
		MiniFiles.open(file_path)
	end
end

P.init = function()
	vim.api.nvim_create_autocmd("BufEnter", {
		group = vim.api.nvim_create_augroup("MiniFiles_start_with_directory", { clear = true }),
		desc = "Start MiniFiles with directory",
		once = true,
		callback = function()
			if package.loaded["mini.files"] then
				return
			else
				local stats = vim.uv.fs_stat(vim.fn.argv(0))
				if stats and stats.type == "directory" then
					vim.defer_fn(function()
						ToggleMiniFiles()
					end, 1) -- prevent mini.files from losing focus
				end
			end
		end,
	})
end

P.dependencies = {
	"echasnovski/mini.icons",
}

P.keys = {
	{
		"<leader>e",
		function()
			ToggleMiniFiles()
		end,
		desc = "Toggle mini-files explorer",
	},
}

P.config = function()
	require("mini.files").setup({
		mappings = {
			close = "q",
			go_in = "L",
			go_in_plus = "l",
			go_out = "H",
			go_out_plus = "h",
			mark_goto = "'",
			mark_set = "m",
			reset = "<BS>",
			reveal_cwd = "@",
			show_help = "g?",
			synchronize = "s",
			trim_left = "<",
			trim_right = ">",
		},

		-- General options
		options = {
			-- Whether to delete permanently or move into module-specific trash
			permanent_delete = false,
			-- Whether to use for editing directories
			use_as_default_explorer = false,
		},

		-- Customization of explorer windows
		windows = {
			-- Maximum number of windows to show side by side
			max_number = math.huge,
			-- Whether to show preview of file/directory under cursor
			preview = true,
			-- Width of focused window
			width_focus = 50,
			-- Width of non-focused window
			width_nofocus = 20,
			-- Width of preview window
			width_preview = 100,
		},
	})

	vim.keymap.set(
		"n",
		"<leader>e",
		":lua ToggleMiniFiles()<CR>",
		{ desc = "Mini files explorer", noremap = true, silent = true }
	)

	-- toggle dotfiles(from mini.files wiki)
	local show_dotfiles = true

	local filter_show = function()
		return true
	end

	local filter_hide = function(fs_entry)
		return not vim.startswith(fs_entry.name, ".")
	end

	local toggle_dotfiles = function()
		show_dotfiles = not show_dotfiles
		local new_filter = show_dotfiles and filter_show or filter_hide
		MiniFiles.refresh({ content = { filter = new_filter } })
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local buf_id = args.data.bufid
			vim.keymap.set("n", "g.", toggle_dotfiles, { desc = "Toggle hidden files", buffer = buf_id })
			-- vim.wo[args.data.win_id].number = true
		end,
	})

	-- Set focused directory as current working directory
	local set_cwd = function()
		local path = (MiniFiles.get_fs_entry() or {}).path
		if path == nil then
			return vim.notify("Cursor is not on valid entry")
		end
		vim.fn.chdir(vim.fs.dirname(path))
	end

	-- Yank in register full path of entry under cursor
	local yank_path = function()
		local path = (MiniFiles.get_fs_entry() or {}).path
		if path == nil then
			return vim.notify("Cursor is not on valid entry")
		end
		vim.fn.setreg(vim.v.register, path)
	end

	-- Open path with system default handler (useful for non-text files)
	local ui_open = function()
		vim.ui.open(MiniFiles.get_fs_entry().path)
	end

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesBufferCreate",
		callback = function(args)
			local b = args.data.buf_id
			vim.keymap.set("n", "g/", set_cwd, { buffer = b, desc = "Set cwd" })
			vim.keymap.set("n", "go", ui_open, { buffer = b, desc = "OS open" })
			vim.keymap.set("n", "gy", yank_path, { buffer = b, desc = "Yank path" })
		end,
	})

	vim.api.nvim_create_autocmd("User", {
		pattern = "MiniFilesWindowOpen",
		callback = function(args)
			local win_id = args.data.win_id

			-- Customize window-local settings
			vim.wo[win_id].relativenumber = true
			local config = vim.api.nvim_win_get_config(win_id)
			config.border, config.title_pos = "single", "center"
			vim.api.nvim_win_set_config(win_id, config)
		end,
	})
end

return P
