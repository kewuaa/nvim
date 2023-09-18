local configs = {}


configs.nvim_surround = function()
    require("nvim-surround").setup({
        keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "S",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
        },
    })
end

configs.vim_illuminate = function()
    require("illuminate").configure({
        providers = {
            "lsp",
            "treesitter",
            "regex",
        },
        delay = 200,
        filetypes_denylist = require("core.settings").exclude_filetypes,
        under_cursor = true,
    })
end

configs.autoclose = function()
    require('autoclose').setup({
        keys = {
            ["("] = { escape = false, close = true, pair = "()"},
            ["["] = { escape = false, close = true, pair = "[]"},
            ["{"] = { escape = false, close = true, pair = "{}"},

            [">"] = { escape = true, close = false, pair = "<>"},
            [")"] = { escape = true, close = false, pair = "()"},
            ["]"] = { escape = true, close = false, pair = "[]"},
            ["}"] = { escape = true, close = false, pair = "{}"},

            ['"'] = { escape = true, close = true, pair = '""'},
            ["'"] = { escape = true, close = true, pair = "''", disabled_filetypes = {"rust"}},
            ["`"] = { escape = true, close = true, pair = "``"},
        },
        options = {
            disabled_filetypes = nil,
            disable_when_touch = true,
        },
    })
end

configs.comment = function()
    require('Comment').setup({
        ---Add a space b/w comment and the line
        padding = true,
        ---Whether the cursor should stay at its position
        sticky = true,
        ---Lines to be ignored while (un)comment
        ignore = '^$',
        ---LHS of toggle mappings in NORMAL mode
        toggler = {
            ---Line-comment toggle keymap
            line = 'gcc',
            ---Block-comment toggle keymap
            block = 'gbc',
        },
        ---LHS of operator-pending mappings in NORMAL and VISUAL mode
        opleader = {
            ---Line-comment keymap
            line = 'gc',
            ---Block-comment keymap
            block = 'gb',
        },
        ---LHS of extra mappings
        extra = {
            ---Add comment on the line above
            above = 'gcO',
            ---Add comment on the line below
            below = 'gco',
            ---Add comment at the end of line
            eol = 'gcA',
        },
        ---Enable keybindings
        ---NOTE: If given `false` then the plugin won't create any mappings
        mappings = {
            ---Operator-pending mapping; `gcc` `gbc` `gc[count]{motion}` `gb[count]{motion}`
            basic = true,
            ---Extra mapping; `gco`, `gcO`, `gcA`
            extra = true,
            ---Extended mapping; `g>` `g<` `g>[count]{motion}` `g<[count]{motion}`
            extended = false,
        },
        ---Function to call before (un)comment
        pre_hook = nil,
        ---Function to call after (un)comment
        post_hook = nil,
    })
    local ft = require("Comment.ft")
    ft({'cython'}, ft.get('python'))
    ft({'zig'}, ft.get('c'))
    ft.pascal = {'//%s', '{%s}'}
end

configs.tabout = function()
    require('tabout').setup({
        tabkey = '',
        backwards_tabkey = ''
    })
end

configs.treesj = function ()
    local tsj = require('treesj')
    local langs = require('treesj.langs')['presets']
    tsj.setup({
        -- Use default keymaps
        -- (<space>m - toggle, <space>j - join, <space>s - split)
        use_default_keymaps = false,

        -- Node with syntax error will not be formatted
        check_syntax_error = true,

        -- If line after join will be longer than max value,
        -- node will not be formatted
        max_join_length = 120,

        -- hold|start|end:
        -- hold - cursor follows the node/place on which it was called
        -- start - cursor jumps to the first symbol of the node being formatted
        -- end - cursor jumps to the last symbol of the node being formatted
        cursor_behavior = 'hold',

        -- Notify about possible problems or not
        notify = true,
    })

    local bufopts = { buffer = true }
    local callback = function()
        if langs[vim.bo.filetype] then
            vim.keymap.set(
                'n',
                vim.g.mapleader .. 'j',
                '<CMD>TSJToggle<CR>',
                bufopts
            )
        else
            vim.keymap.set(
                'n',
                vim.g.mapleader .. 'j',
                function() require('mini.splitjoin').toggle() end,
                bufopts
            )
        end
    end
    vim.api.nvim_create_autocmd({ 'FileType' }, {
        callback = callback,
    })
    callback()
end

configs.mini_splitjoin = function()
    require('mini.splitjoin').setup({
        mappings = {
            toggler = '',
            split = '',
            join = '',
        }
    })
end

configs.iswap = function()
    require("iswap").setup({
        autoswap = true,
    })
end

configs.accelerated_jk = function()
    -- conservative deceleration 
    vim.g.accelerated_jk_enable_deceleration = 1
    -- if default key-repeat interval check(150 ms) is too short
    vim.g.accelerated_jk_acceleration_limit = 250

    local map = vim.keymap.set
    local opt = {
        noremap = true,
        silent = true,
    }
    map('n', 'j', '<Plug>(accelerated_jk_gj)', opt)
    map('n', 'k', '<Plug>(accelerated_jk_gk)', opt)

end

configs.live_command = function ()
    require("live-command").setup {
        defaults = {
            enable_highlighting = true,
            inline_highlighting = true,
            hl_groups = {
                insertion = "DiffAdd",
                deletion = "DiffDelete",
                change = "DiffChange",
            },
        },
        commands = {
            Norm = {
                cmd = 'norm',
            }
        },
        debug = false,
    }
end

configs.sentiment = function()
    require('sentiment').setup({
        pairs = {
            { "(", ")" },
            { "{", "}" },
            { "[", "]" },
        },
    })
end

configs.numb = function ()
    require('numb').setup{
        show_numbers = true, -- Enable 'number' for the window while peeking
        show_cursorline = true, -- Enable 'cursorline' for the window while peeking
        hide_relativenumbers = true, -- Enable turning off 'relativenumber' for the window while peeking
        number_only = false, -- Peek only when the command is only a number instead of when it starts with a number
        centered_peeking = true, -- Peeked line will be centered relative to window
    }
end


return configs
