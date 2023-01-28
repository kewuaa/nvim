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

    -- 括号补全
    {
        'windwp/nvim-autopairs',
        lazy = true,
        event = 'InsertCharPre',
        config = configs.nvim_autopairs,
    },

    -- 快速移动
    {
        'phaazon/hop.nvim',
        lazy = true,
        branch = 'v2',
        init = require('core.keymaps'):load('hop'),
        event = 'CmdUndefined Hop*',
        config = configs.hop,
    },

    -- 注释
    {
        'numToStr/Comment.nvim',
        lazy = true,
        keys = {
            {'gcc', mode = 'n'},
            {'gbc', mode = 'n'},
            {'gc', mode = 'n'},
            {'gb', mode = 'n'},
            {'gc', mode = 'x'},
            {'gb', mode = 'x'},
        },
        config = configs.comment,
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

    -- 扩展区域
    {
        'terryma/vim-expand-region',
        lazy = true,
        keys = {
            {'+', mode = {'n', 'v'}},
            {'-', mode = 'v'},
        },
    },

    -- 与J相反的操作
    {
        'Wansmer/treesj',
        lazy = true,
        keys = {
            {'<leader>j', '<cmd>TSJToggle<CR>', mode = 'n'}
        },
        config = configs.treesj,
    },

    -- 交换函数参数, 列表元素等
    {
        'mizlan/iswap.nvim',
        lazy = true,
        keys = {
            {'<leader>sw', '<cmd>ISwapWith<CR>', mode = 'n'}
        },
        config = configs.iswap,
    },

    -- 高亮相同单词
    {
        'RRethy/vim-illuminate',
        lazy = true,
        event = 'VeryLazy',
        config = configs.vim_illuminate,
    },

    -- 调暗未使用函数，变量和参数
    {
        'zbirenbaum/neodim',
        lazy = true,
        event = 'LspAttach',
        config = configs.neodim,
    },

    -- 移动块
    {
        'booperlv/nvim-gomove',
        lazy = true,
        keys = {
            {'<A-h>', mode = {'n', 'x'}},
            {'<A-l>', mode = {'n', 'x'}},
            {'<A-j>', mode = {'n', 'x'}},
            {'<A-k>', mode = {'n', 'x'}},
            {'<A-S-h>', mode = {'n', 'x'}},
            {'<A-S-l>', mode = {'n', 'x'}},
            {'<A-S-j>', mode = {'n', 'x'}},
            {'<A-S-k>', mode = {'n', 'x'}},
        },
        config = configs.nvim_gomove,
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

    -- 搜索替换
    {
        'roobert/search-replace.nvim',
        lazy = true,
        init = require('core.keymaps'):load('search_replace'),
        event = 'CmdUndefined SearchReplace*',
        config = configs.search_replace,
    },

    -- 实时预览命令结果
    {
        'smjonas/live-command.nvim',
        lazy = true,
        cmd = 'Norm',
        config = configs.live_command,
    },

    -- 搜索后自动关闭高亮
    {
        'romainl/vim-cool',
        lazy = true,
        init = function()
            vim.g.CoolTotalMatches = 1
        end,
        event = 'CmdLineEnter',
        keys = {
            {'n', mode = 'n'},
            {'N', mode = 'n'},
        },
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
            {'<leader>bd', '<cmd>Bdelete<CR>', mode = 'n'}
        },
    },
}
