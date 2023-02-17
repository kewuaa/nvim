local configs = require("plugins.ui.configs")


return {
    -- 颜色主题
    {
        'catppuccin/nvim',
        name = "catppuccin",
        lazy = true,
        event = 'VeryLazy',
        config = configs.catppuccin,
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

    -- 语法高亮
    {
        'nvim-treesitter/nvim-treesitter',
        lazy = true,
        build = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end,
        init = function()
            local api = vim.api
            local init_group = api.nvim_create_augroup('init_treesitter', {
                clear = true,
            })
            api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
                group = init_group,
                pattern = '*',
                callback = function()
                        vim.fn.timer_start(300, function()
                            api.nvim_command [[Lazy load nvim-treesitter]]
                        end)
                        api.nvim_del_augroup_by_name('init_treesitter')
                end
            })
        end,
        -- event = {'BufRead', 'BufNewFile'},
        config = configs.nvim_treesitter,
        dependencies = {
            {'nvim-treesitter/nvim-treesitter-textobjects'},
            -- 彩虹括号
            {'p00f/nvim-ts-rainbow'},
            -- 参数高亮
            {'m-demare/hlargs.nvim', config = configs.hlargs},
            -- 高亮相同单词
            {
                'RRethy/vim-illuminate',
                config = configs.vim_illuminate,
            },
            -- 缩进线
            {
                'lukas-reineke/indent-blankline.nvim',
                config = configs.indent_blankline,
            },
        },
    },

    -- 注释着色
    {
        'folke/paint.nvim',
        lazy = true,
        init = function()
            vim.api.nvim_create_autocmd('filetype', {
                pattern = 'lua,python',
                once = true,
                callback = function()
                    vim.api.nvim_create_autocmd('CursorHold', {
                        once = true,
                        command = [[Lazy load paint.nvim]]
                    })
                end
            })
        end,
        config = configs.paint,
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
        config = true,
    },

    -- colorful window seperator
    {
        'nvim-zh/colorful-winsep.nvim',
        lazy = true,
        event = 'WinNew',
        config = configs.colorful_winsep,
    }
}
