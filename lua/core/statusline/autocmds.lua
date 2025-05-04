local utils = require("core.statusline.utils")
local buf_is_valid = utils.buf_is_valid
local git_parent = utils.git_parent

vim.api.nvim_create_augroup("StatusLineGitModule", { clear = true })
vim.api.nvim_create_autocmd({ "BufWritePost", "BufEnter", "BufReadPost", "InsertLeave", "BufAdd" }, {
	group = "StatusLineGitModule",
	callback = function(args)
		local file_path = vim.fn.expand("%:p")
		if buf_is_valid(args.buf) and git_parent(vim.fn.expand(file_path)) then
			require("core.statusline.utils").stl_git_cwd(file_path)
			vim.b.stl_file_git_status = require("core.statusline.utils").fetch_file_git_stat(file_path)
			vim.b.stl_git_branch = require("core.statusline.utils").git_branch(file_path)
		end
	end,
})

vim.api.nvim_create_augroup("StatusLineLspInfo", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach"}, {
	group = "StatusLineLspInfo",
	callback = function(args)
		if buf_is_valid(args.buf) then
			vim.b.stl_lsp_info = utils.stl_lsp_info()
		end
	end,
})

vim.api.nvim_create_augroup("StatusLineDiagnostics", { clear = true })
vim.api.nvim_create_autocmd({"DiagnosticChanged", "InsertLeave"}, {
	group = "StatusLineDiagnostics",
	callback  = function (args)
		vim.b.stl_diagnostics_info = utils.update_diagnostics(args.buf)
	end
})
