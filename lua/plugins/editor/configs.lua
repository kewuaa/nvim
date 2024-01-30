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

configs.mini_pairs = function()
    require("mini.pairs").setup({
        -- In which modes mappings from this `config` should be created
        modes = { insert = true, command = true, terminal = true },
    })
    local map_bs = function(lhs, rhs)
        vim.keymap.set('i', lhs, rhs, { expr = true, replace_keycodes = false })
    end

    map_bs('<C-h>', 'v:lua.MiniPairs.bs()')
    map_bs('<C-w>', 'v:lua.MiniPairs.bs("\23")')
    map_bs('<C-u>', 'v:lua.MiniPairs.bs("\21")')
end

configs.mini_comment = function()
    -- No need to copy this inside `setup()`. Will be used automatically.
    require("mini.comment").setup({
        -- Options which control module behavior
        options = {
            -- Function to compute custom 'commentstring' (optional)
            custom_commentstring = function()
                local ft = vim.bo.ft
                if ft == "cython" then
                    return "#%s"
                elseif vim.fn.index({"cpp", "c", "cs", "fsharp", "dart"}, ft) > -1 then
                    return "//%s"
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
