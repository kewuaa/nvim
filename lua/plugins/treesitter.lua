local deps = require("deps")

local treesitter = function()
    require('nvim-treesitter.configs').setup({
        auto_install = true,
        ignore_install = {},
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
            ---@diagnostic disable-next-line: unused-local
            disable = function(lang, bufnr)
                local size = require('utils').cal_bufsize(bufnr)
                if size > 0.5 then
                    return true
                end
            end,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "+", -- set to `false` to disable one of the mappings
                node_incremental = "+",
                scope_incremental = false,
                node_decremental = "_",
            },
        },
        indent = { enable = true },
        textobjects = {
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]f"] = "@function.outer",
                    ["]c"] = "@class.outer",
                },
                goto_next_end = {
                    ["]F"] = "@function.outer",
                    ["]C"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[f"] = "@function.outer",
                    ["[c"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[F"] = "@function.outer",
                    ["[C"] = "@class.outer",
                },
            },
        },
    })
    require('nvim-treesitter.install').compilers = { "gcc", "zig", "cl" }
end

local treesitter_textobjects = function()
    local move = require("nvim-treesitter.textobjects.move") ---@type table<string,fun(...)>
    local treesitter_configs = require("nvim-treesitter.configs")
    for name, fn in pairs(move) do
        if name:find("goto") == 1 then
            move[name] = function(q, ...)
                if vim.wo.diff then
                    local config = treesitter_configs.get_module("textobjects.move")[name] ---@type table<string,string>
                    for key, query in pairs(config or {}) do
                        if q == query and key:find("[%]%[][cC]") then
                            vim.cmd("normal! " .. key)
                            return
                        end
                    end
                end
                return fn(q, ...)
            end
        end
    end
end

local rainbow_delimiters = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    require("rainbow-delimiters.setup").setup({
        strategy = {
            [''] = rainbow_delimiters.strategy['global'],
            vim = rainbow_delimiters.strategy['local'],
        },
        query = {
            [''] = 'rainbow-delimiters',
            lua = 'rainbow-blocks',
        },
        highlight = {
            'RainbowDelimiterYellow',
            'RainbowDelimiterBlue',
            'RainbowDelimiterOrange',
            'RainbowDelimiterGreen',
            'RainbowDelimiterViolet',
            'RainbowDelimiterCyan',
            'RainbowDelimiterRed',
        },
    })
end

local config = function()
    treesitter()
    treesitter_textobjects()
    rainbow_delimiters()
    for _, mod in pairs({"auto_install", "highlight", "textobjects.move", "incremental_selection"}) do
        vim.api.nvim_get_autocmds({
            group = "NvimTreesitter-" .. mod,
            event = "FileType",
        })[1].callback({buf = 0})
    end
end

deps.add({
    source = "nvim-treesitter/nvim-treesitter",
    hooks = {
        post_checkout = function()
            local ts_update = require('nvim-treesitter.install').update({ with_sync = true })
            ts_update()
        end
    },
    lazy_opts = {
        delay = 300,
        events = {"BufRead", "BufNewFile"}
    },
    config = config,
    depends = {
        "HiPhish/rainbow-delimiters.nvim",
        "nvim-treesitter/nvim-treesitter-textobjects"
    }
})
