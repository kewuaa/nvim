local configs = {}


configs.nvim_treesitter = function()
    require('nvim-treesitter.configs').setup({
        auto_install = true,
        ignore_install = {"zig"},
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "c", "cpp" },
            ---@diagnostic disable-next-line: unused-local
            disable = function(lang, bufnr)
                local size = require('core.utils').get_bufsize(bufnr)
                if size > 512 then
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
        textobjects = {
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]["] = "@function.outer",
                    ["]m"] = "@class.outer",
                },
                goto_next_end = {
                    ["]]"] = "@function.outer",
                    ["]M"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                    ["[m"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                    ["[M"] = "@class.outer",
                },
            },
        },
    })
    vim.api.nvim_set_option_value("foldmethod", "expr", {})
    vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", {})
    require('nvim-treesitter.install').compilers = { "gcc", "zig" }
    -- set python indent
    local sw = vim.fn.shiftwidth()
    vim.g.python_indent = {
        open_paren = sw,
        nested_paren = sw,
        continue = sw,
        closed_paren_align_last_line = false
    }
end

configs.rainbow_delimiters = function()
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

configs.hlargs = function()
    require("hlargs").setup({
        excluded_filetypes = require("core.settings").exclude_filetypes,
    })
end

configs.nvim_treesitter_textobjects = function()
    -- When in diff mode, we want to use the default
    -- vim text objects c & C instead of the treesitter ones.
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

return configs
