local deps = require("deps")
local configs = require("plugins.completion.configs")

---------------------------------------------------------------------------------------------------
---auto completion
---------------------------------------------------------------------------------------------------
deps.add({
    -- source = "brianaung/compl.nvim",
    source = "kewuaa/compl.nvim",
    checkout = "personal",
    monitor = "personal",
    lazy_opts = {
        events = {"InsertEnter"},
    },
    config = configs.compl
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
