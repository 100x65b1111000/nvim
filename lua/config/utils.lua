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

M.borders = { padded = { " ", " ", " ", " ", " ", " ", " ", " " } }

M.dashboard_headers = {
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
}

M.dashboard_footers = {
	cat2 = {
		[[  ╱|、 ]],
		[[(˚ˎ 。7]],
		[[ |、˜〵]],
		[[    じしˍ,)ノ]],
		[[]],
	},
	lyrics = {
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
