local P = {
	"stevearc/conform.nvim",
	lazy = true,
}

P.opts = function()
	return {
		formatters_by_ft = {
			lua = { "stylua" },
			python = { "ruff_format" },
			cpp = { "clang-format" },
			css = { "prettier" },
			json = { "prettier" },
			sh = { "shfmt" },
			bash = { "shfmt" },
		},
		default_format_opts = {
			lsp_format = "fallback",
		},
		format_on_save = function()
			if vim.g.autoformat_enabled then
				return { timeout_ms = 500, lsp_format = "fallback" }
			end
		end,
		formatters = { shfmt = { prepend_args = { "-i", "4" } } },
	}
end

P.init = function()
	-- vim.o.formatexpt = "v:lua.require'conform'.formatexpr()"
	vim.api.nvim_create_user_command("FormatToggle", function()
		if vim.g.autoformat_enabled then
			vim.g.autoformat_enabled = false
			vim.notify("Autoformat Disabled", vim.log.levels.INFO, { title = "Conform" })
		else
			vim.g.autoformat_enabled = true
			vim.notify("Autoformat Enabled", vim.log.levels.INFO, { title = "Conform" })
		end
	end, { desc = "Toggle Autoformat" })
end

return P
