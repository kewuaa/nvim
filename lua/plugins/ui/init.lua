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
            -- 颜色主题
            {
                'folke/tokyonight.nvim',
                branch = 'main',
                config = configs.tokyonight,
            },
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
            local loaded = false
            local init_group = api.nvim_create_augroup('init_treesitter', {
                clear = true,
            })
            api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
                group = init_group,
                pattern = '*',
                callback = function()
                    if loaded then
                        api.nvim_del_augroup_by_name('init_treesitter')
                    else
                        vim.fn.timer_start(100, function()
                            api.nvim_command [[Lazy load nvim-treesitter]]
                        end)
                        loaded = true
                    end
                end
            })
        end,
        -- event = {'BufRead', 'BufNewFile'},
        config = configs.nvim_treesitter,
        dependencies = {
            -- 彩虹括号
            {'p00f/nvim-ts-rainbow'},
            -- 参数高亮
            {'m-demare/hlargs.nvim', config = configs.hlargs},
            -- 缩进线
            {
                'lukas-reineke/indent-blankline.nvim',
                config = configs.indent_blankline,
            },
            -- 高亮相同单词
            {
                'RRethy/vim-illuminate',
                config = configs.vim_illuminate,
            },
        },
    },

    -- 消息提示
    {
        'rcarriga/nvim-notify',
        lazy = true,
        event = 'VeryLazy',
        config = configs.notify,
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
                blend = 0
            }
        },
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
