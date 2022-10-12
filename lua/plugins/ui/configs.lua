local configs = {}


configs.catppuccin = function()
    vim.g.catppuccin_flavour = "mocha" -- latte, frappe, macchiato, mocha
    require("catppuccin").setup({
        compile_path = vim.fn.stdpath("cache") .. "/catppuccin",
        transparent_background = false,
        term_colors = false,
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.15,
        },
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = { "italic", "bold" },
            keywords = {},
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        integrations = {
            cmp = true,
            gitsigns = true,
            nvimtree = true,
            telescope = true,
            treesitter = true,
            hop = true,
            lsp_saga = true,
            notify = true,
            ts_rainbow = true,
            lsp_trouble = true,
            illuminate = true,
            fidget = true,
            indent_blankline = {
                enabled = true,
                colored_indent_levels = false,
            },
            native_lsp = {
                enabled = true,
                virtual_text = {
                    errors = { "italic" },
                    hints = { "italic" },
                    warnings = { "italic" },
                    information = { "italic" },
                },
                underlines = {
                    errors = { "underline" },
                    hints = { "underline" },
                    warnings = { "underline" },
                    information = { "underline" },
                },
            },
            -- For more plugins integrations please scroll down (https://github.com/catppuccin/nvim#integrations)
        },
        color_overrides = {},
        custom_highlights = {},
    })
    vim.cmd [[
    colorscheme catppuccin
    ]]
end

configs.indent_blankline = function()
    require('indent_blankline').setup({
        show_end_of_line = true,
        show_current_context = true,
        show_current_context_start = true,
        filetype_exclude = require("settings").exclude_filetypes,
        buftype_exclude = { "terminal", "nofile" },
        context_patterns = {
            "class",
            "function",
            "method",
            "block",
            "list_literal",
            "selector",
            "^if",
            "^table",
            "if_statement",
            "while",
            "for",
            "type",
            "var",
            "import",
        },
    })
end

configs.feline = function()
    require("plugins").check_loaded({
        'nvim-web-devicons'
    })
    local feline = require("feline")
    local ctp_feline = require('catppuccin.groups.integrations.feline')
    ctp_feline.setup({
        assets ={
            left_separator = "",
            right_separator = "",
        },
    })
    feline.setup({
        components = ctp_feline.get(),
        force_inactive = {
            filetypes = {
                '^NvimTree$',
                '^packer$',
                '^startify$',
                '^fugitive$',
                '^fugitiveblame$',
                '^qf$',
                '^help$',
                '^lspsagaoutline$',
            },
            buftypes = {
                '^terminal$'
            },
            bufnames = {}
        }
    })
    feline.winbar.setup()
end

configs.dressing = function()
    require("dressing").setup()
end

configs.notify = function ()
    local notify = require("notify")
    notify.setup({
        ---@usage Animation style one of { "fade", "slide", "fade_in_slide_out", "static" }
        stages = "fade_in_slide_out",
        ---@usage Function called when a new window is opened, use for changing win settings/config
        on_open = nil,
        ---@usage Function called when a window is closed
        on_close = nil,
        ---@usage timeout for notifications in ms, default 5000
        timeout = 2000,
        -- Render function for notifications. See notify-render()
        render = "default",
        ---@usage highlight behind the window for stages that change opacity
        background_colour = "Normal",
        ---@usage minimum width for notification windows
        minimum_width = 30,
        ---@usage notifications with level lower than this would be ignored. [ERROR > WARN > INFO > DEBUG > TRACE]
        level = "TRACE",
        ---@usage Icons for the different levels
        icons = {
            ERROR = "",
            WARN = "",
            INFO = "",
            DEBUG = "",
            TRACE = "✎",
        },
    })
    vim.notify = notify
end

configs.fidget = function()
    require("fidget").setup({
        window = { blend = 0 },
    })
end


return configs
