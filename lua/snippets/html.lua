local M = {}

---@param s function snippet node
---@param i function insert node
---@param fmt function
M.make_html_snippets = function(s, i, fmt)
	return {
		s("!doctype", fmt("<!DOCTYPE html>\n<html lang=\"en\">\n<head>\n\t<meta charset=\"UTF-8\">\n\t<title>{}</title>\n</head>\n<body>\n\t{}\n</body>\n</html>", { i(1, "Title"), i(2) })),
		s("div", fmt("<div>\n\t{}\n</div>", i(1))),
		s("p", fmt("<p>{}</p>", i(1))),
		s("a", fmt("<a href=\"{}\">{}</a>", { i(1, "url"), i(2, "text") })),
		s("img", fmt("<img src=\"{}\" alt=\"{}\">", { i(1, "src"), i(2, "alt") })),
	}
end

return M
