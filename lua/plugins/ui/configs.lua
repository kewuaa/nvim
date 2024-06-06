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
    vim.cmd.colorscheme('tokyonight')
end

configs.indentmini = function()
    local settings = require("core.settings")
    local exclude_fts = settings.exclude_filetypes
    vim.list_extend(exclude_fts, settings.exclude_buftypes)
    require("indentmini").setup({
        exclude = exclude_fts
    })
    vim.api.nvim_set_hl(0, 'IndentLineCurrent', {
        fg = 'pink'
    })
end

configs.mini_statusline = function()
    local mini_statusline = require("mini.statusline")
    local python = require("core.utils.python")
    vim.api.nvim_set_hl(0, "pythonVenv", {
        fg = "#ffbc03",
        ctermfg = 214,
    })
    local section_pyvenv = function()
        local ft = vim.bo.filetype
        if ft == 'python' or ft == "cython" then
            local env = python.get_current_env()
            if env then
                return ("[%s]"):format(env.name)
            end
        end
        return ""
    end
    local active_content = function()
        local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
        local git           = mini_statusline.section_git({ trunc_width = 40 })
        local diff          = mini_statusline.section_diff({ trunc_width = 75 })
        local diagnostics   = mini_statusline.section_diagnostics({ trunc_width = 75 })
        local lsp           = mini_statusline.section_lsp({ trunc_width = 75 })
        -- local filename      = mini_statusline.section_filename({ trunc_width = 140 })
        local pyvenv        = section_pyvenv()
        local fileinfo      = mini_statusline.section_fileinfo({ trunc_width = 120 })
        local location      = mini_statusline.section_location({ trunc_width = 75 })
        local search        = mini_statusline.section_searchcount({ trunc_width = 75 })

        return mini_statusline.combine_groups({
            { hl = mode_hl,                  strings = { mode } },
            { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            -- { hl = 'MiniStatuslineFilename', strings = { filename } },
            { hl = 'pythonVenv', strings = { pyvenv } },
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

    local show_history = function()
        -- Show content in a reusable buffer
        local buf_id
        for _, id in ipairs(vim.api.nvim_list_bufs()) do
            if vim.bo[id].filetype == 'mininotify-history' then buf_id = id end
        end
        if buf_id == nil then
            buf_id = vim.api.nvim_create_buf(true, true)
            vim.bo[buf_id].filetype = 'mininotify-history'
        end

        local term = vim.api.nvim_list_uis()[1]
        local width, height = term.width, term.height
        local float_width = math.floor(width * 0.6)
        local float_height = math.floor(height * 0.6)
        local row = math.floor((height - float_height) / 2)
        local col = math.floor((width - float_width) / 2)
        vim.api.nvim_open_win(buf_id, true, {
            relative = 'editor',
            row = row,
            col = col,
            width = float_width,
            height = float_height,
            style = 'minimal',
            border = "single"
        })
        notify.show_history()
        vim.keymap.set("n", "q", function()
            vim.api.nvim_win_close(0, true)
            vim.api.nvim_buf_delete(buf_id, {})
        end, {buffer = buf_id, silent = true, noremap = true})
        vim.bo[buf_id].readonly = true
    end
    vim.api.nvim_create_user_command(
        "MiniNotifyHistory",
        show_history,
        {desc = "show history of mini_notify"}
    )
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

return configs
