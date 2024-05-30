local configs = require("plugins.tools.configs")


return {
    -- 包管理工具
    {
        'williamboman/mason.nvim',
        lazy = true,
        build = ':MasonUpdate',
        config = configs.mason,
    },

    -- 查找
    {
        'echasnovski/mini.pick',
        version = false,
        lazy = true,
        keys = {
            {
                "<leader>ff",
                function()
                    local utils = require("core.utils")
                    require("mini.pick").builtin.files(nil, {
                        source = {
                            cwd = utils.get_cwd(),
                        }
                    })
                end,
                mode = "n",
            },
            {
                "<leader>fg",
                function()
                    local utils = require("core.utils")
                    require("mini.pick").builtin.grep_live(nil, {
                        source = {
                            cwd = utils.get_cwd(),
                        }
                    })
                end,
                mode = "n",
            },
            {
                "<leader>fb",
                function()
                    require("mini.pick").builtin.buffers()
                end,
                mode = "n",
            },
        },
        config = configs.mini_pick,
    },

    {
        'kevinhwang91/nvim-bqf',
        lazy = true,
        ft = "qf",
        config = true
    },

    -- debug
    {
        'mfussenegger/nvim-dap',
        lazy = true,
        init = require('core.keymaps'):load('dap'),
        config = configs.nvim_dap,
        dependencies = {
            {
                'rcarriga/nvim-dap-ui',
                dependencies = {"nvim-neotest/nvim-nio"}
            },
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
                desc = "delay load gitsigns.nvim",
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

    -- file manager
    {
        'echasnovski/mini.files',
        version = false,
        lazy = true,
        keys = {
            {"<leader>fe", function()
                require("mini.files").open()
            end, mode = "n"}
        },
        config = true,
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
}
