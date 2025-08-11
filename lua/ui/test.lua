local M = {}

local test1 = function()
	local substr1 = "this "
	local substr2 = "is "
	local substr3 = "a "
	local substr4 = "string"
	local str = string.format("%s%s%s%s", substr1, substr2, substr3, substr4)
end

local test2 = function()
	local substr1 = "this "
	local substr2 = "is "
	local substr3 = "a "
	local substr4 = "string"
	local tbl = {}
	table.insert(tbl, substr1)
	table.insert(tbl, substr2)
	table.insert(tbl, substr3)
	table.insert(tbl, substr4)
	local str = table.concat(tbl, "")
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
	print(string.format("time taken by test 1 = %0.6f sec", M.test(test1)))
	print(string.format("time taken by test 2 = %0.6f sec", M.test(test2)))
end

return M
