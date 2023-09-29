local configs = {}


configs.mini_surround = function()
    require("mini.surround").setup({
        mappings = {
            add = "<leader>as",
            delete = "<leader>ds",
            find = "<leader>fs",
            find_left = "<leader>Fs",
            replace = "<leader>cs",
            highlight = "<leader>sh",
            update_n_lines = "",
            suffix_last = '', -- Suffix to search with "prev" method
            suffix_next = '',
        }
    })
end

configs.mini_ai = function()
    local ai = require("mini.ai")
    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            o = ai.gen_spec.treesitter({
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }, {}),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}),
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}),
            t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" },
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

configs.mini_comment = function()
    -- No need to copy this inside `setup()`. Will be used automatically.
    require("mini.comment").setup({
        -- Options which control module behavior
        options = {
            -- Function to compute custom 'commentstring' (optional)
            custom_commentstring = function()
                if vim.bo.ft == "cython" then
                    return "# %s"
                end
                return require("ts_context_commentstring.internal").calculate_commentstring()
                    or vim.bo.commentstring
            end,
        },
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

configs.eyeliner = function()
    require("eyeliner").setup({
        highlight_on_key = true, -- show highlights only after keypress
        dim = true              -- dim all other characters if set to true (recommended!)
    })
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
