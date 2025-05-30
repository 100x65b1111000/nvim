local borders = require("config.utils").borders
local float_win_opts = require("config.utils").float_win_opts
local M = {}

local function checkTriggerChars(triggerChars)
	local cur_line = vim.api.nvim_get_current_line()
	local dist = vim.api.nvim_win_get_cursor(0)[2]
	local prev_char = cur_line:sub(dist - 1, dist - 1)
	local current_char = cur_line:sub(dist, dist)

	for _, char in ipairs(triggerChars) do
		if current_char == char or prev_char == char then
			return true
		end
	end
end

local setup_signature_help = function(client, bufnr)
	local cmp_menu = require('blink.cmp').is_menu_visible
	local group = vim.api.nvim_create_augroup("LspSignature", { clear = true })
	---@type vim.lsp.buf.signature_help.Opts
	local signature_help_opts = {
		border = nil,
		anchor_bias = "above",
		focusable = true,
		max_width = 100,
		max_height = 10,
		relative = "cursor",
		focus = false,
		-- zindex = 999,
	}
	vim.api.nvim_clear_autocmds({ group = group, buffer = bufnr })
	local triggerChars = client.server_capabilities.signatureHelpProvider.triggerCharacters
	vim.api.nvim_create_autocmd("TextChangedI", {
		group = group,
		buffer = bufnr,
		callback = function(args)

			if checkTriggerChars(triggerChars) and not cmp_menu() then
				vim.lsp.buf.signature_help(signature_help_opts)
			end
		end,
	})
end

local setup_document_highlight = function(client)
	local group_dh = vim.api.nvim_create_augroup("document_highlight", { clear = true })
	vim.api.nvim_create_autocmd({ "CursorHold", "CursorHoldI" }, {
		group = group_dh,
		callback = function()
			if
				client:supports_method("textDocument/documentHighlight")
				and vim.fn.mode() == "n"
				and vim.bo.buftype == ""
			then
				vim.lsp.buf.document_highlight()
			end
		end,
		buffer = vim.api.nvim_get_current_buf(),
	})

	vim.api.nvim_create_autocmd({ "CursorMoved", "InsertEnter" }, {
		group = group_dh,
		callback = function()
			if client:supports_method("textDocument/documentHighlight") then
				vim.lsp.buf.clear_references()
			end
		end,
		buffer = vim.api.nvim_get_current_buf(),
	})
end

---@param root_patterns table|nil
---@param fallback boolean|string|nil
local find_root = function(root_patterns, fallback)
	local start = vim.fn.expand("%:p")
	if start == "" then
		start = vim.uv.cwd() or ""
	end

	if root_patterns then
		local matches = vim.fs.find(root_patterns or { ".git" }, {
			path = start,
			upward = true,
			stop = vim.env.HOME,
		})

		if #matches > 0 then
			local root = matches[1]
			if vim.fn.isdirectory(root) then
				root = root:match("(.*)/[^/]*$")
			end
			return vim.fn.fnamemodify(root, ":p:h")
		end
	end

	if fallback then
		return vim.fn.fnamemodify(start, ":p:h")
	end

	return start
end

local make_lsp_capabilities = function()
	return vim.tbl_deep_extend("force", vim.lsp.protocol.make_client_capabilities() or {}, {
		textDocument = {
			completion = {
				dynamicRegistration = false,
				completionItem = {
					snippetSupport = true,
					commitCharactersSupport = true,
					deprecatedSupport = true,
					preselectSupport = true,
					tagSupport = {
						valueSet = {
							1, -- Deprecated
						},
					},
					insertReplaceSupport = true,
					resolveSupport = {
						properties = {
							"documentation",
							"detail",
							"additionalTextEdits",
							"sortText",
							"filterText",
							"insertText",
							"textEdit",
							"insertTextFormat",
							"insertTextMode",
						},
					},
					insertTextModeSupport = {
						valueSet = {
							1, -- asIs
							2, -- adjustIndentation
						},
					},
					labelDetailsSupport = true,
				},
				contextSupport = true,
				insertTextMode = 1,
				completionList = {
					itemDefaults = {
						"commitCharacters",
						"editRange",
						"insertTextFormat",
						"insertTextMode",
						"data",
					},
				},
			},
		},
	})
end

