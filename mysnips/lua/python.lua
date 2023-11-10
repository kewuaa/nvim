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
local split = vim.fn.split
local function parse_parameter(param)
    local lst = split(param, ":")
    return #lst > 1 and ("%s(%s)"):format(trim(lst[1]), trim(lst[2])) or trim(lst[1])
end

return {
    s(
        {
            name = "function",
            trig = "def",
            dscr = "Code snippet for the def statement."
        },
        {
            t("def "), i(1, "name"), t"(", i(2), t(") -> "), i(3, "type"), t(":"),
            d(4, function(args)
                local params = split(args[1][1], ",")
                if params[1] == "self" then
                    params = vim.list_slice(params, 2)
                end
                local nodes = {t({"", '\t"""'})}
                if #params > 0 then
                    nodes[#nodes+1] = t({"", "\t"})
                    nodes[#nodes+1] = i(1, "doc")
                    nodes[#nodes+1] = t({".", ""})
                    for index, p in ipairs(params) do
                        nodes[#nodes+1] = t({"", ("\t@params %s: "):format(parse_parameter(p))})
                        nodes[#nodes+1] = i(index + 1, "...")
                    end
                    if args[2][1] ~= "None" then
                        nodes[#nodes+1] = t({"", ("\t@returns(%s): "):format(args[2][1])})
                        nodes[#nodes+1] = i(#params + 2, "...")
                    end
                    nodes[#nodes+1] = t({"", '\t"""'})
                else
                    nodes[#nodes+1] = t(" ")
                    nodes[#nodes+1] = i(1, "doc")
                    nodes[#nodes+1] = t('."""')
                end
                return sn(
                    nil,
                    nodes
                )
            end, {2, 3}),
            t({"", "", "\t"}), i(5, "pass"),
            t({"", "#enddef", ""}), i(0)
        }
    ),
}
