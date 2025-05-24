local M = {}

local test1 = function()
      local utils = require("ui.statusline.utils")
      if utils.buf_is_file() then
           utils.fetch_diagnostics()
      end
end

local test2 = function()
      local utils = require("ui.statusline.utils")
      local buf_is_file = utils.buf_is_file
      local fetch_diagnostics = utils.fetch_diagnostics
      if buf_is_file() then
           fetch_diagnostics()
      end
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
	print("time taken = %.6f sec", M.test(test2))
	print("time taken = %.6f sec", M.test(test1))
end
return M
