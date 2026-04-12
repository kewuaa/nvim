local mini_ai = require("mini.ai")
local gen_ai_spec = require("mini.extra").gen_ai_spec

mini_ai.setup({
    n_lines = 500,
    custom_textobjects = {
        t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
        d = { "%f[%d]%d+" }, -- digits
        e = { -- Word with case
            { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
            "^().*()$",
        },
        u = mini_ai.gen_spec.function_call(), -- u for "Usage"
        U = mini_ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        B = gen_ai_spec.buffer(),
        D = gen_ai_spec.diagnostic(),
        I = gen_ai_spec.indent(),
        L = gen_ai_spec.line(),
        N = gen_ai_spec.number(),
    },
})
