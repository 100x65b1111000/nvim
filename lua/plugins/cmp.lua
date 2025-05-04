local P = {
	"hrsh7th/nvim-cmp",
	cond = false,
	event = { "InsertEnter" },
	dependencies = {
		"hrsh7th/cmp-nvim-lsp",
		"hrsh7th/cmp-buffer",
		"hrsh7th/cmp-path",
		"saadparwaiz1/cmp_luasnip",
		"hrsh7th/cmp-cmdline",
		{
			"L3MON4D3/LuaSnip",
			build = "make install_jsregexp",
			opts = function()
				local types = require("luasnip.util.types")
				return {
					history = true,
					update_events = { "TextChanged", "TextChangedI" },
					enable_autosnippets = true,
					ext_opts = {
						[types.choiceNode] = {
							active = {
								virt_text = { { "<<- ", "Error" } },
							},
						},
					},
				}
			end,
			config = function(_, opts)
				require("luasnip").config.set_config(opts)
			end,
		},
		{
			"L3MON4D3/cmp-luasnip-choice",
			config = function()
				require("cmp_luasnip_choice").setup({
					auto_open = true,
				})
			end,
		},
	},
}

P.config = function()
	local cmp = require("cmp")
	local luasnip = require("luasnip")
	local cmp_autopairs = require("nvim-autopairs.completion.cmp")

	cmp.event:on("confirm_done", cmp_autopairs.on_confirm_done())
	cmp.setup({
		disable = false,
		enabled = function()
			local in_comment = require("cmp.config.context").in_treesitter_capture("comment")
				or require("cmp.config.context").in_treesitter_capture("Comment")
			local buf_is_file = "" == vim.api.nvim_get_option_value("buftype", { buf = vim.api.nvim_get_current_buf() })
			return buf_is_file and not in_comment
		end,
		snippet = {
			expand = function(args)
				require("luasnip").lsp_expand(args.body)
			end,
		},
		window = {
			completion = {
				border = "none",
				scrollbar = true,
				winhighlight = "FloatBorder:CmpMenuBorder",
				scrolloff = 10,
				col_offset = 1,
				side_padding = 1,
			},
			documentation = {
				winhighlight = "FloatBorder:CmpDocBorder",
				border = "none",
				max_width = 100,
				max_height = 15,
			},
		},
		mapping = {
			["<m-f>"] = cmp.mapping.scroll_docs(-4),
			["<m-b>"] = cmp.mapping.scroll_docs(4),
			["<m-e>"] = cmp.mapping.abort(),
			["<m-<Return>>"] = cmp.mapping.complete(),
			["<CR>"] = cmp.mapping(function(fallback)
				if cmp.visible() then
					if luasnip.expandable() then
                        vim.notify('expandable')
						luasnip.expand()
					else
                        vim.notify("not_expandable")
						cmp.confirm({
							behavior = cmp.ConfirmBehavior.Replace,
							select = true,
						})
					end
				else
					return fallback()
				end
			end),
			["<m-j>"] = cmp.mapping.select_next_item({
				behavior = cmp.SelectBehavior.Select,
			}),
			["<m-k>"] = cmp.mapping.select_prev_item({
				behavior = cmp.SelectBehavior.Select,
			}),
			["<m-n>"] = cmp.mapping.select_next_item({
				behavior = cmp.SelectBehavior.Insert,
			}),
			["<m-p>"] = cmp.mapping.select_prev_item({
				behavior = cmp.SelectBehavior.Insert,
			}),
			["<m-l>"] = cmp.mapping(function(fallback)
				if luasnip.expandable() then
					cmp.snippet.expand()
				elseif luasnip.jumpable(1) then
					luasnip.jump(1)
				else
					return fallback()
				end
			end, { "i", "s" }),
			["<m-h>"] = cmp.mapping(function(fallback)
				if luasnip.jumpable(-1) then
					luasnip.jump(-1)
				else
					return fallback()
				end
			end, { "i", "s" }),
		},
		sources = cmp.config.sources({
			{ name = "nvim_lsp", priority = 10000 },
			{ name = "nvim_lsp_signature_help", priority = 900 },
			{ name = "luasnip", priority = 900 },
			{ name = "luasnip_choice", priority = 900 },
			{ name = "path", priority = 900 },
			{ name = "buffer", priority = 800 },
			{ name = "lazydev", priority = 900 },
		}),
		confirmation = {
			default_behavior = "insert",
		},
		preselect = "item",
		completion = {
			keyword_length = 1,
			completeopt = "menu,menuone,preview,fuzzy,popup",
		},
		experimental = {
			ghost_text = true,
		},
		view = {
			docs = {
				auto_open = true,
			},
			entries = {
				name = "custom",
				selection_order = "near_cursor",
				follow_cursor = true,
			},
		},
		matching = {
			disallow_symbol_nonprefix_matching = false,
		},
		formatting = {
			fields = { "abbr", "kind" },
			expandable_indicator = true,

			format = function(entry, vim_item)
				-- Stolen and modified from https://github.com/wenjinnn/wenvim/blob/4bbcd2baf2df574393e010ab0f30358fe6fe871a/lua/plugin/completion.lua#L138C1-L144C12
				local columns = vim.o.columns
				local max_len = math.floor(columns / 5)
				local ellipsis = " "

				local function limit_width(item)
					if item ~= nil and item:len() > max_len then
						item = item:sub(0, max_len) .. ellipsis
					end
					return item
				end

				local icon, _ = require("mini.icons").get("lsp", vim_item.kind)
				if icon ~= nil then
					vim_item.kind = icon .. "  " .. vim_item.kind
					-- vim_item.kind_hl_group = hl_group
				end

				vim_item.menu = limit_width(vim_item.menu)
				vim_item.abbr = limit_width(vim_item.abbr)

				local source_mappings = {
					buffer = { name = "[Buffer]", hl = "CmpMenuBuffer" },
					nvim_lsp = { name = "[LSP]", hl = "CmpMenuLsp" },
					snippets = { name = "[Snippet]", hl = "CmpMenuSnippet" },
					nvim_lsp_signature_help = { name = "[Signature]", hl = "CmpMenuSignature" },
					path = { name = "[Path]", hl = "CmpMenuPath" },
					cmdline = { name = "[CMD]", hl = "CmpMenuCmd" },
				}

				local source = source_mappings[entry.source.name]

				if source ~= nil then
					vim_item.menu = " " .. source.name
				else
					source = { name = "[Misc]", hl = "Normal" }
					vim_item.menu = " " .. source.name
				end

				vim_item.menu_hl_group = source.hl

				-- if entry.source.name == "cmdline" then
				-- 	vim_item.kind = ""
				-- end

				return vim_item
			end,
		},
	})
	---@diagnostic disable-next-line: redundant-parameter
	cmp.setup.cmdline({ "/", "?" }, {
		enabled = true,
		window = {
			completion = {
				border = "single",
				scrollbar = true,
				side_padding = 1,
			},
		},
		completion = {
			completeopt = "menu,menuone,noselect",
		},
		mapping = cmp.mapping.preset.cmdline({
			["<Tab>"] = {
				c = function()
					if cmp.visible() then
						if #cmp.get_entries() == 1 then
							cmp.confirm({ select = true })
						else
							cmp.select_next_item()
						end
					else
						cmp.complete()
						if #cmp.get_entries() == 1 then
							cmp.confirm({ select = true })
						end
					end
				end,
			},
		}),
		sources = {
			{ name = "buffer" },
		},
	})

	cmp.setup.cmdline(":", {
		enabled = true,
		window = {
			completion = {
				border = "none",
				scrollbar = true,
				side_padding = 2,
			},
		},
		formatting = {
			fields = { "abbr", "kind", "menu" },
		},
		sources = cmp.config.sources({
			{ name = "cmdline" },
		}, {
			{ name = "path" },
		}),
		matching = { disallow_symbol_nonprefix_matching = false },
		preselect = "None",
		completion = {
			completeopt = "menu,menuone,noselect",
		},
		mapping = cmp.mapping.preset.cmdline({
			["<Tab>"] = {
				c = function()
					if cmp.visible() then
						if #cmp.get_entries() == 1 then
							cmp.confirm({ select = true })
						else
							cmp.select_next_item({
                                behavior = cmp.SelectBehavior.Select
                            })
						end
					else
						cmp.complete()
						if #cmp.get_entries() == 1 then
							cmp.confirm({ select = true })
						end
					end
				end,
			},
		}),
	})
end

return P
