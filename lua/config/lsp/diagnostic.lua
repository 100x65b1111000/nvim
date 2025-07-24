local d_config = vim.diagnostic.config
local severity = vim.diagnostic.severity

local diagnostic_signs = {
	[severity.ERROR] = " ",
	[severity.WARN] = " ",
	[severity.INFO] = " ",
	[severity.HINT] = " ",
}
local augroup = vim.api.nvim_create_augroup("LspDiagnosticSetup", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = augroup,
	callback = function()
		vim.schedule(function()
			d_config({
				signs = {
					text = {
						[severity.ERROR] = " ",
						[severity.WARN] = " ",
						[severity.INFO] = " ",
						[severity.HINT] = " ",
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
						max = severity.ERROR,
						min = severity.HINT,
					},
				},
				virtual_text = false and {
					severity = {
						max = 1,
						min = 4,
					},
					prefix = "󰹞",
					format = function(diagnostic)
						return diagnostic.message
					end,
					source = "if_many",
				},
				virtual_lines = {
					current_line = true,
					format = function(diagnostic)
						return string.format(
							"%s %s [%s]",
							diagnostic_signs[diagnostic.severity],
							diagnostic.message,
							diagnostic.code
						)
					end,
				},
				float = {
					source = "if_many",
					focusable = true,
					prefix = function(diagnostic, i, _)
						local opts = {}
						if diagnostic.severity == 1 then
							opts = { i .. ". " .. "  ", "DiagnosticError" }
						elseif diagnostic.severity == 2 then
							opts = { i .. ". " .. "  ", "DiagnosticWarn" }
						elseif diagnostic.severity == 3 then
							opts = { i .. ". " .. "  ", "DiagnosticInfo" }
						elseif diagnostic.severity == 4 then
							opts = { i .. ". " .. "  ", "DiagnosticHint" }
						end
						return opts[1], opts[2]
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
		end)
	end,
})

-- vim.api.nvim_create_augroup("FloatDiagnostic", { clear = true })
-- vim.api.nvim_create_autocmd({ "CursorHold" }, {
-- 	group = "FloatDiagnostic",
-- 	callback = function()
-- 		vim.schedule(function()
-- 			local line = vim.api.nvim_win_get_cursor(vim.api.nvim_get_current_win())
-- 			local diagnostics = vim.diagnostic.get(vim.api.nvim_get_current_buf(), { lnum = line[1] - 1 })
-- 			if not next(diagnostics) then
-- 				return
-- 			end
-- 			---@type vim.diagnostic.Opts.Float
-- 			local win_opts = {
-- 				scope = 'buffer',
-- 			}
-- 			vim.diagnostic.open_float()
-- 		end)
-- 	end,
-- })
