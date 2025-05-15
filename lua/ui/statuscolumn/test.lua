local M = {}

local test2 = function()
	local var = vim.api.nvim_strwidth("this is a text")
end

local test1 = function()
	local var = vim.fn.strwidth("this is a text")
end

M.test = function(fn, iterations)
	local start = os.clock()
	for _ = 1, (iterations or 1e5) do
		fn()
	end

	local end_ = os.clock()

	return end_ - start
end

M.print_results = function()
	print("time taken = %.6f sec", M.test(test1))
	print("time taken = %.6f sec", M.test(test2))
end
return M
