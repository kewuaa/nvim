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
