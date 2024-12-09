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
deps.later(function()
    vim.cmd.colorscheme("tokyonight")
end)

---------------------------------------------------------------------------------------------------
---icons
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.icons",
    lazy_opts = {
        very_lazy = true
    },
    config = function()
        local mini_icons = require("mini.icons")
        mini_icons.setup()
        -- call after setup compl.nvim
        -- mini_icons.tweak_lsp_kind()
    end
})

---------------------------------------------------------------------------------------------------
---status line
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.statusline",
    lazy_opts = {
        very_lazy = true
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
