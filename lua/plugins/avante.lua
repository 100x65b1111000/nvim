local M = {
	"yetone/avante.nvim",
	-- if you want to build from source then do `make BUILD_FROM_SOURCE=true`
	-- ⚠️ must add this setting! ! !
	build = function()
		-- conditionally use the correct build system for the current OS
		return "make BUILD_FROM_SOURCE=true"
	end,
	version = false, -- Never set this value to "*"! Never!
	cmd = "Avante",
	---@module 'avante'
	---@type avante.Config
	opts = {
		-- add any opts here
		-- for example
		provider = "gemini",
		providers = {
			gemini = {},
		},
	},
	dependencies = {
		"nvim-lua/plenary.nvim",
		"MunifTanjim/nui.nvim",
		--- The below dependencies are optional,
		"folke/snacks.nvim", -- for input provider snacks
	},
}

return M
