local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
---@param f function
M.make_lua_snnippets = function(s, i, fmt, f)
	return {
		s(
			"localfunc",
			fmt("local {} = function({})\n\t{}\nend", { i(1, "var"), i(2, "args"), i(3, "-- do something") })
		),
		s(
			"localmod",
			fmt('local {} = require("{}")', { i(1, "mod"), f(function(args)
				return args[1][1]
			end, { 1 }) })
		),
	}
end
return M
