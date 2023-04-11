local configs = require("plugins.lang.configs")


return {
    -- filetype speedup
    {
        'nathom/filetype.nvim',
        lazy = false,
        config = configs.filetype,
    },

    -- zig filetype
    -- {
    --     'ziglang/zig.vim',
    --     lazy = false,
    --     init = function()
    --         vim.g.zig_fmt_autosave = 0
    --     end,
    -- },

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
        module = false,
        config = configs.nvim_treesitter,
        dependencies = {
            {'nvim-treesitter/nvim-treesitter-textobjects'},
            -- 彩虹括号
            {'mrjones2014/nvim-ts-rainbow'},
            -- 参数高亮
            {'m-demare/hlargs.nvim', config = configs.hlargs},
        },
    },

    -- lint system
    {
        'mfussenegger/nvim-lint',
        lazy = true,
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'pyrex',
                once = true,
                callback = function()
                    vim.fn.timer_start(
                        600,
                        function()
                            vim.api.nvim_command [[Lazy load nvim-lint]]
                        end
                    )
                end
            })
        end,
        config = configs.nvim_lint,
    },
}
