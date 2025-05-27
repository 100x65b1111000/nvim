local M = {}

---@param str string?
M.get_sign_type = function(str)
	str = str or ""
	return str:match("GitSign") or str:match("Diagnostic")
end

M.get_folds = function(win, lnum)
	return vim.api.nvim_win_call(win, function()
		local foldlevel = vim.fn.foldlevel
		local fold_level = foldlevel(lnum)
		local is_fold_closed = vim.fn.foldclosed(lnum) == lnum and vim.fn.foldclosedend(lnum) ~= -1
		local is_fold_started = fold_level > foldlevel(lnum - 1)
		if is_fold_closed then
			return " %#Folded#%@v:lua.statuscolumn_click_fold_callback@ %T"
		elseif is_fold_started then
			return "%@v:lua.statuscolumn_click_fold_callback@  %T"
		end
		return ""
	end)

end

_G.statuscolumn_click_fold_callback = function()
	local pos = vim.fn.getmousepos()
	vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
	vim.api.nvim_win_call(pos.winid, function()
		if vim.fn.foldlevel(pos.line) > 0 then
			vim.cmd("normal! za")
		end
	end)
end

M.get_extmark_info = function(bufnr, lnum)

	local extmark_cache = vim.b[bufnr]._extmark_cache or {}

	if #extmark_cache > 0 and extmark_cache[lnum] ~= vim.NIL then -- setting a bufvar populates the missing indices with vim.NIL
		return extmark_cache
	end

	local signs = {}
	local extmarks = vim.api.nvim_buf_get_extmarks(bufnr, -1, 0, -1, { details = true, type = "sign" })

	for _, extmark in pairs(extmarks) do
		local line = extmark[2] + 1
		signs[line] = signs[line] or {}
		local extmark_details = assert(extmark[4])
		local name = extmark_details.sign_hl_group or extmark_details.sign_name
		local type = M.get_sign_type(name)
		table.insert(signs[line], {
			name = name,
			bufnr = bufnr,
			text = extmark_details.sign_text,
			type = type,
			text_hl = extmark_details.sign_hl_group,
			priority = extmark_details.priority,
		})
	end

	vim.api.nvim_buf_set_var(bufnr, "_extmark_cache", signs)

	return signs
end

M.get_git_sign = function(extmarks, bufnr)
	for _, i in ipairs(extmarks) do
		if i.bufnr == bufnr and i.type == "GitSign" then
			return string.format("%s%s%s%s%s ", "%#", i.text_hl, "#", i.text, "%*")
		end
	end
	return "   "
end

M.get_diagnostic_sign = function(extmarks, bufnr)
	for _, i in ipairs(extmarks) do
		if i.bufnr == bufnr and i.type == "Diagnostic" then
			return string.format("%s%s%s%s", "%#", i.text_hl, "#", i.text)
		end
	end
	return ""
end

M.right_sign = function (win, lnum, extmarks, bufnr)
	local str = M.get_diagnostic_sign(extmarks, bufnr)
	if str ~= "" then
		return string.format("%%3.3(%s%%)", str)
	end

	str = M.get_folds(win, lnum)
	if str ~= "" then
		return string.format("%%3.3(%s%%)", str)
	end

	return "%3.3(%)"
end

M.generate_extmark_string = function(win, lnum)
	if vim.v.virtnum ~= 0 then
		return ""
	end
	local bufnr = vim.api.nvim_win_get_buf(win)
	local extmarks = M.get_extmark_info(bufnr, lnum)[lnum] or {}
	local str = string.format(
		"%s%s%s",
		M.get_git_sign(extmarks, bufnr),
		"%l%=",
		M.right_sign(win, lnum, extmarks, bufnr)
	)
	return str
end

M.set_statuscolumn = function()
	local lnum = vim.v.lnum
	local win = vim.g.statusline_winid
	return M.generate_extmark_string(win, lnum)
end

return M
