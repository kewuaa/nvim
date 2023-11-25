local configs = {}


configs.sonokai = function()
    vim.g.sonokai_style = 'atlantis'
    vim.g.sonokai_disable_italic_comment = 0
    vim.g.sonokai_enable_italic = 1
    vim.g.sonokai_cursor = 'yellow'
    vim.g.sonokai_transparent_background = 0
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

configs.lsp_lens = function()
    require("lsp-lens").setup({
        hide_zero_counts = false,
        sections = {                      -- Enable / Disable specific request, formatter example looks 'Format Requests'
            definition = false,
            references = true,
            implements = true,
            git_authors = false,
        },
    })
end

configs.indent_blankline = function()
    require("ibl").setup({
        indent = { char = "│" },
        scope = { enabled = false },
        exclude = {
            filetypes = require("core.settings").exclude_filetypes,
            buftypes = { "terminal", "nofile", "quickfix", "prompt" },
        }
    })
    require("core.utils.bigfile").register(
        512,
        function(_)
            require("ibl").update({enabled = false})
        end, {}
    )
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
    require("core.utils.bigfile").register(
        512,
        function(_)
            vim.b.miniindentscope_disable = true
        end, {}
    )
end

configs.lualine = function()
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
        local ft = vim.bo.filetype
        if ft == 'python' or ft == "cython" then
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
                    icon = '',
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
        background_colour = "Normal",
        ---@usage minimum width for notification windows
        minimum_width = 30,
        ---@usage notifications with level lower than this would be ignored. [ERROR > WARN > INFO > DEBUG > TRACE]
        level = "TRACE",
        ---@usage Icons for the different levels
        icons = {
            ERROR = "󰅚",
            WARN = "󰀪",
            INFO = "",
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

return configs
