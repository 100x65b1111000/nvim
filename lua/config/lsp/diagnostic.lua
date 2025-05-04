local d_config = vim.diagnostic.config
local severity = vim.diagnostic.severity
d_config({
	jump = {
		count = 1,
		float = true,
		severity = {
			max = "ERROR",
			min = "WARN",
		},
	},
	signs = {
		text = {
			[severity.ERROR] = " ",
			[severity.WARN] = " ",
			[severity.INFO] = " ",
			[severity.HINT] = " ",
		},
		severity = {
			max = 1,
			min = 4,
		},
		numhl = {
			[severity.ERROR] = "DiagnosticError",
			[severity.WARN] = "DiagnosticaWarn",
			[severity.INFO] = "DiagnosticInfo",
			[severity.HINT] = "DiagnosticHint",
		},
	},
	underline = {
		severity = {
			max = "ERROR",
			min = "HINT",
		},
	},
	-- virtual_text = {
	-- 	severity = {
	-- 		max = 1,
	-- 		min = 4,
	-- 	},
	-- 	prefix = "󰹞 ",
	-- 	format = function(diagnostic)
	-- 		return diagnostic.message
	-- 	end,
	-- },
	-- virtual_text = true,
	virtual_lines = {
		current_line = true,
		format = function(diagnostic)
			local icons = {
				" ",
				" ",
				" ",
				" ",
			}
			return icons[diagnostic.severity] .. " " .. diagnostic.message
		end,
	},
	float = {
		source = "if_many",
		prefix = function(diagnostic, i, _)
			local opts = {}
			if diagnostic.severity == 1 then
				opts = { i .. ". " .. "[E] ", "DiagnosticError" }
			elseif diagnostic.severity == 2 then
				opts = { i .. ". " .. "[W] ", "DiagnosticWarn" }
			elseif diagnostic.severity == 3 then
				opts = { i .. ". " .. "[I] ", "DiagnosticInfo" }
			elseif diagnostic.severity == 4 then
				opts = { i .. ". " .. "[H] ", "DiagnosticHint" }
			end
			return opts[1], opts[2]
		end,
		scope = "cursor",
		header = { "Diagnostics: ", "FloatTitle" },
		severity_sort = true,
		severity = {
			min = "HINT",
			max = "ERROR",
		},
	},
	update_in_insert = false,
})

-- vim.api.nvim_create_augroup("FloatDiagnostic", { clear = true })
-- vim.api.nvim_create_autocmd()
