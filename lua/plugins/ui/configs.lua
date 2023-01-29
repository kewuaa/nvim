local configs = {}


configs.nvim_treesitter = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'python',
            'c',
            'cpp',
            'lua',
            'vim',
            'javascript',
            'typescript',
            'zig',
            'ini',
            'markdown',
            'json',
            'help',
            'yaml',
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "c", "cpp" },
            disable = function(lang, buf)
                local max_filesize = 100 * 1024 -- 100 KB
                local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(buf))
                if ok and stats and stats.size > max_filesize then
                    return true
                end
            end,
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
        },
        indent = {
            enable = true,
        },
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = 2000, -- Do not enable for files with more than n lines, int
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

configs.dracula = function()
    local dracula = require('dracula')
    dracula.setup({
        -- show the '~' characters after the end of buffers
        show_end_of_buffer = true, -- default false
        -- use transparent background
        transparent_bg = false, -- default false
        -- set custom lualine background color
        lualine_bg_color = nil, -- default nil
        -- set italic comment
        italic_comment = true, -- default false
        overrides = {
            -- Examples
            NonText = { fg = dracula.colors().white }, -- set NonText fg to white
            NvimTreeIndentMarker = { link = "NonText" }, -- link to NonText highlight
            -- Nothing = {} -- clear highlight of Nothing
        },
    })
    vim.cmd.colorscheme('dracula')
end

configs.vim_illuminate = function()
    require("illuminate").configure({
        providers = {
            "lsp",
            "treesitter",
            "regex",
        },
        delay = 100,
        filetypes_denylist = require("core.settings").exclude_filetypes,
        under_cursor = true,
    })
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
            msg = msg .. '[C] '
        end
        if index(mods, 'gtags_cscope') >= 0 then
            msg = msg .. '[G] '
        end
        return msg
    end
    local function gutentags()
        return vim.fn['gutentags#statusline_cb'](get_gutentags_status)
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
    -- local function min_window_width(width)
    --     return function() return vim.fn.winwidth(0) > width end
    -- end
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
            theme = 'dracula-nvim',
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
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = "#ff9e64" },
                },
                {
                    gutentags,
                    cond = function() return vim.bo.filetype == 'pyrex' end,
                },
                'g:translator_status',
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

configs.neodim = function ()
    local palette = require('dracula').colors()
    local blend_color = palette.black
    require('neodim').setup({
        alpha = 0.45,
        blend_color = blend_color,
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
    local palette = require('dracula').colors()
    colorful_winsep.setup({
        -- highlight for Window separator
        highlight = {
            bg = palette.bg,
            fg = palette.fg,
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
                if filetype == "NvimTree" then
                    colorful_winsep.NvimSeparatorDel()
                end
            end
        end,
    })
end

return configs
