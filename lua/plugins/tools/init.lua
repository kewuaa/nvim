local deps = require("deps")
local configs = require("plugins.tools.configs")


---------------------------------------------------------------------------------------------------
---package manager for lsp and dap
---------------------------------------------------------------------------------------------------
deps.add({
    source = "williamboman/mason.nvim",
    hooks = {
        post_checkout = function() vim.cmd("MasonUpdate") end,
        post_install = function()
            vim.schedule(function()
                vim.cmd("MasonUpdate")
            end)
        end
    },
    lazy_opts = {
        cmds = {"Mason", "MasonUpdate"},
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
deps.later(function()
    local opts = {silent = true, noremap = true}
    local map = vim.keymap.set
    map('n', '<leader>gg', '<cmd>DiffviewOpen<CR>', opts)
    map('n', '<leader>gc', '<cmd>DiffviewClose<CR>', opts)
    map({'n', 'v'}, '<leader>gh', '<cmd>DiffviewFileHistory<CR>', opts)
end)
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
deps.later(function()
    local opts = {silent = true, noremap = true}
    local map = vim.keymap.set
    map('n', '<A-q>', '<cmd>AsyncTask file-run<CR>', opts)
    map('n', '<leader><A-q>', '<cmd>AsyncTask file-build<CR>', opts)
    map('n', '<F5>', '<cmd>AsyncTask project-run<CR>', opts)
    map('n', '<leader><F5>', '<cmd>AsyncTask project-build<CR>', opts)
    map('n', '<leader>ot', '<cmd>AsyncTask open-terminal<CR>', opts)

    local cmd = vim.api.nvim_create_user_command
    cmd('GitCommit', 'AsyncTask git-commit', {})
    cmd('GitPush', 'AsyncTask git-push', {})
    cmd('GitCheckout', 'AsyncTask git-checkout', {})
    cmd('GitReset', 'AsyncTask git-reset', {})
    cmd('GitLog', 'AsyncTask git-log', {})
    configs.asynctasks()
end)
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
                    local im = require("utils.im")
                    im.toggle({silent = true, enabled = true})
                    vim.keymap.set(
                        "n",
                        "q",
                        function()
                            im.toggle({silent = true, enabled = false})
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
deps.later(function()
    local opts = {silent = true, noremap = true}
    local map = vim.keymap.set
    -- map('n', '<F6>', function() require('dap').continue() end, opts)
    map('n', '<F7>', function() require('dap').terminate() require('dapui').close() end, opts)
    -- map('n', '<F8>', function() require('dap').toggle_breakpoint() end, opts)
    map('n', '<F9>', function() require("dap").step_into() end, opts)
    map('n', '<F10>', function() require("dap").step_out() end, opts)
    map('n', '<F11>', function() require("dap").step_over() end, opts)
    -- map('n', '<leader>db', function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end, opts)
    map('n', '<leader>dc', function() require('dap').run_to_cursor() end, opts)
    map('n', '<leader>dl', function() require('dap').run_last() end, opts)
    map('n', '<leader>do', function() require('dap').repl.open() end, opts)
end)
deps.add({
    source = "mfussenegger/nvim-dap",
    lazy_opts = {
        keys = {
            {mode = 'n', lhs = '<F6>', rhs = function() require('dap').continue() end},
            {mode = 'n', lhs = '<F8>', rhs = function() require('dap').toggle_breakpoint() end},
            {mode = 'n', lhs = '<leader>db', rhs = function() require("dap").set_breakpoint(vim.fn.input("Breakpoint condition: ")) end},
        }
    },
    config = configs.nvim_dap,
    depends = {
        "nvim-neotest/nvim-nio",
        "rcarriga/nvim-dap-ui",
        "theHamsta/nvim-dap-virtual-text"
    }
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
                    local utils = require("utils")
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
                    local utils = require("utils")
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

---------------------------------------------------------------------------------------------------
---preview markdown
---------------------------------------------------------------------------------------------------
deps.add({
    source = "iamcco/markdown-preview.nvim",
    hooks = {
        post_install = function()
            vim.schedule(vim.fn["mkdp#util#install"])
        end,
    },
    lazy_opts = {
        cmds = {"MarkdownPreviewToggle"},
        delay_install = true,
    }
})
