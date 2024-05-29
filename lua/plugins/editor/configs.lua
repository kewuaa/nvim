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
        },
        n_lines = 500
    })
end

configs.mini_ai = function()
    local ai = require("mini.ai")
    ai.setup({
        n_lines = 500,
        custom_textobjects = {
            o = ai.gen_spec.treesitter({ -- code block
                a = { "@block.outer", "@conditional.outer", "@loop.outer" },
                i = { "@block.inner", "@conditional.inner", "@loop.inner" },
            }, {}),
            f = ai.gen_spec.treesitter({ a = "@function.outer", i = "@function.inner" }, {}), -- function
            c = ai.gen_spec.treesitter({ a = "@class.outer", i = "@class.inner" }, {}), -- class
            t = { "<([%p%w]-)%f[^<%w][^<>]->.-</%1>", "^<.->().*()</[^/]->$" }, -- tags
            d = { "%f[%d]%d+" }, -- digits
            e = { -- Word with case
                { "%u[%l%d]+%f[^%l%d]", "%f[%S][%l%d]+%f[^%l%d]", "%f[%P][%l%d]+%f[^%l%d]", "^[%l%d]+%f[^%l%d]" },
                "^().*()$",
            },
            u = ai.gen_spec.function_call(), -- u for "Usage"
            U = ai.gen_spec.function_call({ name_pattern = "[%w_]" }), -- without dot in function name
        },
    })
end

configs.mini_pairs = function()
    local mini_pairs = require("mini.pairs")
    mini_pairs.setup({
        -- In which modes mappings from this `config` should be created
        modes = { insert = true, command = true, terminal = true },
        mappings = {
            ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
            ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
            ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

            [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
            [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
            ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

            ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
            ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a<&\\].', register = { cr = false } },
            ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
        },
    })
    local mini_pairs_group = vim.api.nvim_create_augroup("mini_pairs", {
        clear = true
    })
    vim.api.nvim_create_autocmd("FileType", {
        group = mini_pairs_group,
        callback = function(params)
            if params.match == 'markdown' then
                mini_pairs.map_buf(0, 'i', '$', {
                    action = 'closeopen',
                    pair = '$$',
                    neigh_pattern = '[^\\]',
                    register = { cr = true }
                })
            elseif params.match == 'rust' or params.match == 'zig' then
                mini_pairs.map_buf(0, 'i', '|', {
                    action = 'closeopen',
                    pair = '||',
                    neigh_pattern = '[^%w\\]',
                    register = { cr = false }
                })
            end
        end
    })
    local map_bs = function(lhs, rhs)
        vim.keymap.set('i', lhs, rhs, { expr = true, replace_keycodes = false })
    end

    map_bs('<C-h>', 'v:lua.MiniPairs.bs()')
    map_bs('<C-w>', 'v:lua.MiniPairs.bs("\23")')
    map_bs('<C-u>', 'v:lua.MiniPairs.bs("\21")')
end

configs.neotab = function()
    require("neotab").setup({
        tabkey = "<C-l>",
        act_as_tab = false,
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
        },
        detect = {
            separator = '[,;]'
        }
    })
end

configs.iswap = function()
    require("iswap").setup({
        autoswap = true,
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

return configs
