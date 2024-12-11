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

configs.mini_cursorword = function()
    require("mini.cursorword").setup({
        delay = 100
    })
    local settings = require("user.settings")
    local mini_cursorword_group = vim.api.nvim_create_augroup("mini_cursorword", {clear = true})
    local disable = function()
        local ft = vim.bo.filetype
        local buftype = vim.bo.buftype
        if vim.tbl_contains(settings.exclude_filetypes, ft)
            or vim.tbl_contains(settings.exclude_buftypes, buftype) then
            vim.b.minicursorword_disable = true
        end
    end
    vim.schedule(disable)
    vim.api.nvim_create_autocmd("FileType", {
        desc = "disable MiniursorWord on some filetypes",
        group = mini_cursorword_group,
        callback = disable
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
    local add_pairs = function()
        local ft = vim.bo.filetype
        if ft == "markdown" then
            mini_pairs.map_buf(0, 'i', '$', {
                action = 'closeopen',
                pair = '$$',
                neigh_pattern = '[^\\]',
                register = { cr = true }
            })
        elseif ft == "rust" then
            mini_pairs.map_buf(0, 'i', '|', {
                action = 'closeopen',
                pair = '||',
                neigh_pattern = '[^%w\\]',
                register = { cr = false }
            })
        end
    end
    vim.schedule(add_pairs)
    vim.api.nvim_create_autocmd("FileType", {
        desc = "add filetype specified pair",
        group = mini_pairs_group,
        callback = add_pairs,
    })
    local map_bs = function(lhs, rhs)
        vim.keymap.set('i', lhs, rhs, { expr = true, replace_keycodes = false })
    end

    map_bs('<C-h>', 'v:lua.MiniPairs.bs()')
    map_bs('<C-w>', 'v:lua.MiniPairs.bs("\23")')
    map_bs('<C-u>', 'v:lua.MiniPairs.bs("\21")')

    -- add space inner brackets
    local mini_pairs_callback = function()
        if vim.v.char == " " then
            local keys = vim.api.nvim_replace_termcodes(
                "<space><left>",
                true,
                false,
                true
            )
            vim.api.nvim_feedkeys(keys, "i", false)
        end
    end
    local mini_pairs_open = mini_pairs.open
    mini_pairs.open = function(...)
        local ret = mini_pairs_open(...)
        vim.schedule(
            function()
                local autocmd_id = vim.api.nvim_create_autocmd("InsertCharPre", {
                    once = true,
                    group = mini_pairs_group,
                    buffer = 0,
                    callback = mini_pairs_callback
                })
                local cleanup_group = vim.api.nvim_create_augroup("PairSpaceCleanup", {clear = true})
                vim.api.nvim_create_autocmd({"InsertLeave", "CursorMovedI"}, {
                    group = cleanup_group,
                    callback = function()
                        pcall(vim.api.nvim_del_autocmd, autocmd_id)
                        vim.api.nvim_del_augroup_by_id(cleanup_group)
                    end,
                    desc = "delete autocmd for pair space adding"
                })
            end
        )
        return ret
    end
    -- hide completion menu before <CR>
    local mini_pairs_cr = mini_pairs.cr
    mini_pairs.cr = function(key)
        local res = mini_pairs_cr(key)
        local complete_info = vim.fn.complete_info()
        if complete_info.pum_visible == 1 then
            local idx = complete_info.selected
            res = vim.keycode(
                idx == -1 and "<C-e>" or "<C-y>"
            )..res
        end
        return res
    end
end

configs.treesj = function()
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
        max_join_length = 500,

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
    vim.schedule(callback)
    vim.api.nvim_create_autocmd({ 'FileType' }, {
        callback = callback,
    })
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
