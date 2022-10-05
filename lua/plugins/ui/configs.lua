local configs = {}


configs.monokai = function ()
    local monokai = require("monokai")
    local palette = monokai.classic
    monokai.setup({
        palette = require('monokai').soda,
        custom_hlgroups = {
            TSInclude = {
                fg = palette.aqua,
            },
            GitSignsAdd = {
                fg = palette.green,
                bg = palette.base2
            },
            GitSignsDelete = {
                fg = palette.pink,
                bg = palette.base2
            },
            GitSignsChange = {
                fg = palette.orange,
                bg = palette.base2
            },
        },
        italics = false,
    })
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

configs.lualine = function()
    require("plugins").check_loaded({
        'nvim-web-devicons'
    })
    local outline = {
        sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = { "location" },
        },
        filetypes = { "lspsagaoutline" },
    }
    local function diff_source()
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
            return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
            }
        end
    end
    require('lualine').setup {
        options = {
            icons_enabled = true,
            theme = 'molokai',
            -- component_separators = { left = '', right = ''},
            component_separators = "|",
            -- section_separators = { left = '', right = ''},
            section_separators = { left = "", right = "" },
            disabled_filetypes = {
                statusline = {'OverseerList'},
                winbar = {},
            },
            ignore_focus = {},
            always_divide_middle = true,
            globalstatus = false,
            refresh = {
                statusline = 1000,
                tabline = 1000,
                winbar = 1000,
            }
        },
        sections = {
            lualine_a = {'mode'},
            lualine_b = {
                {'branch'},
                {'diff', source = diff_source},
            },
            lualine_c = {'filename'},
            lualine_x = {
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " ", hint = " "},
                },
            },
            lualine_y = {
                {'filetype', colored = true, icon_only = true},
                {'encoding'},
                {'fileformat'},
            },
            lualine_z = {
                'location',
                'progress',
            },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = {'filename'},
            lualine_x = {'location'},
            lualine_y = {},
            lualine_z = {}
        },
        tabline = {},
        winbar = {},
        inactive_winbar = {},
        extensions = {
            'quickfix',
            'nvim-tree',
            'toggleterm',
            outline,
        }
    }
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
