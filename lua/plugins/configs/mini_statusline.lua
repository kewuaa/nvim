local mini_statusline = require("mini.statusline")

local active_content = function()
    local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
    local git           = mini_statusline.section_git({ trunc_width = 40, icon = "" })
    local diff          = mini_statusline.section_diff({ trunc_width = 75 })
    local diagnostics   = mini_statusline.section_diagnostics({
        trunc_width = 75,
        icon = " ",
        signs = { ERROR = "", WARN = "!", INFO = "", HINT = "" },
    })
    local lsp           = mini_statusline.section_lsp({ trunc_width = 75, icon = "" })
    local filename      = mini_statusline.section_filename({ trunc_width = 140 })
    local fileinfo      = mini_statusline.section_fileinfo({ trunc_width = 120 })
    local location      = mini_statusline.section_location({ trunc_width = 75 })
    local search        = mini_statusline.section_searchcount({ trunc_width = 75 })

    return mini_statusline.combine_groups({
        { hl = mode_hl,                  strings = { mode } },
        { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
        '%<', -- Mark general truncate point
        { hl = 'MiniStatuslineFilename', strings = { filename } },
        '%=', -- End left alignment
        { hl = 'MiniStatuslineFileinfo', strings = { fileinfo } },
        { hl = mode_hl,                  strings = { search, location } },
    })
end

mini_statusline.setup({
    content = {
        active = active_content,
    },
    use_icons = true,
    set_vim_settings = false
})
