local configs = require("plugins.ui.configs")


return {
    -- 颜色主题
    {
        'sainnhe/sonokai',
        lazy = true,
        event = 'VeryLazy',
        config = configs.sonokai,
    },

    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        lazy = true,
        event = 'ColorScheme',
        config = configs.lualine,
        dependencies = {
            {'nvim-tree/nvim-web-devicons'},
        }
    },

    -- 缩进线
    {
        'lukas-reineke/indent-blankline.nvim',
        lazy = true,
        main = "ibl",
        event = {'BufRead', 'BufNewFile'},
        config = configs.indent_blankline,
    },
    {
        'echasnovski/mini.indentscope',
        version = false,
        event = 'CursorMoved',
        config = configs.mini_indentscope,
    },

    -- 消息提示
    {
        'rcarriga/nvim-notify',
        lazy = true,
        event = 'VeryLazy',
        config = configs.notify,
    },

    -- 增强vim UI
    {
        'stevearc/dressing.nvim',
        lazy = true,
        event = 'VeryLazy',
        config = configs.dressing,
    },

    -- 调暗未使用函数，变量和参数
    {
        'zbirenbaum/neodim',
        lazy = true,
        event = 'LspAttach',
        config = configs.neodim,
    },

    -- lsp progress
    {
        'j-hui/fidget.nvim',
        version = 'legacy',
        lazy = true,
        event = 'LspAttach',
        config = true,
    },
}
