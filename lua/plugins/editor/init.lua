local configs = require("plugins.editor.configs")


return {
    -- 选中编辑
    {
        'echasnovski/mini.surround',
        version = false,
        lazy = true,
        keys = {
            {'<leader>as', mode = {'n', 'x'}},
            {'<leader>ds', mode = 'n'},
            {'<leader>cs', mode = 'n'},
            {'<leader>fs', mode = {'n', 'o'}},
            {'<leader>Fs', mode = {'n', 'o'}},
            {'<leader>sh', mode = 'n'},
        },
        config = configs.mini_surround,
    },

    -- enhance textobject
    {
        'echasnovski/mini.ai',
        version = false,
        lazy = true,
        event = "VeryLazy",
        config = configs.mini_ai,
    },

    -- 高亮相同单词
    {
        'echasnovski/mini.cursorword',
        version = false,
        lazy = true,
        event = 'CursorHold',
        config = configs.mini_cursorword,
    },

    -- 括号补全
    {
        'echasnovski/mini.pairs',
        lazy = true,
        event = 'InsertEnter',
        config = configs.mini_pairs,
    },

    -- 与J相反的操作
    {
        'Wansmer/treesj',
        lazy = true,
        keys = {
            {'<leader>j', mode = 'n'}
        },
        config = configs.treesj,
    },
    {
        'echasnovski/mini.splitjoin',
        version = false,
        lazy = true,
        config = configs.mini_splitjoin,
    },

    -- 交换函数参数, 列表元素等
    {
        'mizlan/iswap.nvim',
        lazy = true,
        keys = {
            {'<leader>sp', '<cmd>ISwapWith<CR>', mode = 'n'}
        },
        config = configs.iswap,
    },

    -- match enhance
    {
        'utilyre/sentiment.nvim',
        version = '*',
        lazy = true,
        event = 'CursorHold',
        config = configs.sentiment,
    },

    -- 对齐
    {
        'echasnovski/mini.align',
        version = false,
        lazy = true,
        keys = {
            {'ga', mode = 'n'},
            {'gA', mode = 'n'},
        },
        config = true,
    },

    -- 缓冲区关闭时保留原有布局
    {
        'echasnovski/mini.bufremove',
        lazy = true,
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
    },

    -- sudo support
    {
        'lambdalisue/suda.vim',
        lazy = true,
        cmd = {"SudaRead", "SudaWrite"},
        init = function()
            vim.g["suda#prompt"] = "Enter administrator password: "
        end,
    },
}
