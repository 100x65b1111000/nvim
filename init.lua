vim.g.mapleader = " "
require("imports")

if vim.version().minor >= 12 then
	vim.schedule(function ()
		require("vim._extui").enable({ enable = true, msg = { target = "cmd", timeout = 5000 } })
	end)
end
