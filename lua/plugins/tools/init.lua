local configs = require("plugins.tools.configs")


return {
    -- filetype speedup
    { 'nathom/filetype.nvim' },

    -- zig filetype
    {
        'ziglang/zig.vim',
        lazy = false,
        init = function()
            vim.g.zig_fmt_autosave = 0
        end,
    },

    -- 显示代码错误
    {
        'folke/trouble.nvim',
        lazy = true,
        cmd = 'Trouble',
        config = configs.trouble,
        dependencies = {
            {'nvim-tree/nvim-web-devicons'},
        }
    },

    -- 查找
    {
        'nvim-telescope/telescope.nvim',
        branch = '0.1.x',
        lazy = true,
        init = require('core.keymaps'):load('telescope'),
        cmd = 'Telescope',
        config = configs.telescope,
        dependencies = {
            {'nvim-lua/plenary.nvim'},
            {'nvim-tree/nvim-web-devicons'},
            -- fzf支持
            {
                'nvim-telescope/telescope-fzf-native.nvim',
                build = 'make',
            },
        }
    },

    -- 运行
    {
        'skywind3000/asynctasks.vim',
        lazy = true,
        init = require('core.keymaps'):load('asynctasks'),
        cmd = {
            'AsyncTask',
            'AsyncTaskList',
            'AsyncTaskMacro',
            'AsyncTaskEdit',
        },
        config = configs.asynctasks,
        dependencies = {
            {'skywind3000/asyncrun.vim'},
        },
    },

    -- quickfix window
    {
        'kevinhwang91/nvim-bqf',
        lazy = true,
        ft = 'qf',
        config = configs.nvim_bqf,
    },

    -- float terminal
    {
        'akinsho/toggleterm.nvim',
        version = '*',
        init = require('core.keymaps'):load('toggleterm'),
        cmd = 'ToggleTerm',
        config = configs.toggleterm,
    },

    -- git集成
    {
        'lewis6991/gitsigns.nvim',
        lazy = true,
        init = function ()
            vim.api.nvim_create_autocmd('BufRead', {
                pattern = '*',
                once = true,
                callback = function()
                    vim.fn.timer_start(500, configs.gitsigns)
                end
            })
        end,
        -- event = 'BufRead',
        -- config = configs.gitsigns,
    },

    -- 文件树
    {
        'nvim-tree/nvim-tree.lua',
        lazy = true,
        init = require('core.keymaps'):load('nvim_tree'),
        cmd = 'NvimTreeToggle',
        config = configs.nvim_tree,
        dependencies = {
            {'nvim-tree/nvim-web-devicons'},
        }
    },

    -- 自动扩展窗口宽度
    {
        'anuvyklack/windows.nvim',
        lazy = true,
        init = require('core.keymaps'):load('windows'),
        event = 'CmdLineEnter',
        config = configs.windows,
        dependencies = {
            {"anuvyklack/middleclass"}
        },
    },

    -- 缓冲区管理
    {
        'matbme/JABS.nvim',
        lazy = true,
        init = require('core.keymaps'):load('JABS'),
        cmd = 'JABSOpen',
        config = configs.JABS,
        dependencies = {
            {'nvim-tree/nvim-web-devicons'},
        }
    },
}
