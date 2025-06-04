local d_config = vim.diagnostic.config
local severity = vim.diagnostic.severity
local augroup = vim.api.nvim_create_augroup("LspDiagnosticSetup", { clear = true })
vim.api.nvim_create_autocmd({ "LspAttach" }, {
	group = augroup,
	callback = function()
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
					max = "ERROR",
					min = "HINT",
				},
			},
			virtual_text = {
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
			virtual_lines = false,
			float = {
				source = "if_many",
				focusable = false,
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
				scope = "line",
				header = { " Diagnostics: ", "FloatTitle" },
				severity_sort = true,
				severity = {
					min = "HINT",
					max = "ERROR",
				},
				border = "none",
			},
			update_in_insert = false,
		})
	end,
})

vim.api.nvim_create_augroup("FloatDiagnostic", { clear = true }) 
vim.api.nvim_create_autocmd({ "CursorHold" }, {
	group = "FloatDiagnostic",
	callback = function()
		local wins = vim.api.nvim_list_wins()
		for _, i in ipairs(wins) do
			local win = vim.api.nvim_win_get_config(i)
			if win.zindex then
				return
			end
		end
		vim.diagnostic.open_float()
	end,
})
