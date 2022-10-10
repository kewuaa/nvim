local configs = require("plugins.tools.configs")


return {
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
        event = 'BufRead *',
        cmd = {'TSInstall', 'TSInstallInfo', 'TsEnable'},
        config = configs.nvim_treesitter,
        requires = {
            -- 彩虹括号
            {'p00f/nvim-ts-rainbow', opt = true},
            -- 参数高亮
            {
                'm-demare/hlargs.nvim',
                opt = true,
                config = configs.hlargs,
            },
        },
    },

    -- 显示代码错误
    {
        'folke/trouble.nvim',
        opt = true,
        cmd = 'Trouble',
        config = configs.trouble,
    },

    -- 异步依赖
    {
        'nvim-lua/plenary.nvim',
        opt = true,
    },
    -- 查找
    {
        'nvim-telescope/telescope.nvim',
        tag = '0.1.0',
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

    -- 运行
    {
        'skywind3000/asyncrun.vim',
        opt = true,
        cmd = {
            'AsyncTask',
            'AsyncTaskList',
            'AsyncTaskMacro',
            'AsyncTaskEdit',
        },
        config = configs.asyncrun,
        requires = {'skywind3000/asynctasks.vim', opt = true},
    },

    -- float terminal
    {
        'akinsho/toggleterm.nvim',
        tag = '*',
        cmd = 'ToggleTerm',
        config = configs.toggleterm,
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
                        vim.cmd [[
                        exe 'PackerLoad gitsigns.nvim'
                        ]]
                    end)
                end,
            })
        end,
        config = configs.gitsigns,
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
