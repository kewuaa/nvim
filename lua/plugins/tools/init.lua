local configs = require("plugins.tools.configs")


return {
    -- 包管理工具
    {
        'williamboman/mason.nvim',
        lazy = true,
        build = ':MasonUpdate',
        config = configs.mason,
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
            require("core.keymaps"):load('asynctasks')()
            configs.asynctasks()
        end,
        cmd = {
            'AsyncRun',
            'AsyncTask',
            'AsyncTaskList',
            'AsyncTaskMacro',
            'AsyncTaskEdit',
            'AsyncTaskProfile'
        },
        dependencies = {
            {'skywind3000/asyncrun.vim'},
        },
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
                    vim.fn.timer_start(1000, function ()
                        require("lazy").load({plugins = {"gitsigns.nvim"}})
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
        'nvim-neo-tree/neo-tree.nvim',
        branch = 'v3.x',
        lazy = true,
        keys = {
            {'<leader>fe', '<cmd>Neotree toggle<CR>', mode = 'n'},
            {'<leader>ge', '<cmd>Neotree float git_status<CR>', mode = 'n'},
        },
        config = configs.neotree,
        dependencies = {
            {"nvim-lua/plenary.nvim"},
            {"nvim-tree/nvim-web-devicons"},
            {"MunifTanjim/nui.nvim"},
        }
    },

    -- 选择窗口
    {
        's1n7ax/nvim-window-picker',
        version = 'v1.*',
        keys = {
            { '<leader>w', function()
                local picked_window_id = require('window-picker').pick_window()
                if picked_window_id then
                    vim.api.nvim_set_current_win(picked_window_id)
                end
            end, mode = 'n' }
        },
        config = configs.nvim_window_picker,
    },

    -- 自动扩展窗口宽度
    {
        'nvim-focus/focus.nvim',
        version = false,
        lazy = true,
        init = require('core.keymaps'):load('focus'),
        event = 'WinNew',
        config = configs.focus,
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
        'potamides/pantran.nvim',
        lazy = true,
        keys = {
            {
                "<leader>tr",
                function() return require("pantran").motion_translate({target = "zh-CN"}) end,
                mode = {"n", "x"},
                expr = true,
            },
            {
                "<leader>trp",
                function()
                    require("pantran.command").parse(1, 0, "")
                    local im = require("core.utils.im")
                    im.toggle_imtoggle({silent = true, enabled = true})
                    vim.keymap.set(
                        "n",
                        "q",
                        function()
                            im.toggle_imtoggle({silent = true, enabled = false})
                            vim.cmd("q")
                        end,
                        { silent = true, buffer = 0 }
                    )
                end,
                mode = "n"
            }
        },
        config = configs.pantran,
    },

    -- code snapshot
    {
        "michaelrommel/nvim-silicon",
        lazy = true,
        cmd = "Silicon",
        config = configs.nvim_silicon,
    },
}
