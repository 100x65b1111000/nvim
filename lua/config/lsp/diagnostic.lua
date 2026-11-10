local d_config = vim.diagnostic.config
local severity = vim.diagnostic.severity

local diagnostic_signs = {
	[severity.ERROR] = " ",
	[severity.WARN] = " ",
	[severity.INFO] = " ",
	[severity.HINT] = " ",
}

local diagnostic_hls = {
	[severity.ERROR] = "DiagnosticError",
	[severity.WARN] = "DiagnosticWarn",
	[severity.INFO] = "DiagnosticInfo",
	[severity.HINT] = "DiagnosticHint",
}

d_config({
	signs = {
		text = diagnostic_signs,
		severity = { max = 1, min = 4 },
		numhl = diagnostic_hls,
	},
	underline = {
		severity = { max = severity.ERROR, min = severity.HINT },
	},
	virtual_text = {
		severity = { max = 1, min = 4 },
		prefix = "󰹞",
		format = function(diagnostic)
			return tostring(diagnostic.code)
		end,
		source = "if_many",
	},
	virtual_lines = {
		current_line = true,
		format = function(diagnostic)
			return string.format(
				"%s %s [%s]",
				diagnostic_signs[diagnostic.severity] or "",
				diagnostic.message,
				diagnostic.code or ""
			)
		end,
	},
	float = {
		source = "if_many",
		focusable = true,
		prefix = function(diagnostic, i, _)
			local icon = diagnostic_signs[diagnostic.severity] or ""
			local hl = diagnostic_hls[diagnostic.severity] or "Normal"
			return i .. ". " .. icon .. " ", hl
		end,
		format = function(diagnostic)
			return string.format(
				"%s\n[%s-%s] -> [%s-%s]",
				diagnostic.message,
				diagnostic.col,
				diagnostic.lnum,
				diagnostic.end_col,
				diagnostic.end_lnum
			)
		end,
		scope = "line",
		header = { " Diagnostics: ", "FloatTitle" },
		severity_sort = true,
		severity = {
			min = severity.HINT,
			max = severity.ERROR,
		},
		border = "none",
	},
	update_in_insert = false,
})
