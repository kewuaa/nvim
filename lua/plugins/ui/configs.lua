local configs = {}


configs.sonokai = function()
    vim.g.sonokai_style = 'atlantis'
    vim.g.sonokai_disable_italic_comment = 0
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_cursor = 'yellow'
    vim.g.sonokai_transparent_background = vim.fn.exists('g:nvy') == 1 and 0 or 1
    vim.g.sonokai_dim_inactive_windows = 0
    vim.g.sonokai_menu_selection_background = 'blue'
    vim.g.sonokai_spell_foreground = 'colored'
    vim.g.sonokai_show_eob = 1
    vim.g.sonokai_diagnostic_text_highlight = 1
    vim.g.sonokai_diagnostic_line_highlight = 1
    vim.g.sonokai_diagnostic_virtual_text = 'colored'
    vim.g.sonokai_current_word = 'grey background'
    vim.g.sonokai_disable_terminal_colors = 0
    vim.g.sonokai_better_performance = 1
    vim.schedule(function() vim.cmd.colorscheme('sonokai') end)
end
configs.catppuccin = function()
    require('catppuccin').setup({
        compile_path = vim.fn.stdpath "data" .. "/catppuccin",
        flavour = "frappe", -- latte, frappe, macchiato, mocha
        background = { -- :h background
            light = "latte",
            dark = "frappe",
        },
        transparent_background = false,
        show_end_of_buffer = true, -- show the '~' characters after the end of buffers
        term_colors = false,
        dim_inactive = {
            enabled = true,
            shade = "dark",
            percentage = 0.15,
        },
        no_italic = false, -- Force no italic
        no_bold = false, -- Force no bold
        styles = {
            comments = { "italic" },
            conditionals = { "italic" },
            loops = {},
            functions = { "italic,bold" },
            keywords = { "bold" },
            strings = {},
            variables = {},
            numbers = {},
            booleans = {},
            properties = {},
            types = {},
            operators = {},
        },
        color_overrides = {},
        custom_highlights = function(C)
            return {
                CmpItemKindSnippet = { fg = C.base, bg = C.mauve },
                CmpItemKindKeyword = { fg = C.base, bg = C.red },
                CmpItemKindText = { fg = C.base, bg = C.teal },
                CmpItemKindMethod = { fg = C.base, bg = C.blue },
                CmpItemKindConstructor = { fg = C.base, bg = C.blue },
                CmpItemKindFunction = { fg = C.base, bg = C.blue },
                CmpItemKindFolder = { fg = C.base, bg = C.blue },
                CmpItemKindModule = { fg = C.base, bg = C.blue },
                CmpItemKindConstant = { fg = C.base, bg = C.peach },
                CmpItemKindField = { fg = C.base, bg = C.green },
                CmpItemKindProperty = { fg = C.base, bg = C.green },
                CmpItemKindEnum = { fg = C.base, bg = C.green },
                CmpItemKindUnit = { fg = C.base, bg = C.green },
                CmpItemKindClass = { fg = C.base, bg = C.yellow },
                CmpItemKindVariable = { fg = C.base, bg = C.flamingo },
                CmpItemKindFile = { fg = C.base, bg = C.blue },
                CmpItemKindInterface = { fg = C.base, bg = C.yellow },
                CmpItemKindColor = { fg = C.base, bg = C.red },
                CmpItemKindReference = { fg = C.base, bg = C.red },
                CmpItemKindEnumMember = { fg = C.base, bg = C.red },
                CmpItemKindStruct = { fg = C.base, bg = C.blue },
                CmpItemKindValue = { fg = C.base, bg = C.peach },
                CmpItemKindEvent = { fg = C.base, bg = C.blue },
                CmpItemKindOperator = { fg = C.base, bg = C.blue },
                CmpItemKindTypeParameter = { fg = C.base, bg = C.blue },
                CmpItemKindCopilot = { fg = C.base, bg = C.teal },
            }
        end,
        integrations = {
            aerial = false,
            barbar = false,
            beacon = false,
            cmp = true,
            coc_nvim = false,
            dashboard = false,
            fern = false,
            fidget = true,
            gitgutter = false,
            gitsigns = true,
            harpoon = false,
            hop = true,
            illuminate = true,
            leap = false,
            lightspeed = false,
            lsp_saga = true,
            lsp_trouble = true,
            markdown = false,
            mason = false,
            mini = false,
            neogit = false,
            neotest = false,
            neotree = true,
            noice = false,
            notify = true,
            nvimtree = false,
            overseer = false,
            pounce = false,
            semantic_tokens = false,
            symbols_outline = false,
            telekasten = false,
            telescope = true,
            treesitter = true,
            treesitter_context = false,
            ts_rainbow = true,
            vim_sneak = false,
            vimwiki = false,
            which_key = false,

            -- Special integrations, see https://github.com/catppuccin/nvim#special-integrations
            barbecue = {
                dim_dirname = false,
            },
            dap = {
                enabled = true,
                enable_ui = true,
            },
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
            navic = {
                enabled = false,
                custom_bg = "NONE",
            },
        },
    })
    vim.schedule(function()
        vim.cmd.colorscheme('catppuccin')
    end)
end

