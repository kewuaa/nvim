local configs = {}


configs.nvim_treesitter = function()
    local ensure_installed = {
        'python',
        'c',
        'cpp',
        'c_sharp',
        'rust',
        'make',
        'cmake',
        'zig',
        'lua',
        'vim',
        'javascript',
        'typescript',
        'ini',
        'markdown',
        'markdown_inline',
        'json',
        'vimdoc',
        'gitignore',
        'yaml',
        'toml',
    }
    require('nvim-treesitter.configs').setup({
        ensure_installed = ensure_installed,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "c", "cpp" },
            ---@diagnostic disable-next-line: unused-local
            disable = function(lang, bufnr)
                local size = require('core.utils').get_bufsize(bufnr)
                if size > 512 then
                    local ok1, illuminate = pcall(require, 'illuminate.engine')
                    if ok1 then
                        illuminate.stop_buf(bufnr)
                    end
                    local ok2, indent_blankline = pcall(require, 'indent_blankline.commands')
                    if ok2 then
                        indent_blankline.disable()
                    end
                    vim.b.miniindentscope_disable = true
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
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
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
            swap = {
                enable = false,
                swap_next = {
                    ["<leader>s"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>S"] = "@parameter.inner",
                },
            },
        },
        indent = {
            enable = true,
        },
    })
    require('nvim-treesitter.install').compilers = { "zig", "gcc" }
end

configs.rainbow_delimiters = function()
    local rainbow_delimiters = require("rainbow-delimiters")
    require("rainbow-delimiters.setup")({
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

return configs
