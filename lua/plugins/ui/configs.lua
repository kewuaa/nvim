local configs = {}


configs.nvim_treesitter = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {},
        sync_install = false,
        auto_install = true,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        indent = {
            enable = true,
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
    vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
        group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
        callback = function()
            vim.opt.foldmethod     = 'expr'
            vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
        end
    })
end

configs.hlargs = function()
    require("hlargs").setup({
        excluded_filetypes = require("core.settings").exclude_filetypes,
    })
end

configs.sonokai = function()
    local style = 'atlantis'
    local api, fn = vim.api, vim.fn
    vim.g.sonokai_style = style
    vim.g.sonokai_disable_italic_comment = 0
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_cursor = 'yellow'
    vim.g.sonokai_menu_selection_background = 'blue'
    vim.g.sonokai_show_eob = 1
    vim.g.sonokai_diagnostic_text_highlight = 0
    vim.g.sonokai_diagnostic_line_highlight = 0
    vim.g.sonokai_diagnostic_virtual_text = 'colored'
    -- vim.g.sonokai_current_word = 'underline'
    vim.g.sonokai_disable_terminal_colors = 0
    vim.g.sonokai_better_performance = 1

    local function sonokai_custom()
        local palette = fn['sonokai#get_palette'](style, vim.empty_dict())
        fn['sonokai#highlight']('Visual', palette.none, palette.bg4)
        fn['sonokai#highlight']('CurrentWord', palette.none, palette.bg1)
    end
    local group = api.nvim_create_augroup('SonokaiCustom', {clear = true})
    api.nvim_create_autocmd('ColorScheme', {
        group = group,
        pattern = 'sonokai',
        callback = sonokai_custom,
    })
    vim.cmd[[colorscheme sonokai]]
end

configs.indent_blankline = function()
    require('indent_blankline').setup({
        show_end_of_line = true,
        show_current_context = true,
        show_current_context_start = true,
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

configs.lualine = function()
    local function get_gutentags_status(mods)
        local msg = ''
        local index = vim.fn.index
        if index(mods, 'ctags') >= 0 then
            msg = msg .. '[CT] '
        end
        if index(mods, 'gtags_cscope') >= 0 then
            msg = msg .. '[GT] '
        end
        return msg
    end
    local function gutentags()
        local vim_gutentags = packer_plugins['vim-gutentags']
        if vim_gutentags and vim_gutentags.loaded then
            return vim.fn['gutentags#statusline_cb'](get_gutentags_status)
        else
            return ''
        end
    end
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
    local function min_window_width(width)
        return function() return vim.fn.winwidth(0) > width end
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
    local nvimtree = {
        sections = {
            lualine_a = { "bo:filetype" },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        filetypes = { "NvimTree" },
    }
    local trouble = {
        sections = {
            lualine_a = { "bo:filetype" },
            lualine_b = {},
            lualine_c = {},
            lualine_x = {},
            lualine_y = {},
            lualine_z = {},
        },
        filetypes = { "Trouble" },
    }
    require("lualine").setup({
        options = {
            icons_enabled = true,
            theme = "sonokai",
            disabled_filetypes = {},
            component_separators = { left = '', right = '' },
            section_separators = { left = "", right = "" },
        },
        sections = {
            lualine_a = {
                {
                    "mode",
                    cond = min_window_width(40),
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
            },
            lualine_c = {
                { "branch", icon = '', cond = min_window_width(120) },
                {
                    "diff",
                    symbols = {added = ' ', modified = ' ', removed = ' '},
                    source = diff_source,
                }
            },
            lualine_x = {
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = "#ff9e64" },
                },
                {
                    "diagnostics",
                    sources = { "nvim_diagnostic" },
                    symbols = { error = " ", warn = " ", info = " " },
                },
            },
            lualine_y = {
                -- gutentags,
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
            lualine_z = { "progress", "location" },
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
            "toggleterm",
            nvimtree,
            outline,
            trouble,
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

return configs
