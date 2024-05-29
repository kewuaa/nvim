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
        -- init = function()
        --     local api = vim.api
        --     api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
        --         desc = "delay load nvim-treesitter",
        --         once = true,
        --         callback = function()
        --             vim.fn.timer_start(400, function()
        --                 require("lazy").load({plugins = {"nvim-treesitter"}})
        --             end)
        --         end
        --     })
        -- end,
        event = {'BufRead', 'BufNewFile'},
        module = false,
        config = configs.nvim_treesitter,
        dependencies = {
            -- 彩虹括号
            {'HiPhish/rainbow-delimiters.nvim', config = configs.rainbow_delimiters},
            {'nvim-treesitter/nvim-treesitter-textobjects', config = configs.nvim_treesitter_textobjects},
        },
    },
}