configs.indent_blankline = function()
    require('indent_blankline').setup({
        show_end_of_line = true,
        show_current_context = false,
        show_current_context_start = false,
        filetype_exclude = require("core.settings").exclude_filetypes,
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

configs.mini_indentscope = function()
    require('mini.indentscope').setup({
        symbol = '╎',
        options = {
            try_as_border = true,
        }
    })
    vim.api.nvim_set_hl(0, 'MiniIndentscopeSymbol', {
        fg = 'pink'
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = require('core.settings').exclude_filetypes,
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
    })
end

configs.lualine = function()
    -- local function get_gutentags_status(mods)
    --     local msg = ''
    --     local index = vim.fn.index
    --     if index(mods, 'ctags') >= 0 then
    --         msg = msg .. '[C] '
    --     end
    --     if index(mods, 'gtags_cscope') >= 0 then
    --         msg = msg .. '[G] '
    --     end
    --     return msg
    -- end
    -- local function gutentags()
    --     return vim.fn['gutentags#statusline_cb'](get_gutentags_status)
    -- end
    local function diff_source()
        ---@diagnostic disable-next-line: undefined-field
        local gitsigns = vim.b.gitsigns_status_dict
        if gitsigns then
            return {
                added = gitsigns.added,
                modified = gitsigns.changed,
                removed = gitsigns.removed,
            }
        end
    end
    -- local function min_window_width(width)
    --     return function() return vim.fn.winwidth(0) > width end
    -- end
    local attached_lsp = function()
        local clients = vim.lsp.get_active_clients({
            bufnr = 0
        })
        if #clients > 0 then
            local names = {}
            for _, client in ipairs(clients) do
                names[#names+1] = string.upper(client.name)
            end
            return string.format('[LSP->%s]', vim.fn.join(names, ','))
        end
        return ''
    end
    local pyenv = function()
        if vim.bo.filetype == 'python' then
            local env = require('core.utils.python').get_current_env()
            if env then
                return ' ' .. env.name
            end
        end
        return ''
    end
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
    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = 'sonokai',
            disabled_filetypes = {},
            component_separators = { left = '', right = '' },
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    -- cond = min_window_width(40),
                },
            },
            lualine_b = {
                {
                    'filename',
                    newfile_status = true,
                    symbols = {
                        modified = '●',
                        readonly = '🔒',
                    }
                },
                {
                    pyenv,
                    color = { fg = '#ffbc03' }
                }
            },
            lualine_c = {
                {
                    "branch",
                    icon = '',
                    -- cond = min_window_width(120),
                },
                {
                    "diff",
                    symbols = {added = ' ', modified = ' ', removed = ' '},
                    source = diff_source,
                }
            },
            lualine_x = {
                {
                    attached_lsp,
                    color = { fg = "#99D1DB" }
                },
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = "#ff9e64" },
                },
                -- {
                --     gutentags,
                --     cond = function() return vim.bo.filetype == 'pyrex' end,
                --     color = { fg = '#F4B8E4'}
                -- },
                {
                    'g:translator_status',
                    color = { fg = "#E5C890" }
                },
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " " },
                },
            },
            lualine_y = {
                { "filetype", colored = true, icon_only = true },
                {
                    "encoding",
                    fmt = string.upper,
                    cond = function()
                        return string.match((vim.bo.fenc or vim.go.enc), '^utf%-8$') == ''
                    end,
                },
                {
                    "fileformat",
                    icons_enabled = true,
                    symbols = {
                        unix = "Unix",
                        dos = "Dos",
                        mac = "Mac",
                    },
                    cond = function()
                        return vim.bo.fileformat ~= 'dos'
                    end
                },
            },
            lualine_z = { "searchcount", "filesize", "progress", "location" },
        },
        inactive_sections = {
            lualine_a = {},
            lualine_b = {},
            lualine_c = { "filename" },
            lualine_x = { "location" },
            lualine_y = {},
            lualine_z = {},
        },
        tabline = {},
        extensions = {
            "quickfix",
            -- "toggleterm",
            'neo-tree',
            outline,
            'lazy',
            'trouble',
            'nvim-dap-ui',
        },
    })
end

configs.notify = function()
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
        background_colour = vim.fn.exists('g:nvy') == 1 and "Normal" or "#000000",
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

configs.dressing = function()
    require("dressing").setup({
        input = {
            enabled = true,
        },
        select = {
            enabled = true,
            backend = "telescope",
            trim_prompt = true,
        },
    })
end

configs.neodim = function ()
    require('neodim').setup({
        alpha = 0.45,
        blend_color = '#232634',
        update_in_insert = {
            enable = true,
            delay = 100,
        },
        hide = {
            virtual_text = true,
            signs = false,
            underline = false,
        },
    })
end

configs.colorful_winsep = function ()
    local colorful_winsep = require('colorful-winsep')
    local exclude_filetypes = require('core.settings').exclude_filetypes
    colorful_winsep.setup({
        -- highlight for Window separator
        highlight = {
            bg = '#303446',
            fg = '#c6d0f5',
        },
        -- timer refresh rate
        interval = 30,
        -- This plugin will not be activated for filetype in the following table.
        no_exec_files = vim.list_slice(exclude_filetypes, 1, #exclude_filetypes - 1),
        -- Symbols for separator lines, the order: horizontal, vertical, top left, top right, bottom left, bottom right.
        symbols = { "━", "┃", "┏", "┓", "┗", "┛" },
        close_event = function()
            -- Executed after closing the window separator
        end,
        create_event = function()
            local win_n = require("colorful-winsep.utils").calculate_number_windows()
            if win_n == 2 then
                local win_id = vim.fn.win_getid(vim.fn.winnr('h'))
                local filetype = vim.api.nvim_buf_get_option(vim.api.nvim_win_get_buf(win_id), 'filetype')
                if filetype == "neo-tree" then
                    colorful_winsep.NvimSeparatorDel()
                end
            end
        end,
    })
end

return configs
