local deps = require("deps")
local configs = require("plugins.completion.configs")

---------------------------------------------------------------------------------------------------
---auto completion
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.completion",
    lazy_opts = {
        events = { "InsertEnter" }
    },
    config = configs.mini_completion,
    depends = {
        {
            source = "echasnovski/mini.snippets",
            config = configs.mini_snippets
        }
    }
})

---------------------------------------------------------------------------------------------------
---cmdline completion
---------------------------------------------------------------------------------------------------
deps.add({
    source = "nvim-mini/mini.cmdline",
    lazy_opts = {
        events = { "CmdlineEnter" }
    },
    config = configs.mini_cmdline,
})

---------------------------------------------------------------------------------------------------
---Cargo.toml support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "saecki/crates.nvim",
    lazy_opts = {
        delay_install = true,
        events = {"BufRead Cargo.toml"}
    },
    config = configs.crates,
})

---------------------------------------------------------------------------------------------------
---ai support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "zbirenbaum/copilot.lua",
    hooks = {
        post_checkout = function()
            vim.cmd("Copilot auth")
        end,
        post_install = function()
            vim.schedule(function()
                vim.cmd("Copilot auth")
            end)
        end
    },
    lazy_opts = {
        cmds = {"Copilot"},
        delay_install = true,
    },
    config = configs.copilot,
})
