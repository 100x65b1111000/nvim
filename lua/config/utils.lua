local M = {}

---@type vim.lsp.buf.signature_help.Opts
M.float_win_opts = {
	focusable = true,
	focus = false,
	title_pos = "center",
	relative = "cursor",
	z_index = 1000,
	anchor_bias = "above",
	max_width = 100,
}

M.hl_search = function(blinktime)
	local ns = vim.api.nvim_create_namespace("search")
	vim.api.nvim_buf_clear_namespace(0, ns, 0, -1)

	local search_pat = "\\c\\%#" .. vim.fn.getreg("/")
	local ring = vim.fn.matchadd("IncSearch", search_pat)
	vim.cmd("redraw")
	vim.cmd("sleep " .. blinktime * 1000 .. "m")

	local sc = vim.fn.searchcount()
	vim.api.nvim_buf_set_extmark(0, ns, vim.api.nvim_win_get_cursor(0)[1] - 1, 0, {
		virt_text = { { "[" .. sc.current .. "/" .. sc.total .. "]", "Comment" } },
		virt_text_pos = "eol",
	})

	vim.fn.matchdelete(ring)
	vim.cmd("redraw")
end

local var = [[


]]
M.dashboard_headers = {
	neovim_1 = {
		"███╗  ██╗███████╗ █████╗ ██╗   ██╗██╗███╗   ███╗",
		"████╗ ██║██╔════╝██╔══██╗██║   ██║██║████╗ ████║",
		"██╔██╗██║█████╗  ██║  ██║╚██╗ ██╔╝██║██╔████╔██║",
		"██║╚████║██╔══╝  ██║  ██║ ╚████╔╝ ██║██║╚██╔╝██║",
		"██║ ╚███║███████╗╚█████╔╝  ╚██╔╝  ██║██║ ╚═╝ ██║",
		"╚═╝  ╚══╝╚══════╝ ╚════╝    ╚═╝   ╚═╝╚═╝     ╚═╝",
	},
	neovim_2 = {
		"███▄▄▄▄      ▄████████  ▄██████▄   ▄█    █▄   ▄█    ▄▄▄▄███▄▄▄▄  ",
		"███▀▀▀██▄   ███    ███ ███    ███ ███    ███ ███  ▄██▀▀▀███▀▀▀██▄",
		"███   ███   ███    █▀  ███    ███ ███    ███ ███▌ ███   ███   ███",
		"███   ███  ▄███▄▄▄     ███    ███ ███    ███ ███▌ ███   ███   ███",
		"███   ███ ▀▀███▀▀▀     ███    ███ ███    ███ ███▌ ███   ███   ███",
		"███   ███   ███    █▄  ███    ███ ███    ███ ███  ███   ███   ███",
		"███   ███   ███    ███ ███    ███ ███    ███ ███  ███   ███   ███",
		"▀█   █▀    ██████████  ▀██████▀   ▀██████▀  █▀    ▀█   ███   █▀ ",
	},
	neovim_3 = {
		"",
		"                                                                     ",
		"       ████ ██████           █████      ██                     ",
		"      ███████████             █████                             ",
		"      █████████ ███████████████████ ███   ███████████   ",
		"     █████████  ███    █████████████ █████ ██████████████   ",
		"    █████████ ██████████ █████████ █████ █████ ████ █████   ",
		"  ███████████ ███    ███ █████████ █████ █████ ████ █████  ",
		" ██████  █████████████████████ ████ █████ █████ ████ ██████ ",
		"",
	},
	neovim_4 = {
		"                                                     ",
		"  ███▄    █ ▓█████  ▒█████   ██▒   █▓ ██▓ ███▄ ▄███▓ ",
		"  ██ ▀█   █ ▓█   ▀ ▒██▒  ██▒▓██░   █▒▓██▒▓██▒▀█▀ ██▒ ",
		" ▓██  ▀█ ██▒▒███   ▒██░  ██▒ ▓██  █▒░▒██▒▓██    ▓██░ ",
		" ▓██▒  ▐▌██▒▒▓█  ▄ ▒██   ██░  ▒██ █░░░██░▒██    ▒██  ",
		" ▒██░   ▓██░░▒████▒░ ████▓▒░   ▒▀█░  ░██░▒██▒   ░██▒ ",
		" ░ ▒░   ▒ ▒ ░░ ▒░ ░░ ▒░▒░▒░    ░ ▐░  ░▓  ░ ▒░   ░  ░ ",
		" ░ ░░   ░ ▒░ ░ ░  ░  ░ ▒ ▒░    ░ ░░   ▒ ░░  ░      ░ ",
		"    ░   ░ ░    ░   ░ ░ ░ ▒       ░░   ▒ ░░      ░    ",
		"          ░    ░  ░    ░ ░        ░   ░         ░    ",
		"                                 ░                   ",
		"",
	},

	neovim_5 = {
		"                                                                       ",
		"  ██████   █████                   █████   █████  ███                  ",
		" ░░██████ ░░███                   ░░███   ░░███  ░░░                   ",
		"  ░███░███ ░███   ██████   ██████  ░███    ░███  ████  █████████████   ",
		"  ░███░░███░███  ███░░███ ███░░███ ░███    ░███ ░░███ ░░███░░███░░███  ",
		"  ░███ ░░██████ ░███████ ░███ ░███ ░░███   ███   ░███  ░███ ░███ ░███  ",
		"  ░███  ░░█████ ░███░░░  ░███ ░███  ░░░█████░    ░███  ░███ ░███ ░███  ",
		"  █████  ░░█████░░██████ ░░██████     ░░███      █████ █████░███ █████ ",
		" ░░░░░    ░░░░░  ░░░░░░   ░░░░░░       ░░░      ░░░░░ ░░░░░ ░░░ ░░░░░  ",
		"                                                                       ",
	},
}

