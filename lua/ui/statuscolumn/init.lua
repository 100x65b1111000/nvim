local M = {}
local utils = require("ui.utils") -- Import the utils module

local reset_cache = function(bufnr)
	bufnr = bufnr or vim.api.nvim_get_current_buf()
	if vim.api.nvim_buf_is_valid(bufnr) then
		-- Resetting to nil is better as table comparison `extmark_cache[lnum]`
		-- in utils.lua will error if extmark_cache is {} but lnum is not a key.
		-- Setting to nil ensures it's correctly re-initialized.
		vim.api.nvim_buf_set_var(bufnr, "_extmark_cache", nil)
	end
end

local function debounce(fn, ms)
	local timer = nil -- This will now store the timer object returned by utils.timer_fn
	return function(...)
		local call_args = { ... }
		-- utils.timer_fn handles stopping the previous timer if 'timer' is passed to it.
		timer = utils.timer_fn(timer, ms, function()
			-- timer is implicitly nil here by utils.timer_fn design after callback
			-- or we can set timer = nil if we want to be explicit,
			-- though utils.timer_fn will create a new one next time regardless.
			fn(unpack(call_args))
		end)
	end
end

M.setup = function(opts)
	opts = opts or {}
	if not opts.enabled then
		vim.api.nvim_set_option_value("statuscolumn", "", {})
	else
		vim.api.nvim_create_augroup("StatusColumnRefresh", { clear = true })

		local immediate_refresh_callback = function(args)
			reset_cache(args.buf)
			vim.schedule(function()
				vim.cmd([[redrawstatus]])
			end)
		end

		local debounced_refresh_callback = debounce(function(args)
			reset_cache(args.buf)
			vim.schedule(function()
				vim.cmd([[redrawstatus]])
			end)
		end, 200) -- 200ms debounce delay

		-- Events that should trigger immediate refresh
		vim.api.nvim_create_autocmd({
			"BufWrite",
			"BufEnter",
			"FocusGained",
			"LspAttach",
			"DiagnosticChanged",
			"CursorHold",
		}, {
			group = "StatusColumnRefresh",
			callback = immediate_refresh_callback,
		})

		-- Events that should trigger debounced refresh
		vim.api.nvim_create_autocmd({
			"TextChanged",
			"TextChangedI",
		}, {
			group = "StatusColumnRefresh",
			callback = debounced_refresh_callback,
		})

		vim.api.nvim_set_option_value("statuscolumn", "%!v:lua.require('ui.statuscolumn.utils').set_statuscolumn()", {})
	end
end

return M
