local deps = require("deps")
local configs = require("plugins.ui.configs")

---------------------------------------------------------------------------------------------------
---colorscheme
---------------------------------------------------------------------------------------------------
deps.later(function()
    vim.cmd.colorscheme("tokyonight")
end)
deps.add({
    source = "echasnovski/mini.colors",
    lazy_opts = {
        cmds = {"MiniColorsInteractive"},
        delay_install = true,
    },
    config = function()
        local mini_colors = require("mini.colors")
        mini_colors.setup()
        vim.api.nvim_create_user_command("MiniColorsInteractive", mini_colors.interactive, {})
    end
})

---------------------------------------------------------------------------------------------------
---highlight patterns
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.hipatterns",
    lazy_opts = {
        cmds = {"MiniHipatternsToggle"},
    },
    config = configs.mini_hipatterns
})

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
        mini_icons.tweak_lsp_kind()
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
