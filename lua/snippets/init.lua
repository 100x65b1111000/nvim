local ls = require("luasnip")
local s = ls.s
local i = ls.i
local f = ls.f
local fmt = require("luasnip.extras.fmt").fmt
local c_snips = require("snippets.c")
local lua_snips = require("snippets.lua")
local python_snips = require("snippets.python")
local bash_snips = require("snippets.bash")
local fish_snips = require("snippets.fish")
local rust_snips = require("snippets.rust")
local cpp_snips = require("snippets.cpp")

ls.add_snippets("c", c_snips.make_c_snippets(s, i, fmt))
ls.add_snippets("lua", lua_snips.make_lua_snippets(s, i, fmt, f))
ls.add_snippets("python", python_snips.make_python_snippets(s, i, fmt, f))
ls.add_snippets("bash", bash_snips.make_bash_snippets(s, i, fmt))
ls.add_snippets("sh", bash_snips.make_bash_snippets(s, i, fmt))
ls.add_snippets("fish", fish_snips.make_fish_snippets(s, i, fmt))
ls.add_snippets("rust", rust_snips.make_rust_snippets(s, i, fmt))
ls.add_snippets("cpp", cpp_snips.make_cpp_snippets(s, i, fmt))
