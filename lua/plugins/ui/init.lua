local configs = require("plugins.ui.configs")
local deps = require("core.deps")

---------------------------------------------------------------------------------------------------
---colorscheme
---------------------------------------------------------------------------------------------------
deps.add({
    source = "folke/tokyonight.nvim",
    lazy_opts = {
        very_lazy = true
    },
    config = configs.tokyonight
})

---------------------------------------------------------------------------------------------------
---status line
---------------------------------------------------------------------------------------------------
deps.add({
    source = "kewuaa/sttusline",
    monitor = "table_version",
    checkout = "table_version",
    lazy_opts = {
        events = {"ColorScheme"},
    },
    config = configs.sttusline
})

---------------------------------------------------------------------------------------------------
---tab line
---------------------------------------------------------------------------------------------------
deps.add({
    source = "kewuaa/nvim-tabline",
    lazy_opts = {
        events = {"TabNew"}
    },
    config = configs.tabline,
    depends = {"nvim-tree/nvim-web-devicons"},
})

---------------------------------------------------------------------------------------------------
---indent line
---------------------------------------------------------------------------------------------------
deps.add({
    source = "nvimdev/indentmini.nvim",
    lazy_opts = {
        events = {"BufRead", "BufNewFile"}
    },
    config = configs.indentmini
})

---------------------------------------------------------------------------------------------------
---enhance notify
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.notify",
    lazy_opts = {
        very_lazy = true
    },
    config = configs.mini_notify,
})

---------------------------------------------------------------------------------------------------
---enhance ui
---------------------------------------------------------------------------------------------------
deps.add({
    source = "stevearc/dressing.nvim",
    lazy_opts = {
        very_lazy = true
    },
    config = function()
        require("dressing").setup()
    end,
})
