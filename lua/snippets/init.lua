local ls = require("luasnip")
local s = ls.s
local i = ls.i
local f = ls.f
local fmt = require("luasnip.extras.fmt").fmt
local c_snips = require('snippets.c')
local lua_snips = require('snippets.lua')

ls.add_snippets("c", c_snips.make_c_snippets(s, i, fmt))
ls.add_snippets("lua", lua_snips.make_lua_snnippets(s, i, fmt, f))
