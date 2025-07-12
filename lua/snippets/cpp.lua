local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
M.make_cpp_snippets = function(s, i, fmt)
	return {
		s("include", fmt("#include <{}>", i(1, "iostream"))),
		s("main", fmt("int main() {{\n\t{}\n\treturn 0;\n}}", i(1, "## do something"))),
		s("cout", fmt("std::cout << {} << std::endl;", i(1, "\"Hello, World!\""))),
		s("for", fmt("for (int {} = 0; {} < {}; ++{}) {{\n\t{}\n}}", { i(1, "i"), i(1), i(2, "n"), i(1), i(3, "## do something") })),
		s("if", fmt("if ({}) {{\n\t{}\n}}", { i(1, "condition"), i(2, "## do this") })),
		s(
			"ifelse",
			fmt("if ({}) {{\n\t{}\n}} else {{\n\t{}\n}}", { i(1, "condition"), i(2, "## do this"), i(3, "## else this") })
		),
	}
end

return M
