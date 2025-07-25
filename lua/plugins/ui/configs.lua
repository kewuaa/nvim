local configs = {}

configs.tokyonight = function()
    require("tokyonight").setup({
        style = "moon",
        styles = {
            functions = {bold = true},
        },
        plugins = {
            all = false,
            auto = false,
            dap = true,
            indentmini = true,
            ["grug-far"] = true,
            mini_cursorword = true,
            mini_deps = true,
            mini_diff = true,
            mini_files = true,
            mini_icons = true,
            mini_notify = true,
            mini_pick = true,
            mini_statusline = true,
            mini_surround = true,
            rainbow = true,
            treesitter = true,
            vimwiki = true
        }
    })
end

configs.indentmini = function()
    local settings = require("user.settings")
    local exclude_fts = settings.exclude_filetypes
    vim.list_extend(exclude_fts, settings.exclude_buftypes)
    require("indentmini").setup({
        exclude = exclude_fts
    })
end

configs.mini_statusline = function()
    local mini_statusline = require("mini.statusline")
    local active_content = function()
        local mode, mode_hl = mini_statusline.section_mode({ trunc_width = 120 })
        local git           = mini_statusline.section_git({ trunc_width = 40, icon = "" })
        local diff          = mini_statusline.section_diff({ trunc_width = 75 })
        local diagnostics   = mini_statusline.section_diagnostics({
            trunc_width = 75,
            icon = " ",
            signs = { ERROR = "", WARN = "!", INFO = "", HINT = "" },
        })
        local lsp           = mini_statusline.section_lsp({ trunc_width = 75, icon = "" })
        local filename      = mini_statusline.section_filename({ trunc_width = 140 })
        local fileinfo      = mini_statusline.section_fileinfo({ trunc_width = 120 })
        local location      = mini_statusline.section_location({ trunc_width = 75 })
        local search        = mini_statusline.section_searchcount({ trunc_width = 75 })

        return mini_statusline.combine_groups({
            { hl = mode_hl,                  strings = { mode } },
            { hl = 'MiniStatuslineDevinfo',  strings = { git, diff, diagnostics, lsp } },
            '%<', -- Mark general truncate point
            { hl = 'MiniStatuslineFilename', strings = { filename } },
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
            if string.match(bufname, "^term:") then
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
    local mini_notify = require("mini.notify")
    mini_notify.setup()
    local notify = mini_notify.make_notify()
    ---@diagnostic disable-next-line: duplicate-set-field
    vim.notify = function(msg, ...)
        if msg:match("warning: multiple different client offset_encodings") then
            return
        end
        notify(msg, ...)
    end

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
        mini_notify.show_history()
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

return configs
