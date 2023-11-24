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

    -- 显示引用数
    {
        'VidocqH/lsp-lens.nvim',
        lazy = true,
        event = "LspAttach",
        config = configs.lsp_lens,
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
        lazy = true,
        version = false,
        event = 'CursorMoved',
        init = function()
            vim.api.nvim_create_autocmd("FileType", {
                pattern = require('core.settings').exclude_filetypes,
                callback = function()
                    vim.b.miniindentscope_disable = true
                end,
            })
        end,
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
        lazy = true,
        event = 'LspAttach',
        opts = {
            window = {
                blend = 0,
            },
        },
    },
}
