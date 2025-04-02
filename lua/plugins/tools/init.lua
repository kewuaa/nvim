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
---search and replace
---------------------------------------------------------------------------------------------------
deps.add({
    source = "MagicDuck/grug-far.nvim",
    lazy_opts = {
        delay_install = true,
        keys = {
            {
                mode = {"n", "v"},
                lhs = "<leader>sr",
                rhs = function()
                    local grug = require("grug-far")
                    local ext = vim.bo.buftype == "" and vim.fn.expand("%:e")
                    grug.open({
                        transient = true,
                        prefills = {
                            filesFilter = ext and ext ~= "" and "*." .. ext or nil,
                        },
                    })
                end,
                opts = {
                    desc = "Search and Replace"
                }
            }
        }
    },
    config = function()
        require("grug-far").setup({
            headerMaxWidth = 80,
        })
    end
})

---------------------------------------------------------------------------------------------------
---git helper
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini-git",
    lazy_opts = {
        events = {"BufRead"},
        cmds = {"Git"},
        -- keys = {
        --     {
        --         mode = "n",
        --         lhs = "<leader>gs",
        --     },
        --     {
        --         mode = "v",
        --         lhs = "<leader>gs",
        --     }
        -- }
    },
    config = configs.mini_git,
})

---------------------------------------------------------------------------------------------------
---git signs
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.diff",
    lazy_opts = {
        events = {"BufRead"},
        delay = 1000,
    },
    config = configs.mini_diff,
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
        },
        delay_install = true
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
        },
        delay_install = true
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
deps.later(function()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.ui.select =  function(items, opts, on_choice)
        if not require("deps.handle").if_loaded("mini.pick") then
            vim.api.nvim_exec_autocmds(
                "User",
                {pattern = "LoadMiniPick", modeline = false}
            )
        end
        local mini_pick = require("mini.pick")
        mini_pick.ui_select(items, opts, on_choice)
    end
end)
deps.add({
    source = "echasnovski/mini.pick",
    lazy_opts = {
        events = {"User LoadMiniPick"},
        keys = {
            {
                mode = "n",
                lhs = "<leader>ff",
                rhs = function()
                    require("mini.pick").builtin.files()
                end
            },
            {
                mode = "n",
                lhs = "<leader>fg",
                rhs = function()
                    require("mini.pick").builtin.grep_live()
                end
            },
            {
                mode = "n",
                lhs = "<leader>fb",
                rhs = function()
                    require("mini.pick").builtin.buffers()
                end
            },
            {
                mode = "n",
                lhs = "<leader>fd",
                rhs = function()
                    require("mini.extra").pickers.diagnostic()
                end
            },
            {
                mode = "n",
                lhs = "<leader>fh",
                rhs = function()
                    require("mini.extra").pickers.git_hunks()
                end
            },
            {
                mode = "n",
                lhs = "<leader>fO",
                rhs = function()
                    require("mini.extra").pickers.lsp({ scope = "document_symbol" })
                end
            },
            {
                mode = "n",
                lhs = "<leader>fs",
                rhs = function()
                    require("mini.extra").pickers.lsp({ scope = "workspace_symbol" })
                end
            },
            {
                mode = "n",
                lhs = "<leader>fr",
                rhs = function()
                    require("mini.pick").builtin.resume()
                end
            }
        }
    },
    config = configs.mini_pick,
    depends = {
        {
            source = "echasnovski/mini.extra",
            config = function() require("mini.extra").setup() end
        }
    }
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
            end},
        }
    },
    config = configs.mini_files
})

---------------------------------------------------------------------------------------------------
--- misc
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.misc",
    lazy_opts = {
        very_lazy = true
    },
    config = configs.mini_misc
})
