local deps = require("deps")
local configs = require("plugins.completion.configs")

---------------------------------------------------------------------------------------------------
---auto completion
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.completion",
    lazy_opts = {
        events = {"InsertEnter"}
    },
    config = configs.mini_completion,
    depends = {
        "echasnovski/mini.fuzzy"
    }
})

---------------------------------------------------------------------------------------------------
---snippets support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "garymjr/nvim-snippets",
    lazy_opts = {
        events = {"InsertEnter"}
    },
    config = configs.snippets
})

---------------------------------------------------------------------------------------------------
---lsp support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "neovim/nvim-lspconfig",
    lazy_opts = {
        events = {"BufRead", "BufNewFile"},
        delay = 100,
    },
    config = function()
        configs.nvim_lspconfig()
    end,
    depends = {
        {
            source = "williamboman/mason.nvim",
            config = require("plugins.tools.configs").mason
        },
    }
})

---------------------------------------------------------------------------------------------------
---Cargo.toml support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "saecki/crates.nvim",
    lazy_opts = {
        events = {"BufRead Cargo.toml"}
    },
    config = configs.crates,
})

---------------------------------------------------------------------------------------------------
---copilot support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "zbirenbaum/copilot.lua",
    hooks = {
        post_checkout = function()
            vim.cmd("Copilot auth")
        end
    },
    lazy_opts = {
        cmds = {"Copilot"}
    },
    config = configs.copilot,
})
