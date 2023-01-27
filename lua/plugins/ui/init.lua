local configs = require("plugins.ui.configs")


return {
    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        lazy = true,
        -- event = {'BufRead', 'BufNewFile'},
        event = 'VeryLazy',
        config = configs.lualine,
        dependencies = {
            {'nvim-tree/nvim-web-devicons'},
            -- 颜色主题
            {
                'sainnhe/sonokai',
                config = configs.sonokai,
            },
        }
    },

    -- 语法高亮
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = true,
        build = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        event = {'BufRead', 'BufNewFile'},
        config = configs.nvim_treesitter,
        dependencies = {
            -- 彩虹括号
            {'p00f/nvim-ts-rainbow'},
            -- 参数高亮
            {'m-demare/hlargs.nvim', config = configs.hlargs},
        },
    },

    -- 缩进线
    {
        'lukas-reineke/indent-blankline.nvim',
        lazy = true,
        event = {'BufRead', 'BufNewFile'},
        config = configs.indent_blankline,
    },

    -- 消息提示
    {
        'rcarriga/nvim-notify',
        lazy = true,
        event = 'VeryLazy',
        config = configs.notify,
    },

    -- lsp progress
    {
        'j-hui/fidget.nvim',
        lazy = true,
        event = 'LspAttach',
        config = true,
    },
}
