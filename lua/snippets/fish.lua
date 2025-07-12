local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
M.make_fish_snippets = function(s, i, fmt)
	return {
		s("if", fmt("if {}\n\t{}\nend", { i(1, "condition"), i(2, "## do this") })),
		s(
			"ifelse",
			fmt("if {}\n\t{}\nelse\n\t{}\nend", { i(1, "condition"), i(2, "## do this"), i(3, "## else this") })
		),
		s("for", fmt("for {} in {}\n\t{}\nend", { i(1, "i"), i(2, "list"), i(3, "## do something") })),
		s("while", fmt("while {}\n\t{}\nend", { i(1, "condition"), i(2, "## do something") })),
		s("func", fmt("function {}\n\t{}\nend", { i(1, "name"), i(2, "## do something") })),
	}
end

return M
