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
                    vim.fn.timer_start(700, configs.gitsigns)
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
        keys = {
            {'<leader>tt', '<cmd>NvimTreeToggle<CR>', mode = 'n'}
        },
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
        event = 'WinNew',
        config = configs.windows,
        dependencies = {
            {"anuvyklack/middleclass"}
        },
    },

    -- markdown preview
    {
        'iamcco/markdown-preview.nvim',
        lazy = true,
        build = function() vim.fn["mkdp#util#install"]() end,
        ft = 'markdown',
        init = configs.markdown_preview,
    },

    -- 翻译
    {
        'voldikss/vim-translator',
        lazy = true,
        keys = {
            {'<leader>tw', '<cmd>TranslateW<CR>', mode = 'n'},
            {'<leader>tw', "<cmd>'<,'>TranslateW<CR>", mode = 'v'},
        },
        init = configs.vim_translator,
    },

    -- vimdoc 中文文档
    {
        'yianwillis/vimcdoc',
        lazy = true,
        event = 'VeryLazy',
    },

    -- bigfile tools
    {
        'LunarVim/bigfile.nvim',
        lazy = true,
        event = 'BufReadPre',
        config = configs.bigfile,
    },
}
