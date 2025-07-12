local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
M.make_rust_snippets = function(s, i, fmt)
	return {
		s("fn", fmt("fn {}({}) -> {} {{\n\t{}\n}}", { i(1, "name"), i(2, "args"), i(3, "ret"), i(4, "## do something") })),
		s("let", fmt("let {} = {};", { i(1, "name"), i(2, "value") })),
		s("letmut", fmt("let mut {} = {};", { i(1, "name"), i(2, "value") })),
		s("if", fmt("if {} {{\n\t{}\n}}", { i(1, "condition"), i(2, "## do this") })),
		s(
			"ifelse",
			fmt("if {} {{\n\t{}\n}} else {{\n\t{}\n}}", { i(1, "condition"), i(2, "## do this"), i(3, "## else this") })
		),
		s("for", fmt("for {} in {} {{\n\t{}\n}}", { i(1, "i"), i(2, "iter"), i(3, "## do something") })),
		s("while", fmt("while {} {{\n\t{}\n}}", { i(1, "condition"), i(2, "## do something") })),
		s("main", fmt("fn main() {{\n\t{}\n}}", { i(1, "## do something") })),
		s("println", fmt("println!(\"{}\");", { i(1, "message") })),
	}
end

return M
