local configs = require("plugins.ui.configs")


return {
    -- 颜色主题
    {
        'folke/tokyonight.nvim',
        lazy = true,
        event = 'VeryLazy',
        config = configs.tokyonight,
    },

    -- statusline
    {
        'kewuaa/sttusline',
        branch = "table_version",
        lazy = true,
        event = 'ColorScheme',
        config = configs.sttusline,
        dependencies = {
            {'nvim-tree/nvim-web-devicons'},
        }
    },

    -- tabline
    {
        'kewuaa/nvim-tabline',
        lazy = true,
        event = 'TabNew',
        config = configs.tabline,
        dependencies = {
            { 'nvim-tree/nvim-web-devicons' },
        }
    },

    -- winbar
    {
        "SmiteshP/nvim-navic",
        lazy = true,
        config = configs.nvim_navic
    },

    -- 缩进线
    {
        'nvimdev/indentmini.nvim',
        lazy = true,
        event = {"BufRead", "BufNewFile"},
        config = configs.indentmini,
    },

    {
        "echasnovski/mini.notify",
        version = false,
        lazy = true,
        event = "VeryLazy",
        config = configs.mini_notify
    },

    -- 增强vim UI
    {
        'stevearc/dressing.nvim',
        lazy = true,
        event = 'VeryLazy',
        config = configs.dressing,
    },
}