local on_attach = function(client, bufnr)
	if client.server_capabilities.inlayHintProvider then
		vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())
	end

	vim.keymap.set(
		"n",
		"<leader>ld",
		":lua vim.lsp.buf.definition({ reuse_win = true })<CR>",
		{ desc = "Jump to definition", buffer = bufnr }
	)
	vim.keymap.set(
		"n",
		"<leader>lD",
		":lua vim.lsp.buf.type_definition({ reuse_win = true })<CR>",
		{ desc = "Jump to type definition", buffer = bufnr }
	)
	vim.keymap.set("n", "<leader>lh", function()
		vim.lsp.buf.hover(vim.tbl_extend("force", { border = borders.padded }, float_win_opts))
	end, { desc = "Show hover information", buffer = bufnr })
	vim.keymap.set(
		"n",
		"<leader>lc",
		":lua vim.lsp.buf.code_action()<CR>",
		{ desc = "Show code actions", buffer = bufnr }
	)
	vim.keymap.set({ "n", "v" }, "<leader>lF", function()
		require("conform").format({ async = false, lsp_fallback = true, timeout_ms = 500 })
	end, { desc = "Format the code", buffer = bufnr })
	vim.keymap.set(
		"n",
		"<leader>lI",
		":lua vim.lsp.inlay_hint.enable(not vim.lsp.inlay_hint.is_enabled())<CR>",
		{ desc = "Toggle lsp inlay hints", buffer = bufnr }
	)
	vim.keymap.set(
		"n",
		"<leader>li",
		":lua vim.lsp.buf.implementation()<CR>",
		{ desc = "Show implementations of the current word", buffer = bufnr }
	)
	vim.keymap.set(
		"n",
		"<leader>lr",
		":lua vim.lsp.buf.rename()<CR>",
		{ desc = "Rename all the instances of the symbol in the current buffer", buffer = bufnr }
	)
	vim.keymap.set(
		"n",
		"<leader>ls",
		":lua vim.lsp.buf.signature_help()<CR>",
		{ desc = "Open Signature Help", buffer = bufnr }
	)
	vim.keymap.set(
		"n",
		"<leader>ll",
		":lua vim.lsp.buf.declaration()<CR>",
		{ desc = "Jump to declaration", buffer = bufnr }
	)
	vim.keymap.set("n", "<leader>lf", function()
		vim.diagnostic.open_float()
	end, { desc = "Show float diagnostics" })

	if client.server_capabilities.signatureHelpProvider then
		setup_signature_help(client, bufnr)
	end

	if client.server_capabilities.documentHighlightProvider then
		setup_document_highlight(client)
	end
	--
	-- if client.name == "basedpyright" then
	-- 	client.server_capabilities.semanticTokensProvider = nil
	-- end

	-- if client:supports_method('textDocument/documentColor') then
	--   vim.lsp.document_color.enable(true)
	-- end
end

local load_lsp_configs = function(dir)
	vim.env.PATH = vim.env.PATH .. ":" .. vim.fn.stdpath("data") .. "/mason/bin"
	require("config.lsp.diagnostic")
	require("config.utils")

	local path = vim.fn.stdpath("config") .. "/lua/" .. dir

	-- Check if directory exists
	if vim.fn.isdirectory(path) == 0 then
		vim.notify("LSP configs directory not found: " .. path, vim.log.levels.WARN)
		return
	end

	local ok, files = pcall(vim.fn.readdir, path)
	if not ok then
		vim.notify("Failed to read LSP configs directory: " .. path, vim.log.levels.ERROR)
		return
	end

	local failed_configs = {}
	local loaded = 0

	for _, serverconf in ipairs(files) do
		serverconf = serverconf:gsub(".lua", "")
		local ok, err = pcall(require, "config.lsp.servers." .. serverconf)
		if not ok then
			table.insert(failed_configs, serverconf)
			vim.notify("Failed to load LSP config " .. serverconf .. ": " .. err, vim.log.levels.ERROR)
		else
			loaded = loaded + 1
		end
	end
	-- local load_lsp = vim.api.nvim_create_augroup('LspLoad', { clear = true })
	-- vim.api.nvim_create_autocmd({ 'BufWritePost' }, {
	--
	-- })
end

M.on_attach = on_attach
M.lsp_capabilities = make_lsp_capabilities()
M.find_root = find_root
M.load_lsp_configs = load_lsp_configs
M.default_server_config = {
	on_attach = function(client, bufnr)
		on_attach(client, bufnr)
	end,
	capabilities = make_lsp_capabilities(),
	root_markers = { ".git" },
	on_error = function(code, err)
		vim.notify("[LSP Error " .. code .. "]: " .. err, "error")
	end,
}

-- vim.diagnostic.config({
--     jump = {
--         wrap = true,
--
--     }
-- }, namespace?)

return M
