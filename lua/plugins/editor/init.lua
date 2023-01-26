local configs = require("plugins.editor.configs")


return {
    -- 选中编辑
    {
        'kylechui/nvim-surround',
        tag = '*',
        opt = true,
        keys = {
            {'n', 'ys'},
            {'n', 'yss'},
            {'n', 'yS'},
            {'n', 'ySS'},
            {'n', 'ds'},
            {'n', 'cs'},
            {'i', '<c-g>s'},
            {'i', '<c-g>S'},
            {'x', 'S'},
            {'x', 'gS'},
        },
        config = configs.nvim_surround,
    },

    -- 快速移动
    {
        'phaazon/hop.nvim',
        opt = true,
        branch = 'v2',
        cmd = {
            'HopWord',
            'HopChar1',
            'HopChar2',
            'HopLine',
            'HopPattern',
        },
        config = configs.hop,
    },

    -- 注释
    {
        'numToStr/Comment.nvim',
        opt = true,
        keys = {
            {'n', 'gcc'},
            {'n', 'gbc'},
            {'n', 'gc'},
            {'n', 'gb'},
            {'x', 'gc'},
            {'x', 'gb'},
        },
        config = configs.comment,
    },

    -- TODO 注释
    {
        'folke/todo-comments.nvim',
        opt = true,
        cmd = {
            'TodoQuickFix',
            'TodoLocList',
            'TodoTrouble',
            'TodoTelescope',
        },
        config = configs.todo_comments,
    },

    -- 扩展区域
    {
        'terryma/vim-expand-region',
        opt = true,
        keys = {
            {'n', '+'},
            {'v', '+'},
            {'v', '-'},
        },
    },

    -- 与J相反的操作
    {
        'Wansmer/treesj',
        opt = true,
        cmd = 'TSJToggle',
        config = configs.treesj,
    },

    -- 交换函数参数, 列表元素等
    {
        'mizlan/iswap.nvim',
        opt = true,
        cmd = {'ISwap', 'ISwapWith'},
        config = configs.iswap,
    },

    -- 高亮相同单词
    {
        'RRethy/vim-illuminate',
        opt = true,
        after = 'lspsaga.nvim',
        config = configs.vim_illuminate,
    },

    -- 调暗未使用函数，变量和参数
    {
        'zbirenbaum/neodim',
        opt = true,
        event = 'LspAttach',
        config = configs.neodim,
    },

    -- 移动块
    {
        'booperlv/nvim-gomove',
        opt = true,
        keys = {
            {'x', '<A-h>'},
            {'x', '<A-l>'},
            {'x', '<A-j>'},
            {'x', '<A-k>'},
            {'n', '<A-h>'},
            {'n', '<A-l>'},
            {'n', '<A-j>'},
            {'n', '<A-k>'},
            {'x', '<A-S-h>'},
            {'x', '<A-S-l>'},
            {'x', '<A-S-j>'},
            {'x', '<A-S-k>'},
            {'n', '<A-S-h>'},
            {'n', '<A-S-l>'},
            {'n', '<A-S-j>'},
            {'n', '<A-S-k>'},
        },
        config = configs.nvim_gomove,
    },

    -- jk增强
    {
        'rainbowhxch/accelerated-jk.nvim',
        opt = true,
        keys = {{'n', 'j'}, {'n', 'k'}},
        config = configs.accelerated_jk,
    },

    -- 搜索后自动关闭高亮
    {
        'romainl/vim-cool',
        opt = true,
        event = 'CmdLineEnter /',
        keys = {
            {'n', 'n'},
            {'n', 'N'},
        },
        setup = 'vim.g.CoolTotalMatches = 1',
    },
}
