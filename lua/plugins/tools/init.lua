local deps = require("core.deps")
local configs = require("plugins.tools.configs")


---------------------------------------------------------------------------------------------------
---package manager for lsp and dap
---------------------------------------------------------------------------------------------------
deps.add({
    source = "williamboman/mason.nvim",
    hooks = {
        post_checkout = function() vim.cmd("MasonUpdate") end
    },
    lazy_opts = {
        cmds = {"Mason"},
        events = {"BufRead", "BufNewFile"}
    },
    config = configs.mason
})

---------------------------------------------------------------------------------------------------
---git signs
---------------------------------------------------------------------------------------------------
deps.add({
    source = "lewis6991/gitsigns.nvim",
    lazy_opts = {
        events = {"BufRead"},
        delay = 1000,
    },
    config = configs.gitsigns
})

---------------------------------------------------------------------------------------------------
---diff view
---------------------------------------------------------------------------------------------------
deps.add({
    source = "sindrets/diffview.nvim",
    lazy_opts = {
        events = {"CmdUndefined Diffview*"},
    },
    config = function()
        require("diffview").setup()
    end,
    depends = {"nvim-lua/plenary.nvim"}
})

---------------------------------------------------------------------------------------------------
---task runner
---------------------------------------------------------------------------------------------------
deps.later(configs.asynctasks)
deps.add({
    source = "skywind3000/asynctasks.vim",
    lazy_opts = {
        cmds = {
            'AsyncRun',
            'AsyncTask',
            'AsyncTaskList',
            'AsyncTaskMacro',
            'AsyncTaskEdit',
            'AsyncTaskProfile'
        }
    },
    depends = {"skywind3000/asyncrun.vim"}
})

---------------------------------------------------------------------------------------------------
---quickfix enhance
---------------------------------------------------------------------------------------------------
deps.add({
    source = "kevinhwang91/nvim-bqf",
    lazy_opts = {
        events = {"FileType qf"},
    },
    config = function()
        require("bqf").setup()
    end
})

---------------------------------------------------------------------------------------------------
---sudo
---------------------------------------------------------------------------------------------------
deps.later(function()
    vim.g["suda#prompt"] = "Enter administrator password: "
end)
deps.add({
    source = "lambdalisue/vim-suda",
    lazy_opts = {
        cmds = {"SudaRead", "SudaWrite"}
    },
})

---------------------------------------------------------------------------------------------------
---translator
---------------------------------------------------------------------------------------------------
deps.add({
    source = "potamides/pantran.nvim",
    lazy_opts = {
        keys = {
            {
                mode = {"n", "x"},
                lhs = "<leader>tr",
                rhs = function() return require("pantran").motion_translate({target = "zh-CN"}) end,
                opts = {expr = true}
            },
            {
                mode = "n",
                lhs = "<leader>trp",
                rhs = function()
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
            }
        }
    },
    config = configs.pantran
})

---------------------------------------------------------------------------------------------------
---debuger
---------------------------------------------------------------------------------------------------
deps.add({
    source = "mfussenegger/nvim-dap",
    lazy_opts = {},
    config = configs.nvim_dap
})

---------------------------------------------------------------------------------------------------
---picker
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.pick",
    lazy_opts = {
        keys = {
            {
                mode = "n",
                lhs = "<leader>ff",
                rhs = function()
                    local utils = require("core.utils")
                    require("mini.pick").builtin.files(nil, {
                        source = {
                            cwd = utils.get_cwd(),
                        }
                    })
                end
            },
            {
                mode = "n",
                lhs = "<leader>fg",
                rhs = function()
                    local utils = require("core.utils")
                    require("mini.pick").builtin.grep_live(nil, {
                        source = {
                            cwd = utils.get_cwd(),
                        }
                    })
                end
            },
            {
                mode = "n",
                lhs = "<leader>fb",
                rhs = function()
                    require("mini.pick").builtin.buffers()
                end
            }
        }
    },
    config = configs.mini_pick
})

---------------------------------------------------------------------------------------------------
---file manager
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.files",
    lazy_opts = {
        keys = {
            {mode = "n", lhs = "<leader>fe", rhs = function()
                require("mini.files").open()
            end}
        }
    },
    config = configs.mini_files
})
