local deps = require("deps")
local configs = require("plugins.ui.configs")

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
    source = "echasnovski/mini.statusline",
    lazy_opts = {
        events = {"ColorScheme"},
    },
    config = configs.mini_statusline
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
