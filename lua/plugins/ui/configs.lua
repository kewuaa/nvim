local configs = {}


configs.nvim_treesitter = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'python',
            'c',
            'cpp',
            'make',
            'cmake',
            'lua',
            'vim',
            'javascript',
            'typescript',
            'zig',
            'ini',
            'markdown',
            'markdown_inline',
            'json',
            'help',
            'yaml',
            'toml',
        },
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
        matchup = {
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
    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    local map = vim.keymap.set
    -- Repeat movement with ; and ,
    -- ensure ; goes forward and , goes backward regardless of the last direction
    -- map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    -- map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- vim way: ; goes to the direction you were moving.
    map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)

    require("hlargs").setup({
        excluded_filetypes = require("core.settings").exclude_filetypes,
    })
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
        symbol = '|',
        options = {
            try_as_border = true,
        }
    })
    vim.api.nvim_create_autocmd("FileType", {
        pattern = require('core.settings').exclude_filetypes,
        callback = function()
            vim.b.miniindentscope_disable = true
        end,
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
    -- local nvimtree = {
    --     sections = {
    --         lualine_a = { "bo:filetype" },
    --         lualine_b = {},
    --         lualine_c = {},
    --         lualine_x = {},
    --         lualine_y = {},
    --         lualine_z = {},
    --     },
    --     filetypes = { "NvimTree" },
    -- }
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
            theme = 'catppuccin',
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
                    attached_lsp,
                    color = { fg = "#99D1DB" }
                },
                {
                    require("lazy.status").updates,
                    cond = require("lazy.status").has_updates,
                    color = { fg = "#ff9e64" },
                },
                {
                    gutentags,
                    cond = function() return vim.bo.filetype == 'pyrex' end,
                    color = { fg = '#F4B8E4'}
                },
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
            'neo-tree',
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
