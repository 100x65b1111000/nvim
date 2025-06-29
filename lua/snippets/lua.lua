local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function format node
---@param f function function node
M.make_lua_snippets = function(s, i, fmt, f)
	return {
		s(
			"localfunc",
			fmt("local {} = function({})\n\t{}\nend", { i(1, "func"), i(2, "args"), i(3, "-- do something") })
		),
		s(
			"localrequire",
			fmt(
				'local {} = require("{}{}")',
				{ i(1, "mod"), f(function(args)
					return args[1][1]
				end, { 1 }), i(2) }
			)
		),
		s(
			"ifelse",
			fmt(
				"if {} then\n\t{}\nelse\n{}\nend\n",
				{ i(1, "condition"), i(2, "-- do something"), i(3, "-- do something") }
			)
		),
		s(
			"ifelseif",
			fmt("if {} then\n\t{}\n\telseif {} then\n\t{}\nelse\n{}\nend\n", {
				i(1, "condition1"),
				i(2, "-- do something"),
				i(3, "condition2"),
				i(4, "-- do something"),
				i(5, "-- do something"),
			})
		),
		s("elseif", fmt("elseif {} then\n\t{}\n", { i(1, "condition"), i(2, "-- do something") })),
		s("function", fmt("function {}({})\n\t{}\nend\n", { i(1), i(2), i(3, "-- do something") })),
		s("foriin", fmt("for {}, {} do\n\t{}\nend\n", { i(1, "i = 1"), i(2, "10, 1"), i(3, "-- do something") })),
		s(
			"foripairs",
			fmt(
				"for {}, {} in ipairs({}) do\n\t{}\nend",
				{ i(1, "idx"), i(2, "val"), i(3, "table"), i(4, "-- do something") }
			)
		),
		s(
			"forpairs",
			fmt(
				"for {}, {} in pairs({}) do\n\t{}\nend\n",
				{ i(1, "key"), i(2, "val"), i(3, "table"), i(4, "-- do something") }
			)
		),
		s("lazypluginspec", fmt('local P = {\n\t"<>"\n}\n\nreturn P', { i(1, "author/plugin") }, { delimiters = "<>" })),
		s("whiledo", fmt("while {} do \n\t{}\nend\n", {i(1, "condition"), i(2, "-- do something")})),
		s("then", fmt("then\n\t{}", { i(1, "-- do something")})),
		s("thenend", fmt("then\n\t{}\nend", { i(1, "-- do something")})),
		s("do", fmt("do\n\t{}", { i(1, "-- do something")})),
		s("doend", fmt("do\n\t{}\nend", { i(1, "-- do something")}))
	}

end

return M
