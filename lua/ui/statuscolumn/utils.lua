local M = {}


MAX_LEN = 3
---@param str string?
M.get_sign_type = function(str)
	return (str or ""):match("GitSign") or (str or ""):match("Diagnostic") or ""
end

M.get_folds = function(win, lnum)
	local fold_str = ""
	vim.api.nvim_win_call(win, function()
		local foldlevel = vim.fn.foldlevel
		local fold_level = foldlevel(lnum)
		local is_fold_closed = vim.fn.foldclosed(lnum) == lnum and vim.fn.foldclosedend(lnum) ~= -1
		local is_fold_started = fold_level > foldlevel(lnum - 1)
		if is_fold_closed then
			fold_str = string.format("%s%s", fold_str, " ")
		elseif is_fold_started then
			fold_str = string.format("%s%s", fold_str, " ")
		end
	end)

	return fold_str
end

_G.statuscolumn_click_fold_callback = function()
	local pos = vim.fn.getmousepos()
	vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
	vim.api.nvim_win_call(pos.winid, function()
		vim.notify("I am gettin touched")
		if vim.fn.foldlevel(pos.line) > 0 then
			vim.cmd("normal! za")
		end
	end)
end

M.get_extmark_info = function(lnum)
	local bufnr = vim.api.nvim_get_current_buf()
	local extmark_cache = vim.b[bufnr]._extmark_cache or {}

	if #extmark_cache > 0 and extmark_cache[lnum] ~= vim.NIL then -- setting a bufvar populates the missing indices with vim.NIL
		return extmark_cache
	end

	local signs = {}
	local extmarks = vim.api.nvim_buf_get_extmarks(0, -1, 0, -1, { details = true, type = "sign" })

	for _, extmark in pairs(extmarks) do
		local line = extmark[2] + 1
		signs[line] = signs[line] or {}
		local name = extmark[4].sign_hl_group or extmark[4].sign_name
		table.insert(signs[line], {
			name = name,
			text = extmark[4].sign_text,
			type = M.get_sign_type(name),
			text_hl = extmark[4].sign_hl_group,
			priority = extmark[4].priority,
		})
	end

	vim.api.nvim_buf_set_var(bufnr, "_extmark_cache", signs)

	return signs
end

M.get_git_sign = function(extmarks)
	for _, i in ipairs(extmarks) do
		if i.type == "GitSign" then
			return string.format("%s%s%s%s%s ", "%#", i.text_hl, "#", i.text, "%*")
		end
	end
	return "   "
end

M.get_diagnostic_sign = function(extmarks)
	local diagnostic_string = ""
	for _, i in ipairs(extmarks) do
		if i.type == "Diagnostic" then
			diagnostic_string = string.format("%s%s%s %s", "%#", i.text_hl, "#", i.text)
		end
	end
	return diagnostic_string
end



M.generate_extmark_string = function(win, lnum)
	if vim.v.virtnum ~= 0 then
		return ""
	end
	local extmarks = M.get_extmark_info(lnum)[lnum] or {}
	local str = string.format(
		"%s%s%s%s%s",
		M.get_git_sign(extmarks),
		"%=%2.10l%=%3.3(",
		M.get_diagnostic_sign(extmarks),
		M.get_folds(win, lnum),
		"%)"
	)
	return str
end

M.set_statuscolumn = function()
	local lnum = vim.v.lnum
	local win = vim.g.statusline_winid
	return M.generate_extmark_string(win, lnum)
end

return M
