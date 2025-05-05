local states = require('ui.statusline_new.states')
local has_mini_icons, mini_icons = pcall(require, "mini.icons")

local M = {}

local generate_module_string = function(modules)
	local modules_string = ""
	for _, i in ipairs(modules) do
		local module_string = ""
		if type(i) == "function" then
			local module_info = i()
			module_string = string.format(" %%#%s#%s ", module_info.hl_string, module_info.string)
			modules_string = modules_string .. module_string
		else
			module_string = states.modules_map[i]
		end
		modules_string = modules_string .. module_string
	end
	return modules_string
end

---@param opts StatusLineConfig|nil
M.set_statusline = function (opts)
	local config = vim.tbl_deep_extend("force", states.default_config, opts or {})
	if config.use_mini_icons then
		M.has_mini_icons, M.mini_icons = pcall(require, "mini.icons")
	end

	local left_modules_string = generate_module_string(config.modules.left)
	local middle_modules_string = generate_module_string(config.modules.middle)
	local right_modules_string = generate_module_string(config.modules.right)

	states.cache.statusline_string = left_modules_string .. middle_modules_string .. right_modules_string
	return states.cache.statusline_string
end

return M
