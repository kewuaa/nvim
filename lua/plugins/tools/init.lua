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

    -- wilder
    {
        'gelguy/wilder.nvim',
        lazy = true,
        event = 'CmdlineEnter',
        config = configs.wilder,
    },

    -- debug
    {
        'mfussenegger/nvim-dap',
        lazy = true,
        init = require('core.keymaps'):load('dap'),
        config = configs.nvim_dap,
        dependencies = {
            {'rcarriga/nvim-dap-ui'},
            {'theHamsta/nvim-dap-virtual-text'},
            -- dap source for cmp
            {'rcarriga/cmp-dap'},
        }
    },

    -- 运行
    {
        'skywind3000/asynctasks.vim',
        lazy = true,
        init = function()
            require('core.keymaps'):load('asynctasks')()
            configs.asynctasks()
        end,
        cmd = {
            'AsyncTask',
            'AsyncTaskList',
            'AsyncTaskMacro',
            'AsyncTaskEdit',
        },
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

    -- git集成
    {
        'lewis6991/gitsigns.nvim',
        lazy = true,
        init = function ()
            vim.api.nvim_create_autocmd('BufRead', {
                pattern = '*',
                once = true,
                callback = function()
                    vim.fn.timer_start(900, function ()
                        vim.api.nvim_command [[Lazy load gitsigns.nvim]]
                    end)
                end
            })
        end,
        -- event = 'BufRead',
        config = configs.gitsigns,
    },
    {
        'sindrets/diffview.nvim',
        lazy = true,
        init = require('core.keymaps'):load('diffview'),
        event = 'CmdUndefined Diffview*',
        config = true,
        dependencies = {
            {'nvim-lua/plenary.nvim'}
        }
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

    -- 选择缓冲区
    {
        'matbme/JABS.nvim',
        lazy = true,
        keys = {
            {'<leader>bb', '<cmd>JABSOpen<CR>', mode = 'n'}
        },
        config = true,
    },

    -- 选择窗口
    {
        'https://gitlab.com/yorickpeterse/nvim-window.git',
        lazy = true,
        keys = {
            { '<leader>w', function() require('nvim-window').pick() end, mode = 'n' }
        },
        config = configs.nvim_window,
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

    -- 着色器
    {
        'norcalli/nvim-colorizer.lua',
        lazy = true,
        cmd = 'ColorizerToggle',
        config = true,
    },

    -- vimdoc 中文文档
    {
        'yianwillis/vimcdoc',
        lazy = true,
        event = 'VeryLazy',
    },
}
