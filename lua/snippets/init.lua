local ls = require("luasnip")
local s = ls.s
local i = ls.i
local f = ls.f
local fmt = require("luasnip.extras.fmt").fmt
local c_snips = require("snippets.c")
local lua_snips = require("snippets.lua")
local python_snips = require("snippets.python")

ls.add_snippets("c", c_snips.make_c_snippets(s, i, fmt))
ls.add_snippets("lua", lua_snips.make_lua_snippets(s, i, fmt, f))
ls.add_snippets("python", python_snips.make_python_snippets(s, i, fmt, f))
