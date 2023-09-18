local configs = require("plugins.editor.configs")


return {
    -- 选中编辑
    {
        'kylechui/nvim-surround',
        version = '*',
        lazy = true,
        keys = {
            {'ys', mode = 'n'},
            {'yss', mode = 'n'},
            {'yS', mode = 'n'},
            {'ySS', mode = 'n'},
            {'ds', mode = 'n'},
            {'cs', mode = 'n'},
            {'<c-g>s', mode = 'i'},
            {'<c-g>S', mode = 'i'},
            {'S', mode = 'x'},
            {'gS', mode = 'x'},
        },
        config = configs.nvim_surround,
    },

    -- 高亮相同单词
    {
        'RRethy/vim-illuminate',
        lazy = true,
        event = 'CursorHold',
        config = configs.vim_illuminate,
    },

    -- 括号补全
    {
        'm4xshen/autoclose.nvim',
        lazy = true,
        event = 'InsertEnter',
        config = configs.autoclose,
    },

    -- 注释
    {
        'numToStr/Comment.nvim',
        lazy = true,
        keys = {
            {'gcc', mode = 'n'},
            {'gbc', mode = 'n'},
            {'gc', mode = {'n', 'x'}},
            {'gb', mode = {'n', 'x'}},
        },
        config = configs.comment,
    },

    -- 跳出对
    {
        'abecodes/tabout.nvim',
        lazy = true,
        keys = {
            {'<c-l>', function() require('tabout').taboutMulti() end, mode = 'i'},
            {'<c-h>', function() require('tabout').taboutBackMulti() end, mode = 'i'}
        },
        config = configs.tabout,
    },

    -- TODO 注释
    {
        'folke/todo-comments.nvim',
        lazy = true,
        init = require('core.keymaps'):load('todo_comments'),
        cmd = {
            'TodoQuickFix',
            'TodoLocList',
            'TodoTrouble',
            'TodoTelescope',
        },
        config = true,
        dependencies = {
            {'nvim-lua/plenary.nvim'},
        }
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

    -- jk增强
    {
        'rainbowhxch/accelerated-jk.nvim',
        lazy = true,
        keys = {
            {'j', mode = 'n'},
            {'k', mode = 'n'},
        },
        config = configs.accelerated_jk,
    },

    -- 实时预览命令结果
    {
        'smjonas/live-command.nvim',
        lazy = true,
        event = 'CmdLineEnter :',
        config = configs.live_command,
    },

    -- match enhance
    {
        'utilyre/sentiment.nvim',
        version = '*',
        lazy = true,
        event = 'CursorHold',
        config = configs.sentiment,
    },

    -- 搜索后自动关闭高亮
    {
        'romainl/vim-cool',
        lazy = true,
        event = 'CursorMoved',
    },

    --  peeks lines of the buffer in non-obtrusive way
    {
        'nacro90/numb.nvim',
        lazy = true,
        event = 'CmdLineEnter :',
        config = configs.numb,
    },

    -- 缓冲区关闭时保留原有布局
    {
        'famiu/bufdelete.nvim',
        lazy = true,
        keys = {
            {'<leader>bD', '<cmd>Bdelete<CR>', mode = 'n'}
        },
    },
}
