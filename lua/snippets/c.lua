local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
---@param f function
M.make_c_snippets = function(s, i, fmt)
	return {
		s(
			"ternary",
			fmt("<> ? <> : <>", {
				i(1, "cond"),
				i(2, "then"),
				i(3, "else"),
			}, { delimiters = "<>" })
		),
		s(
			"ifelse",
			fmt(
				"if (<>) {\n\t<>;\n} else {\n\t<>;\n}",
				{ i(1, "condition"), i(2, "// do something"), i(3, "//else") },
				{ delimiters = "<>" }
			)
		),
		s(
			"ifelseif",
			fmt("if (<>) {\n\t<>;\n} else if (<>) {\n\t<>;\n} else {\n\t<>;\n}", {
				i(1, "condition1"),
				i(2, "// do something"),
				i(3, "condition2"),
				i(4, "//do something"),
				i(5, "// do something"),
			}, { delimiters = "<>" })
		),
		s("elseif", fmt("elsif (<>) {\n\t<>;\n}", { i(1, "condition"), i(2, "// do this") }, { delimiters = "<>" })),
		s("while", fmt("while (<>) {\n\t<>\n}", { i(1, "expression"), i(2) }, { delimiters = "<>" })),
		s("dowhile", fmt("do {\n\t<>\n} while (<>)", { i(1), i(2, "expression") }, { delimiters = "<>" })),
		s("include", fmt("#include <{}.h>", { i(1) })),
		s(
			"for",
			fmt(
				"for (<>; <>; <>) {\n\t<>;\n}",
				{ i(1, "int i = 0"), i(2, "condition"), i(3, "inc-expression"), i(4, "// do something") },
				{ delimiters = "<>" }
			)
		),
		s(
			"intmain",
			fmt(
				"int main(int argc, char** argv) {\n\t<>;\n\treturn <>;\n}",
				{ i(1, "// do something"), i(2, "0") },
				{ delimiters = "<>" }
			)
		),
		s(
			"func",
			fmt(
				"void fun(<>){\n\t<>;\n\treturn <>;\n}",
				{ i(1, "..."), i(2, "// do something"), i(3, "") },
				{ delimiters = "<>" }
			)
		),
		-- s("trig", {
		-- 	i(1),
		-- 	t("<-i(1) "),
		-- 	f(
		-- 		fn, -- callback (args, parent, user_args) -> string
		-- 		{ 2 }, -- node indice(s) whose text is passed to fn, i.e. i(2)
		-- 		{ user_args = { "user_args_value" } } -- opts
		-- 	),
		-- 	t(" i(2)->"),
		-- 	i(2),
		-- 	t("<-i(2) i(0)->"),
		-- 	i(0),
		-- }),
	}
end

return M
