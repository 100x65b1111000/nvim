local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
---@param f function
M.make_python_snippets = function(s, i, fmt, f)
	return {
		s(
			"def",
			fmt(
				"def {}({}: {}) -> {}:\n\t{}\n",
				{ i(1, "func"), i(2, "arg"), i(3, "type"), i(4, "None"), i(5, "## do somemthing") }
			)
		),
		s(
			"forinrange",
			fmt("for {} in range({}, {}):\n\t{}\n", { i(1, "i"), i(2, "start"), i(3, "end"), i(4, "## do something") })
		),
		s("forin", fmt("for {} in {}:\n\t{}\n", { i(1, "i"), i(2, "iterable"), i(3, "## do something") })),
		s("while", fmt("while {}:\n\t{}\n", { i(1, "condition"), i(2, "## do something") })),
		s("if", fmt("if {}:\n\t{}\n", { i(1, "condition"), i(2, "## do this") })),
		s("elseif", fmt("elseif {}:\n\t{}\n", { i(1, "condition"), i(2, "## do this") })),
		s("else", fmt("else:\n\t{}\n", { i(1, "## do this") })),
		s(
			"ifelse",
			fmt("if {}:\n\t{}\n\telse:\n\t{}\n", { i(1, "condition"), i(2, "## do this"), i(3, "## else this") })
		),
		s(
			"ifelseif",
			fmt(
				"if {}:\n\t{}\n\telseif {}:\n\t{}\n",
				{ i(1, "condition1"), i(2, "## do this"), i(3, "condition2"), i(4, "##do this") }
			)
		),
		s(
			"ifelseifelse",
			fmt(
				"if {}:\n\t{}\n\telseif {}:\n\t{}\n\telse:\n\t{}\n",
				{ i(1, "condition1"), i(2, "## do this"), i(3, "condition2"), i(4, "## else this"), i(5, "## else this") }
			)
		),
		s("__name__main", fmt("if __name__ == \"__main__\":\n\t{}\n", {i(1, "main()")}))
	}
end

return M
