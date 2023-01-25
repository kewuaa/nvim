local configs = require("plugins.tools.configs")


return {
    -- 测试启动时间
    {
        'dstein64/vim-startuptime',
        opt = true,
        cmd = 'StartupTime',
    },

    -- 缓存配置文件
    {
        'lewis6991/impatient.nvim',
        opt = false,
    },

    -- filetype speedup
    {
        'nathom/filetype.nvim',
        opt = false,
    },

    -- snippets
    {
        'rafamadriz/friendly-snippets',
        opt = false,
    },

    -- icons
    {
        'nvim-tree/nvim-web-devicons',
        opt = true,
    },

    -- zig filetype
    {
        'ziglang/zig.vim',
        opt = false,
        setup = [[vim.g.zig_fmt_autosave = 0]]
    },

    -- 异步依赖
    {
        'nvim-lua/plenary.nvim',
        opt = true,
    },

    -- 显示代码错误
    {
        'folke/trouble.nvim',
        opt = true,
        cmd = 'Trouble',
        config = configs.trouble,
    },

    -- 查找
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        opt = true,
        cmd = 'Telescope',
        config = configs.telescope,
        requires = {
            -- fzf支持
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                run = 'make',
                opt = true,
                config = configs.telescope_fzf_native,
            },
        }
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
        requires = {
            {
                'skywind3000/asynctasks.vim',
                opt = true,
            }
        },
    },

    -- quickfix window
    {
        'kevinhwang91/nvim-bqf',
        opt = true,
        ft = 'qf',
        config = configs.nvim_bqf,
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
            require("plugins"):delay_load_on_event(
                'gitsigns.nvim',
                1000,
                'BufRead',
                '*'
            )
        end,
        config = configs.gitsigns,
    },

    -- 文件树
    {
        'nvim-tree/nvim-tree.lua',
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
