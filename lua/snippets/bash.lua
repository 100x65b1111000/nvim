local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
M.make_bash_snippets = function(s, i, fmt)
	return {
		s("shebang", fmt("#!/bin/bash\n{}", i(1))),
		s("if", fmt("if [ {} ]; then\n\t{}\nfi", { i(1, "condition"), i(2, "## do this") })),
		s(
			"ifelse",
			fmt("if [ {} ]; then\n\t{}\nelse\n\t{}\nfi", { i(1, "condition"), i(2, "## do this"), i(3, "## else this") })
		),
		s("for", fmt("for {} in {}; do\n\t{}\ndone", { i(1, "i"), i(2, "list"), i(3, "## do something") })),
		s("while", fmt("while [ {} ]; do\n\t{}\ndone", { i(1, "condition"), i(2, "## do something") })),
		s("func", fmt("function {}() {{\n\t{}\n}}", { i(1, "name"), i(2, "## do something") })),
	}
end

return M
