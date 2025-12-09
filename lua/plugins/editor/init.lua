local deps = require("deps")
local configs = require("plugins.editor.configs")

---------------------------------------------------------------------------------------------------
---enhance textobjects
---------------------------------------------------------------------------------------------------
deps.add({
    source = "nvim-mini/mini.ai",
    lazy_opts = {
        very_lazy = true
    },
    config = configs.mini_ai,
    depends = {
        {
            source = "nvim-mini/mini.extra",
            config = function() require("mini.extra").setup() end
        }
    }
})

---------------------------------------------------------------------------------------------------
---text align
---------------------------------------------------------------------------------------------------
deps.add({
    source = "nvim-mini/mini.align",
    lazy_opts = {
        keys = {
            {mode = {"n", "v"}, lhs = "ga"},
            {mode = {"n", "v"}, lhs = "gA"},
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
    source = "nvim-mini/mini.bufremove",
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
    source = "nvim-mini/mini.cursorword",
    lazy_opts = {
        events = {"CursorHold"}
    },
    config = configs.mini_cursorword
})

---------------------------------------------------------------------------------------------------
---surround
---------------------------------------------------------------------------------------------------
deps.add({
    source = "nvim-mini/mini.surround",
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
    source = "nvim-mini/mini.pairs",
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
    depends = {"nvim-mini/mini.splitjoin"}
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
