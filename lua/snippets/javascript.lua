local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
M.make_javascript_snippets = function(s, i, fmt)
	return {
		s("log", fmt("console.log({});", i(1, "message"))),
		s("func", fmt("function {}({}) {{\n\t{}\n}}", { i(1, "name"), i(2, "args"), i(3, "## do something") })),
		s("if", fmt("if ({}) {{\n\t{}\n}}", { i(1, "condition"), i(2, "## do this") })),
		s(
			"ifelse",
			fmt("if ({}) {{\n\t{}\n}} else {{\n\t{}\n}}", { i(1, "condition"), i(2, "## do this"), i(3, "## else this") })
		),
		s("for", fmt("for (let {} = 0; {} < {}; {}++) {{\n\t{}\n}}", { i(1, "i"), i(1), i(2, "n"), i(1), i(3, "## do something") })),
		s("while", fmt("while ({}) {{\n\t{}\n}}", { i(1, "condition"), i(2, "## do something") })),
	}
end

return M
