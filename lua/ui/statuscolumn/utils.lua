local M = {}

---@param str string?
M.get_sign_type = function(str)
	return (str or ""):match("GitSign") or (str or ""):match("Diagnostic") or ""
end

M.get_folds = function(lnum)
	local end_ = vim.api.nvim_buf_line_count(0)
	local hl = "%#FoldSign#"
	local foldlevel = vim.fn.foldlevel
	local fold_before = foldlevel(((lnum - 1) >= 1 and lnum - 1) or 0)
	local fold_after = foldlevel(((lnum + 1) <= end_ and lnum + 1) or 0)
	if foldlevel(lnum) == 0 then
		return ""
	end
	if vim.fn.foldclosed(lnum) == lnum and vim.fn.foldclosedend(lnum) ~= -1 then
		return "%#Folded#" .. " "
	end
	if foldlevel(lnum) > fold_before then
		return hl .. " "
	end
	if foldlevel(lnum) > fold_after then
		return hl .. " "
	end

	return hl .. "┆ "
end

-- Retrieves extmark information for the current buffer.
M.get_extmark_info = function(lnum)
	local bufnr = vim.api.nvim_get_current_buf()
	local current_buf_cache = vim.b[bufnr]._extmark_cache

	if current_buf_cache and next(current_buf_cache) ~= nil then
		return current_buf_cache
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
			type = M.get_sign_type(name), -- Assuming M is the module table
			text_hl = extmark[4].sign_hl_group,
			priority = extmark[4].priority,
		})
	end

	vim.api.nvim_buf_set_var(bufnr, '_extmark_cache', signs)
	return signs
end

M.get_git_sign = function(extmarks)
	for _, i in ipairs(extmarks) do
		if i.type == "GitSign" then
			return "%#" .. i.text_hl .. "#" .. "%-03.3(" .. i.text .. "%)" .. "%*"
		end
	end
	return "%-03.3( %)"
end

M.get_diagnostic_sign = function(extmarks)
	local diagnostic_string = "%03.3( %)"
	for _, i in ipairs(extmarks) do
		if i.type == "Diagnostic" then
			diagnostic_string = "%#" .. i.text_hl .. "#" .. "%03.3(" .. i.text .. "%)"
		end
	end
	return diagnostic_string
end

M.generate_extmark_string = function(lnum)
	if vim.v.virtnum ~= 0 then
		return ""
	end
	local extmarks = M.get_extmark_info(lnum)[lnum] or {}
	local str = M.get_git_sign(extmarks) .. "%=%2.10l%=" .. M.get_diagnostic_sign(extmarks) .. M.get_folds(lnum)
	return str
end

M.set_statuscolumn = function()
	local lnum = vim.v.lnum
	return M.generate_extmark_string(lnum)
end

return M
