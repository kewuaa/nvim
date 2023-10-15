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
    })
    require('nvim-treesitter.install').compilers = { "zig", "gcc" }
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

return configs
