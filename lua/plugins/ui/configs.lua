local configs = {}

configs.tokyonight = function()
    require("tokyonight").setup({
        -- your configuration comes here
        -- or leave it empty to use the default settings
        style = "moon", -- The theme comes in three styles, `storm`, `moon`, a darker variant `night` and `day`
        light_style = "day", -- The theme is used when the background is set to light
        transparent = false, -- Enable this to disable setting the background color
        terminal_colors = true, -- Configure the colors used when opening a `:terminal` in [Neovim](https://github.com/neovim/neovim)
        styles = {
            -- Style to be applied to different syntax groups
            -- Value is any valid attr-list value for `:help nvim_set_hl`
            comments = { italic = true },
            keywords = { italic = true },
            functions = {},
            variables = {},
            -- Background styles. Can be "dark", "transparent" or "normal"
            sidebars = "dark", -- style for sidebars, see below
            floats = "dark", -- style for floating windows
        },
        sidebars = { "qf", "help" }, -- Set a darker background on sidebar-like windows. For example: `["qf", "vista_kind", "terminal", "packer"]`
        day_brightness = 0.3, -- Adjusts the brightness of the colors of the **Day** style. Number between 0 and 1, from dull to vibrant colors
        hide_inactive_statusline = false, -- Enabling this option, will hide inactive statuslines and replace them with a thin border instead. Should work with the standard **StatusLine** and **LuaLine**.
        dim_inactive = false, -- dims inactive windows
        lualine_bold = true, -- When `true`, section headers in the lualine theme will be bold
    })
    vim.schedule(function() vim.cmd.colorscheme('tokyonight') end)
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
    local exclude_filetypes = require("core.settings").exclude_filetypes
    local exclude_buftypes = {"terminal", "nofile", "quickfix", "prompt"}
    vim.api.nvim_create_autocmd("BufEnter", {
        group = vim.api.nvim_create_augroup("disable_mini_indentscope", {clear = true}),
        callback = function()
            if vim.tbl_contains(exclude_filetypes, vim.bo.filetype)
                    or vim.tbl_contains(exclude_buftypes, vim.bo.buftype) then
                vim.b.miniindentscope_disable = true
            end
        end
    })
    require("core.utils.bigfile").register(
        512,
        function(_)
            vim.b.miniindentscope_disable = true
        end, {}
    )
end

configs.sttusline = function()
    local sttusline = require("sttusline")
    local color = require("sttusline.utils.color")
    local pyutils = require("core.utils.python")
    sttusline.setup({
        on_attach = function(create_update_group)
            create_update_group("BUF_WIN_ENTER", {
                event = { "BufEnter", "WinEnter" },
                user_event = { "StatusLineInit" },
                timing = false,
            })
        end,
        disabled = {
            filetypes = {},
            buftypes = {}
        },
        components = {
            {
                "os-uname",
                { user_event = { "StatusLineInit" } }
            },
            {
                "mode",
                { user_event = { "StatusLineInit" } }
            },
            {
                "filename",
                {
                    event = { "BufEnter", "WinEnter", "TextChanged", "TextChangedI", "BufWritePost" },
                    user_event = { "StatusLineInit" },
                }
            },
            {
                name = "pyvenv",
                event = { "BufEnter", "WinEnter" },
                user_event = { "PYVENVUPDATE" },
                condition = function()
                    local ft = vim.bo.filetype
                    if ft == 'python' or ft == "cython" then
                        local env = pyutils.get_current_env()
                        if env then
                            return true
                        end
                    end
                    return false
                end,
                update = function(config, space)
                    return {
                        {
                            '[' .. pyutils.get_current_env().name .. ']',
                            { fg = color.yellow },
                        },
                    }
                end
            },
            {
                "filesize",
                { user_event = { "StatusLineInit" } }
            },
            "git-branch",
            "git-diff",
            "%=",
            "diagnostics",
            "lsps-formatters",
            {
                "copilot",
                {
                    init = function(config)
                        vim.api.nvim_create_autocmd("User", {
                            pattern = "LazyLoad",
                            callback = function(params)
                                if params.data == 'copilot.lua' then
                                    require("sttusline.components.copilot").init(config)
                                    return true
                                end
                            end
                        })
                    end,
                }
            },
            {
                "copilot-loading",
                {
                    init = function(config)
                        vim.api.nvim_create_autocmd("User", {
                            pattern = "LazyLoad",
                            callback = function(params)
                                if params.data == 'copilot.lua' then
                                    require("sttusline.components.copilot-loading").init(config)
                                    return true
                                end
                            end
                        })
                    end,
                }
            },
            "indent",
            "encoding",
            {
                "pos-cursor",
                { user_event = { "StatusLineInit" } }
            },
            {
                "pos-cursor-progress",
                { user_event = { "StatusLineInit" } }
            },
        }
    })
    vim.api.nvim_exec_autocmds("User", {pattern = "StatusLineInit", modeline = false})
end

configs.tabline = function()
    require('tabline').setup({
        show_index = true,           -- show tab index
        show_modify = true,          -- show buffer modification indicator
        show_icon = true,           -- show file extension icon
        fnamemodify = function(bufname)
            if string.find(bufname, "term") then
                return "TERMINAL"
            else
                return vim.fn.fnamemodify(bufname, ':t')
            end
        end,
        modify_indicator = '[+]',    -- modify indicator
        no_name = 'No name',         -- no name buffer name
        brackets = { '[', ']' },     -- file name brackets surrounding
        inactive_tab_max_length = 0  -- max length of inactive tab titles, 0 to ignore
    })
end

configs.mini_notify = function()
    local notify = require("mini.notify")
    notify.setup()
    vim.notify = notify.make_notify()
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
        hide = {
            virtual_text = true,
            signs = false,
            underline = false,
        },
    })
end

return configs
