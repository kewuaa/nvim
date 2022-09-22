local configs = require("plugins.tools.configs")


return {
    -- 图标
    {
        'kyazdani42/nvim-web-devicons',
        opt = true,
    },

    -- 启动时间
    {
        'dstein64/vim-startuptime',
        opt = true,
        cmd = 'StartupTime',
    },

    -- 语法高亮
    {
        'nvim-treesitter/nvim-treesitter',
        opt = true,
        run = function() require('nvim-treesitter.install').update({ with_sync = true }) end,
        event = {'BufNewFile *', 'BufReadPre *'},
        cmd = {'TSInstall', 'TSInstallInfo', 'TsEnable'},
        config = configs.nvim_treesitter,
        requires = {
            -- 彩虹括号
            {'p00f/nvim-ts-rainbow', opt = true},
        },
    },

    -- 上下文显示
    {
        'SmiteshP/nvim-gps',
        opt = true,
        event = 'BufRead *',
        config = configs.nvim_gps,
    },

    -- 缩进线
    {
        'lukas-reineke/indent-blankline.nvim',
        opt = true,
        event = 'BufRead *',
        config = configs.indent_blankline,
    },

    -- 显示代码错误
    {
        'folke/trouble.nvim',
        opt = true,
        cmd = 'Trouble',
        config = configs.trouble,
    },

    -- symbols tree
    {
        'simrat39/symbols-outline.nvim',
        opt = true,
        cmd = 'SymbolsOutline',
        config = configs.symbols_outline,
    },

    -- 异步依赖
    {
        'nvim-lua/plenary.nvim',
        opt = true,
    },
    -- 查找
    {
        'nvim-telescope/telescope.nvim',
        -- tag = '0.1.0',
        branch = '0.1.x',
        opt = true,
        cmd = 'Telescope',
        config = configs.telescope,
    },
    -- fzf支持
    {
        'nvim-telescope/telescope-fzf-native.nvim',
        run = 'make',
        opt = true,
    },

    -- 异步任务系统
    {
        'skywind3000/asynctasks.vim',
        opt = true,
        cmd = {'AsyncTask', 'AsyncTaskEdit', 'AsyncTaskList', 'AsyncTaskMacro'},
        config = configs.asynctasks,
        -- 异步运行
        requires = {
            {'skywind3000/asyncrun.vim', opt = true},
        },
    },

    -- terminal help
    {
        'skywind3000/vim-terminal-help',
        opt = true,
        keys = {{'n', '<M-=>'}},
        config = configs.vim_terminal_help,
    },

    -- git集成
    {
        'lewis6991/gitsigns.nvim',
        opt = true,
        setup = function()
            vim.api.nvim_create_autocmd('BufRead', {
                group = 'setup_plugins',
                pattern = '*',
                once = true,
                callback = function()
                    vim.fn.timer_start(1000, function()
                        vim.cmd [[exe 'PackerLoad gitsigns.nvim']] end)
                end,
            })
        end,
        config = configs.gitsigns,
    },

    -- 翻译
    {
        'voldikss/vim-translator',
        opt = true,
        cmd = {
            'Translate',
            'TranslateW',
            'TranslateR',
            'TranslateX',
            'TranslateH',
            'TranslateL',
        },
        setup = configs.vim_translator,
    },

    -- 文件树
    {
        'kyazdani42/nvim-tree.lua',
        opt = true,
        cmd = 'NvimTreeToggle',
        config = configs.nvim_tree,
    },

    -- 缓冲区关闭时保留原有布局
    {
        'famiu/bufdelete.nvim',
        opt = true,
        cmd = 'Bdelete',
    },

    -- 缓冲区管理
    {
        'matbme/JABS.nvim',
        opt = true,
        cmd = 'JABSOpen',
        config = configs.JABS,
    },
}
