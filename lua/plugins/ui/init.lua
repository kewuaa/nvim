local configs = require("plugins.ui.configs")


return {
    -- 颜色主题
    {
    --     'sainnhe/sonokai',
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
        enabled = vim.version().minor > 9,
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
