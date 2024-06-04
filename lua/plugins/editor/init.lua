local configs = require("plugins.editor.configs")
local deps = require("core.deps")

---------------------------------------------------------------------------------------------------
---enhance textobjects
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.ai",
    lazy_opts = {
        very_lazy = true
    },
    config = configs.mini_ai
})

---------------------------------------------------------------------------------------------------
---text align
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.align",
    lazy_opts = {
        keys = {
            {mode = "n", lhs = "ga"},
            {mode = "n", lhs = "gA"},
        }
    },
    config = function()
        require("mini.align").setup()
    end
})

---------------------------------------------------------------------------------------------------
---buffer remove
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.bufremove",
    lazy_opts = {
        keys = {
            {
                mode = "n",
                lhs = "<leader>bd",
                rhs = function() require("mini.bufremove").delete(0, false) end,
                opts = {
                    desc = "Delete Buffer",
                }
            },
            {
                mode = "n",
                lhs = "<leader>bD",
                rhs = function() require("mini.bufremove").delete(0, true) end,
                opts = {
                    desc = "Delete Buffer (Force)",
                }
            },
        }
    },
    config = function()
        require("mini.bufremove").setup()
    end
})

---------------------------------------------------------------------------------------------------
---illumunate cursor word
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.cursorword",
    lazy_opts = {
        events = {"CursorHold"}
    },
    config = configs.mini_cursorword
})

---------------------------------------------------------------------------------------------------
---surround
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.surround",
    lazy_opts = {
        keys = {
            {mode = {"n", "x"}, lhs = "<leader>as"},
            {mode = "n", lhs = "<leader>ds"},
            {mode = "n", lhs = "<leader>cs"},
        }
    },
    config = configs.mini_surround
})

---------------------------------------------------------------------------------------------------
---pair brackets
---------------------------------------------------------------------------------------------------
deps.add({
    source = "echasnovski/mini.pairs",
    lazy_opts = {
        events = {"InsertEnter"}
    },
    config = configs.mini_pairs
})

---------------------------------------------------------------------------------------------------
---splitjoin
---------------------------------------------------------------------------------------------------
deps.add({
    source = "Wansmer/treesj",
    lazy_opts = {
        keys = {
            {mode = "n", lhs = "<leader>j", rhs = function()
                local langs = require('treesj.langs')['presets']
                if langs[vim.bo.filetype] then
                    vim.cmd("TSJToggle")
                else
                    require('mini.splitjoin').toggle()
                end
            end}
        }
    },
    config = function()
        configs.mini_splitjoin()
        configs.treesj()
    end,
    depends = {"echasnovski/mini.splitjoin"}
})

---------------------------------------------------------------------------------------------------
---enhance matchparen
---------------------------------------------------------------------------------------------------
deps.add({
    source = "utilyre/sentiment.nvim",
    lazy_opts = {
        events = {"CursorHold"}
    },
    config = configs.sentiment
})

---------------------------------------------------------------------------------------------------
---swap params
---------------------------------------------------------------------------------------------------
deps.add({
    source = "mizlan/iswap.nvim",
    lazy_opts = {
        keys = {
            {mode = "n", lhs = "<leader>sp", rhs = "<CMD>ISwapWith<CR>"}
        }
    },
    config = configs.iswap
})

---------------------------------------------------------------------------------------------------
---out brackets
---------------------------------------------------------------------------------------------------
deps.add({
    source = "kawre/neotab.nvim",
    lazy_opts = {
        events = {"InsertEnter"}
    },
    config = configs.neotab,
})
