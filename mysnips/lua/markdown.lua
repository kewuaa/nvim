local ls = require("luasnip")
local s = ls.snippet
local sn = ls.snippet_node
local isn = ls.indent_snippet_node
local t = ls.text_node
local i = ls.insert_node
local f = ls.function_node
local c = ls.choice_node
local d = ls.dynamic_node
local r = ls.restore_node
local events = require("luasnip.util.events")
local ai = require("luasnip.nodes.absolute_indexer")
local extras = require("luasnip.extras")
local fmt = extras.fmt
local m = extras.m
local l = extras.l
local postfix = require("luasnip.extras.postfix").postfix
local trim = vim.fn.trim

return {
    s(
        {
            trig = "([^$%s]+)/([^$%s]+)",
            regTrig = true,
            hidden = true,
        },
        {
            f(
                function(_, snip)
                    return ("\\frac{%s}{%s}"):format(
                        trim(snip.captures[1]),
                        trim(snip.captures[2])
                    )
                end,
                {}
            ),
        }
    ),
    s(
        {
            name = "inline math",
            trig = "ilm",
            dscr = "Code snippet for inline math statement."
        },
        {
            t("$"), i(1), t("$"), f(function(args) return args[1][1]:len() > 1 and "" or " " end, {1})
        }
    )
}
