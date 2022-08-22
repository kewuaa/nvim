local M = {}

function M.config()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {},
        sync_install = false,
        auto_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
        },
    })

    vim.cmd [[
        set foldmethod=expr
        set foldexpr=nvim_treesitter#foldexpr()
    ]]
end

return M

