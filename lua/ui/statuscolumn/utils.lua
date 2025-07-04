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
			return "%#Folded#%@v:lua.statuscolumn_click_fold_callback@ %T"
		elseif is_fold_started then
			return "%@v:lua.statuscolumn_click_fold_callback@ %T"
		end
		return ""
	end)

end

_G.statuscolumn_click_fold_callback = function()
	local pos = vim.fn.getmousepos()
	if not vim.api.nvim_win_is_valid(pos.winid) then
		vim.notify("Error: Invalid window ID in statuscolumn_click_fold_callback", vim.log.levels.ERROR)
		return
	end
	vim.api.nvim_win_set_cursor(pos.winid, { pos.line, 1 })
	vim.api.nvim_win_call(pos.winid, function()
		if vim.fn.foldlevel(pos.line) > 0 then
			vim.cmd("normal! za")
		end
	end)
end

M.get_extmark_info = function(bufnr, lnum)
	local extmark_cache = vim.b[bufnr]._extmark_cache

	-- Check if cache is valid (not Lua nil and not vim.NIL) and has data for the current line.
	-- vim.NIL is a userdata that represents a variable explicitly set to nil by API.
	if extmark_cache ~= nil and extmark_cache ~= vim.NIL and extmark_cache[lnum] then
		return extmark_cache
	end

	-- If cache is nil, vim.NIL, or doesn't have data for this specific line, rebuild it.
	-- Initialize signs table. If extmark_cache was vim.NIL or nil, this is a fresh build.
	-- If extmark_cache was a table but missed lnum, we are also doing a fresh build for simplicity,
	-- as per original logic before vim.NIL handling.
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

	-- Store the entirely rebuilt signs table in the cache.
	-- This is simpler than trying to update incrementally and ensures freshness.
	vim.b[bufnr]._extmark_cache = signs

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
	local diagnostic_sign_str = M.get_diagnostic_sign(extmarks, bufnr)
	if diagnostic_sign_str ~= "" then
		return string.format("%%3.3(%s%%)", diagnostic_sign_str)
	end

	local fold_str = M.get_folds(win, lnum)
	if fold_str ~= "" then
		return string.format("%%3.3(%s%%)", fold_str)
	end

	return "%3.3(%)" -- Returns a 3-character wide empty string for alignment
end

M.generate_extmark_string = function(win, lnum)
	if vim.v.virtnum ~= 0 then
		return ""
	end
	local bufnr = vim.api.nvim_win_get_buf(win)
	local all_extmarks_for_buffer = M.get_extmark_info(bufnr, lnum)
	local extmarks_for_line = all_extmarks_for_buffer[lnum]

	-- If extmarks_for_line is nil (no entry for this line) or vim.NIL (explicitly set to nil via API),
	-- default to an empty table to prevent errors in subsequent functions expecting a table.
	if extmarks_for_line == nil or extmarks_for_line == vim.NIL then
		extmarks_for_line = {}
	end

	local str = string.format(
		"%s%%l%s",
		M.get_git_sign(extmarks_for_line, bufnr),
		M.right_sign(win, lnum, extmarks_for_line, bufnr)
	)
	return str
end

M.set_statuscolumn = function()
	local lnum = vim.v.lnum
	local win = vim.g.statusline_winid
	return M.generate_extmark_string(win, lnum)
end

return M
