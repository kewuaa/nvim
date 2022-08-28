local M = {}

function M.config()
    require('indent_blankline').setup({
        show_end_of_line = true,
        show_current_context = true,
        show_current_context_start = true,
        filetype_exclude = {
            "fugitive",
            "help",
            "netrw",
            "packer",
            "Outline",
            "NvimTree",
            "Quickfix List",
            "Trouble",
            "lspsagafinder",
            "lspsagaoutline",
            "startuptime",
        }
    })
end

return M

