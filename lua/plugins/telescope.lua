---@type LazyPluginSpec
local M = {
	"nvim-telescope/telescope.nvim",
	enabled = false,
	dependencies = {
		"nvim-lua/plenary.nvim",
		{ "nvim-telescope/telescope-fzf-native.nvim", build = "make" },
	},
}

M.config = function()
	local actions = require("telescope.actions")

	require("telescope").setup({
		defaults = {
			mappings = {
				i = {
					["<m-j>"] = actions.move_selection_next,
					["<m-k>"] = actions.move_selection_previous,
				},
			},
			vimgrep_arguments = {
				"rg",
				"--color=never",
				"--no-heading",
				"--with-filename",
				"--line-number",
				"--column",
				"--ignore-case",
				"--trim",
			},
			selection_strategy = "row",
			layout_strategy = "horizontal",
			layout_config = {
				prompt_position = "top",
			},
			cycle_layout_list = "vertical",
			prompt_prefix = " ",
			entry_prefix = "▍ ",
			selection_caret = "▍",
			multi_icon = "+",
			initial_mode = "insert",
			border = true,
			path_display = {
				"absolute",
			},
			dynamic_preview_title = false,
			preview = {
				check_mime_type = true,
				filesize_limit = 25,
				treesitter = true,
			},
		},
		pickers = {
			find_files = {
				hidden = true,
			},
		},
		extensions = {
			fzf = {
				fuzzy = true,
				override_generic_sorter = true,
				override_file_sorter = true,
				case_mode = "ignore_case",
			},
		},
	})

	require("telescope").load_extension("fzf")
end

M.keys = function()
	local picker = require("telescope.builtin")
	return {
		{
			"<leader>fg",
			function()
				picker.live_grep({
					cwd = require("config.lsp.lsputils").find_root({ ".git" }, true),
					additional_args = { "--vimgrep" },
				})
			end,
			desc = "Live Grep",
		},
		{
			"<leader>ff",
			function()
				picker.find_files()
			end,
			desc = "Find Files",
		},
		{
			"<leader>fb",
			function()
				picker.buffers()
			end,
			desc = "Find Buffers",
		},
		{
			"<leader>fli",
			function()
				picker.lsp_implementations()
			end,
			desc = "Find LSP Implementations",
		},
		{
			"<leader>fls",
			function()
				picker.lsp_document_symbols()
			end,
			desc = "Find LSP Symbols",
		},
		{
			"<leader>fd",
			function()
				picker.diagnostics()
			end,
			desc = "Diagnostics picker(buffer)",
		},
		{
			"<leader>fh",
			function()
				picker.help_tags()
			end,
			desc = "Find Help Pages",
		},
		{
			"<leader>fc",
			function()
				picker.colorscheme()
			end,
			desc = "Pick Colorschemes",
		},
		{
			"<leader>fH",
			function()
				picker.highlights()
			end,
			desc = "Find hl_groups",
		},
	}
end
return M
