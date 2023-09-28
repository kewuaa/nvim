local configs = require("plugins.lang.configs")


return {
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
                        vim.fn.timer_start(400, function()
                            api.nvim_command [[Lazy load nvim-treesitter]]
                        end)
                        api.nvim_del_augroup_by_name('init_treesitter')
                end
            })
        end,
        -- event = {'BufRead', 'BufNewFile'},
        module = false,
        config = configs.nvim_treesitter,
        dependencies = {
            {'nvim-treesitter/nvim-treesitter-textobjects'},
            -- 彩虹括号
            {'HiPhish/rainbow-delimiters.nvim', config = configs.rainbow_delimiters},
            -- 参数高亮
            {'m-demare/hlargs.nvim', config = configs.hlargs},
        },
    },

    -- fsharp
    {
        'adelarsq/neofsharp.vim',
        lazy = true,
        ft = 'fsharp',
    }
}
