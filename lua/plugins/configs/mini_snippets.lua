local mini_snippets = require("mini.snippets")
local loader = mini_snippets.gen_loader

mini_snippets.setup({
    snippets = {
        loader.from_lang({
            lang_patterns = {
                cpp = { "**/c.json", "**/cpp.json" },
                cs = { "**/c.json", "**/csharp.json" },
                javascript = { "**/c.json", "**/javascript.json" },
                cython = { "**/python.json", "**/cython.json" },
                java = { "**/java.json" }
            }
        })
    },
    mappings = {
        expand = "<C-j>",
        jump_next = "<TAB>",
        jump_prev = "<S-TAB>",
        stop = "<C-c>"
    }
})