M.dashboard_footers = {
	keyboard = {
		"",
		"┏━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━┯━━━━━┓",
		"┃ ` │ 1 │ 2 │ 3 │ 4 │ 5 │ 6 │ 7 │ 8 │ 9 │ 0 │ ─ │ = │ <─  ┃",
		"┠───┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬───┨",
		"┃ ─>| │   │   │   │   │   │   │   │   │   │   │   │   │   ┃",
		"┠─────┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴┬──┴───┨",
		"┃ Caps │   │   │   │   │   │ H │ J │ K │ L │ ; │   │  󰌑   ┃",
		"┠──────┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴─┬─┴──────┨",
		"┃ Shift  │   │   │   │  │   │  │   │   │   │   │ Shift  ┃",
		"┠──────┬─┴──┬┴───┼───┴─┬─┴───┴───┴───┴───┴───┼───┴─┬──────┨",
		"┃ Ctrl │ Fn │   │ Alt │                     │ Alt │ Ctrl ┃",
		"┗━━━━━━┷━━━━┷━━━━┷━━━━━┷━━━━━━━━━━━━━━━━━━━━━┷━━━━━┷━━━━━━┛",
		"",
	},
	cat1 = {
		[[  /\_/\ ♥ ]],
		[[>^,^< ]],
		[[/ \ ]],
		[[  (___)_/ ]],
	},
	cat2 = {
		[[  ╱|、 ]],
		[[(˚ˎ 。7]],
		[[ |、˜〵]],
		[[    じしˍ,)ノ]],
		[[]],
	},
	cat3 = {
		[[／l、 ]],
		[[ （ﾟ､ ｡ ７ 　 ]],
		[[    　l、~ ヽ     ]],
		[[    　ししと ）ノ ]],
		[[]],
	},
	lyrics = {
		-- A list of lyrics that go hard

		"I'm so sick of _____",
		"If I was split in two, I would just take my fist, so I could beat up the rest of me",
		"You've no right to be depressed, You haven't tried hard enough to like it",
		"I'll take a quiet life, a handhsake of carbon monoxide",
		"No alarms and No surprises",
		"Last Friday, I took acid and mushrooms / I did not transcend, I felt like a walking piece of shit",
		"It’s not the hunger that’s the problem, it’s the way that it’s never satisfied",
		"For a minute there, I lost myself, I lost myself",
		"It doesn't have to be like this, killer whales",
		"You share the same fate as the people you hate",
		"You build your self up against other's feelings and it left you feelin' empty as a car coasting downhill",
		"One day, I'm gonna grow wings, a chemical reaction, hyterical and useless",
		"I'm gonna say what's on my mind, then I'll walk out then I'll be fine",
	},
}

return M
