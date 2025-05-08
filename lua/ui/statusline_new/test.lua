local M = {}

M.git_status = function()
	local parent = "/home/dex/.config/nvim"
	local output = nil
	local git_cmd = "git --no-pager --no-optional-locks --literal-pathspecs -c gc.auto= -C "
	local git_diff_cmd = git_cmd
		.. parent
		.. " status --short --porcelain "
		.. "/home/dex/.config/nvim/lua/ui/statusline_new/init.lua"
	vim.system({ "bash", "-c", git_diff_cmd }, { text = true }, function(out)
		vim.b.git_diff_out = out
	end)
	output = vim.b.git_diff_out
	output.stdout = output.stdout:gsub("([^%s]+)[\r\n]", "%1")
	return output
end

return M
