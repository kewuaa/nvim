local configs = require("plugins.ui.configs")


return {

    -- 语法高亮
    {
        'nvim-treesitter/nvim-treesitter',
        opt = true,
        run = function()
            require('nvim-treesitter.install').update({ with_sync = true })
        end,
        setup = function ()
            require("plugins"):delay_load_on_event(
                'nvim-treesitter',
                100,
                'VimEnter',
                '*'
            )
        end,
        config = configs.nvim_treesitter,
        requires = {
            -- 彩虹括号
            {
                'p00f/nvim-ts-rainbow',
                opt = true,
            },

            -- 参数高亮
            {
                'm-demare/hlargs.nvim',
                opt = true,
                config = configs.hlargs,
            },
        },
    },

    -- 颜色主题
    {
        'sainnhe/sonokai',
        opt = true,
        after = 'nvim-treesitter',
        config = configs.sonokai,
    },

    -- 缩进线
    {
        'lukas-reineke/indent-blankline.nvim',
        opt = true,
        after = 'lualine.nvim',
        config = configs.indent_blankline,
    },

    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        opt = true,
        after = 'sonokai',
        config = configs.lualine,
        requires = {
            {
                'nvim-tree/nvim-web-devicons',
                opt = true,
            }
        }
    },

    -- 消息提示
    {
        'rcarriga/nvim-notify',
        opt = true,
        after = 'indent-blankline.nvim',
        config = configs.notify,
    },

    -- 增强vim.ui
    {
        'stevearc/dressing.nvim',
        opt = true,
        after = 'nvim-notify',
        config = configs.dressing,
    },

    -- lsp progress
    {
        'j-hui/fidget.nvim',
        opt = true,
        event = 'LspAttach',
        config = configs.fidget,
    },
}
