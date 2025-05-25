local P = {
	"Saghen/blink.cmp",
	cond = true,
	event = { "InsertEnter" },
	build = "cargo build --release",
}

P.dependencies = {
	"rafamadriz/friendly-snippets",
	{
		"L3MON4D3/LuaSnip",
		-- version = "v2.3.0",
		build = "make install_jsregexp",
		opts = function()
			local types = require("luasnip.util.types")
			vim.keymap.set({ "i", "s" }, "<Tab>", function()
				if require("luasnip").expandable() then
					require("luasnip").expand()
				else
					vim.api.nvim_feedkeys(vim.api.nvim_replace_termcodes("<Tab>", true, true, true), "n", true)
				end
			end)
			return {
				history = true,
				update_events = { "TextChanged", "TextChangedI" },
				enable_autosnippets = true,
				ext_opts = {
					[types.choiceNode] = {
						active = {
							virt_text = { { "<- ", "Error" } },
						},
					},
				},
			}
		end,
	},
	"echasnovski/mini.icons",
	-- { "Saghen/blink.compat", opts = { impersonate_nvim_cmp = true } },
}

P.config = function()
	local cmp = require("blink.cmp")
	local luasnip = require("luasnip")
	cmp.setup({
		enabled = function()
			return vim.tbl_contains({ "nofile", "prompt" }, vim.bo.buftype) == false
		end,
		keymap = {
			preset = nil,
			["<m-k>"] = { "select_prev", "fallback" },
			["<m-j>"] = { "show", "select_next", "fallback" },
			["<m-l>"] = {
				function()
					if cmp.snippet_active() then
						return cmp.snippet_forward()
					end
					return cmp.select_and_accept()
				end,
				"fallback",
			},
			["<CR>"] = {
				function()
					return cmp.select_and_accept({
						callback = function()
							cmp.show_signature()
						end,
					})
				end,
				"fallback",
			},
			["<m-h>"] = {
				"cancel",
				"snippet_backward",
				"fallback",
			},
			["<m-b>"] = { "scroll_documentation_down", "fallback" },
			["<m-f>"] = { "scroll_documentation_up", "fallback" },
			["<m-c>"] = { "show", "cancel", "fallback" },
			-- term = {
			-- 	["<tab>"] = { "select_next" },
			-- 	["<m-j>"] = { "select_next" },
			-- 	["<s-tab>"] = { "select_prev" },
			-- 	["<m-k>"] = { "select_prev" },
			-- },
		},
		snippets = {
			preset = "luasnip",
			expand = function(snippet)
				luasnip.lsp_expand(snippet)
			end,
			active = function(filter)
				if filter and filter.direction then
					return luasnip.expandable() or luasnip.jumpable(filter.direction)
				end
				return luasnip.in_snippet()
			end,
			jump = function(direction)
				if luasnip.jumpable(direction) then
					luasnip.jump(direction)
				end
			end,
		},
		completion = {
			keyword = {
				range = "full",
				-- regex = "[-_]\\|\\k",
				-- exclude_from_prefix_regex = "[\\-]",
			},
			trigger = {
				show_in_snippet = true,
				prefetch_on_insert = true,
				show_on_keyword = true,
				show_on_trigger_character = true,
				show_on_accept_on_trigger_character = true,
				show_on_insert_on_trigger_character = true,
				show_on_blocked_trigger_characters = {},
				show_on_x_blocked_trigger_characters = { "(", "'", '"' },
			},
			list = {
				max_items = 200,
				selection = {
					preselect = true,
					auto_insert = false,
				},
				cycle = {
					from_bottom = true,
					from_top = true,
				},
			},
			accept = {
				create_undo_point = true,
				auto_brackets = {
					enabled = vim.bo.buftype ~= "prompt",
					default_brackets = { "(", ")", "{", "}" },
					override_brackets_for_filetypes = {},
					kind_resolution = {
						enabled = true,
						blocked_filetypes = { ".txt" },
					},
					semantic_token_resolution = {
						enabled = true,
						blocked_filetypes = {},
						timeout_ms = 400,
					},
					blocked_filetypes = { ".txt" },
					force_allow_filetypes = {},
				},
			},
			menu = {
				enabled = true,
				min_width = 15,
				max_height = 10,
				border = "none",
				winblend = 0,
				winhighlight = "Normal:BlinkCmpMenu,FloatBorder:BlinkCmpMenuBorder,CursorLine:BlinkCmpMenuSelection,Search:None",
				scrollbar = true,
				scrolloff = 2,
				direction_priority = { "s", "n" },
				auto_show = true,
				draw = {
					align_to = "cursor",
					padding = 1,
					gap = 1,
					treesitter = { "lsp" },
					columns = {
						{ "kind_icon" },
						{ "label", "label_description", gap = 1 },
						{ "kind" },
					},

					components = {
						kind_icon = {
							ellipsis = false,
							text = function(ctx)
								-- local kind = ctx.kind
								-- dl
								-- local kind_icon, _, _ = require("mini.icons").get("lsp", kind)
								-- return kind_icon
								ctx.icon_gap = " "
								return ctx.kind_icon .. ctx.icon_gap
							end,
							highlight = function(ctx)
								return ctx.kind_hl
								-- local _, hl, _ = require('mini.icons').get('lsp', ctx.kind)
								-- return hl
							end,
						},
						kind = {
							ellipsis = false,
							width = { fill = true },
							text = function(ctx)
								return "<" .. ctx.kind .. ">"
							end,
							highlight = function(ctx)
								return ctx.kind_hl
							end,
						},
						label = {
							ellipsis = true,
							width = { fill = true, max = 50 },
							text = function(ctx)
								return ctx.label .. ctx.label_detail
							end,
							highlight = function(ctx)
								local highlights = {
									{
										0,
										#ctx.label,
										group = ctx.deprecated and "BlinkCmpLabelDeprecated" or "BlinkCmpLabel",
									},
								}
								if ctx.label_detail then
									table.insert(
										highlights,
										{ #ctx.label, #ctx.label + #ctx.label_detail, group = "BlinkCmpLabelDetail" }
									)
								end
								for _, idx in ipairs(ctx.label_matched_indices) do
									table.insert(highlights, { idx, idx + 1, group = "BlinkCmpLabelMatch" })
								end
								return highlights
							end,
						},
						label_description = {
							ellipsis = true,
							width = { max = 30 },
							text = function(ctx)
								return ctx.label_description
							end,
							highlight = "BlinkCmpLabelDescription",
						},
					},
				},
				order = {
					n = "bottom_up",
					s = "top_down",
				},
			},
			documentation = {
				auto_show = true,
				auto_show_delay_ms = 400,
				treesitter_highlighting = true,
				update_delay_ms = 100,
				window = {
					min_width = 20,
					max_width = 75,
					max_height = 15,
					border = "padded",
					winblend = 0,
					winhighlight = "Normal:BlinkCmpDoc,FloatBorder:BlinkCmpDocBorder,CursorLine:BlinkCmpDocCursorLine,Search:None",
					scrollbar = true,
					direction_priority = {
						menu_north = { "e", "w", "n", "s" },
						menu_south = { "e", "w", "s", "n" },
					},
					desired_min_height = 5,
					desired_min_width = 20,
				},
			},
			ghost_text = {
				enabled = true,
				show_with_selection = true,
				show_without_selection = true,
				show_with_menu = false,
				show_without_menu = true,
			},
		},
		signature = {
			enabled = true,
			trigger = {
				enabled = true,
				show_on_insert = true,
				show_on_keyword = true,
				show_on_trigger_character = true,
				blocked_retrigger_characters = {},
				blocked_trigger_characters = {},
				show_on_insert_on_trigger_character = true,
			},
			window = {
				min_width = 5,
				max_width = 100,
				max_height = 10,
				border = "none",
				winblend = 0,
				show_documentation = true,
				winhighlight = "Normal:BlinkCmpSignatureHelp,FloatBorder:BlinkCmpSignatureHelpBorder",
				scrollbar = false,
				direction_priority = { "n", "s" },
				treesitter_highlighting = true,
			},
		},
		fuzzy = {
			implementation = "rust",
			use_frecency = true,
			use_proximity = true,
			sorts = {
				"exact",
				"sort_text",
				"score",
				-- "kind",
			},
			max_typos = function(keyword)
				return #keyword / 10
			end,
			prebuilt_binaries = {
				download = true,
			},
		},
		sources = {
			-- Stolen from https://github.com/saecki/dotfiles/blob/d384c5ba4b023253669a121c27a9749ab4a0b916/.config/nvim/lua/config/blink.lua#L30-L53
			transform_items = function(ctx, items)
				local line = ctx.cursor[1] - 1
				local col = ctx.cursor[2]

				for _, item in ipairs(items) do
					if item.textEdit then
						if item.textEdit.range then
							-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#textEdit
							-- trim edit range after cursor
							local range_end = item.textEdit.range["end"]
							if range_end.line == line and range_end.character > col then
								range_end.character = col
							end
						elseif item.textEdit.insert then
							-- https://microsoft.github.io/language-server-protocol/specifications/lsp/3.17/specification/#insertReplaceEdit
							-- always use insert range
							item.textEdit.range = item.textEdit.insert
							item.textEdit.replace = nil
						end
					end
				end

				return items
			end,
			min_keyword_length = 0,
			default = function()
				local success, node = pcall(vim.treesitter.get_node)
				local providers_inside_comments = function(s, n)
					if
						s
						and n
						and vim.tbl_contains(
							{ "comment", "line_comment", "block_comment", "comment_content" },
							n:type()
						)
					then
						return { "buffer", "path" }
					end
					return {}
				end
				if vim.bo.filetype == "" or vim.bo.filetype == "text" then
					return { "buffer", "path" }
				else
					return vim.list_extend(
						{ "lsp", "path", "snippets", "buffer" },
						providers_inside_comments(success, node)
					)
				end
			end,
			-- term = {
			-- 	"buffer",
			-- 	"path",
			-- },
			per_filetype = {},
			providers = {
				lsp = {
					async = true,
					name = "Lsp",
					module = "blink.cmp.sources.lsp",
					enabled = true,
					score_offset = 2,
					fallbacks = { "buffer", "snippets" },
					override = {
						get_trigger_characters = function(self)
							local trigger_characters = self:get_trigger_characters()
							vim.list_extend(trigger_characters, { "\n", "\t", " " })
							return trigger_characters
						end,
					},
				},
				path = {
					name = "path",
					module = "blink.cmp.sources.path",
					enabled = true,
					score_offset = 5,
					opts = {
						trailing_slash = true,
						label_trailing_slash = true,
						get_cwd = function(ctx)
							return vim.fn.expand(("#%d:p:h").format(ctx.bufnr))
						end,
						-- show_show_hidden_files_by_default = true,
					},
					should_show_items = true,
					fallbacks = { "lazydev" },
				},
				snippets = {
					name = "Snippets",
					module = "blink.cmp.sources.snippets",
					score_offset = 10,

					-- For `snippets.preset == 'luasnip'`
					opts = {
						-- Whether to use show_condition for filtering snippets
						use_show_condition = true,
						-- Whether to show autosnippets in the completion list
						show_autosnippets = true,
					},
				},
				buffer = {
					name = "buffer",
					module = "blink.cmp.sources.buffer",
					score_offset = -5,
					opts = {
						get_bufnrs = function()
							return vim.tbl_filter(function(bufnr)
								return vim.bo[bufnr].buftype == ""
							end, vim.api.nvim_list_bufs())
						end,
					},
				},
				lazydev = {
					name = "lazydev",
					module = "lazydev.integrations.blink",
					fallbacks = { "lsp" },
				},
			},
		},
		cmdline = {
			sources = function()
				local type = vim.fn.getcmdtype()
				if type == "/" or type == "?" then
					return { "buffer", "path" }
				elseif type == ":" or type == "@" then
					return { "cmdline", "path" }
				end
				return {}
			end,
			keymap = {
				preset = "none",
				["<tab>"] = { "show_and_insert", "select_next" },
				["<m-j>"] = { "select_next" },
				["<s-tab>"] = { "select_prev" },
				["<m-k>"] = { "select_prev" },
				["<left>"] = { "fallback" },
				["<right>"] = { "fallback" },
			},
			enabled = true,
			completion = {
				list = {
					selection = {
						preselect = false,
						auto_insert = true,
					},
				},
				menu = {
					auto_show = true,
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
				ghost_text = {
					enabled = true,
				},
			},
		},
		term = {
			enabled = false,
			sources = {
				"buffer",
				"path",
			},
			completion = {
				list = {
					selection = {
						preselect = true,
						auto_insert = true,
					},
				},
				menu = {
					auto_show = true,
					draw = {
						columns = {
							{ "kind_icon" },
							{ "label", "label_description", gap = 1 },
							{ "kind" },
						},
					},
				},
				ghost_text = { enabled = true },
			},
		},
		appearance = {
			highlight_ns = vim.api.nvim_create_namespace("blink_cmp"),
			use_nvim_cmp_as_default = false,
			-- nerd_font_variant = "propo",
			kind_icons = {
				Array = "󰅪",
				Boolean = "",
				Class = "",
				Color = "",
				Constant = "",
				Constructor = "",
				Enum = "",
				EnumMember = "",
				Event = "",
				Field = "",
				File = "",
				Folder = "",
				Function = "󰡱",
				Interface = "",
				Key = "",
				Keyword = "",
				Method = "",
				Module = "",
				Namespace = "",
				Null = "󰟢",
				Number = "",
				Object = "",
				Operator = "",
				Package = "",
				Property = "󰯠",
				Reference = "",
				Snippet = "󰩫",
				String = "",
				Struct = "",
				Text = "󰦪",
				TypeParameter = "",
				Unit = "",
				Value = "",
				Variable = "󰫧",
			},
		},
	})
end

return P
