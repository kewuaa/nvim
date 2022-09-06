local configs = {}


configs.lspsaga = function()
    local kind = require("lspsaga.lspkind")
    kind[2][2] = " "
    kind[4][2] = " "
    kind[5][2] = "ﴯ "
    kind[6][2] = " "
    kind[7][2] = "ﰠ "
    kind[8][2] = " "
    kind[9][2] = " "
    kind[10][2] = " "
    kind[11][2] = " "
    kind[12][2] = " "
    kind[13][2] = " "
    kind[15][2] = " "
    kind[16][2] = " "
    kind[23][2] = " "
    kind[26][2] = " "

    local saga = require('lspsaga')

    saga.init_lsp_saga({
        -- Options with default value
        -- "single" | "double" | "rounded" | "bold" | "plus"
        border_style = "single",
        --the range of 0 for fully opaque window (disabled) to 100 for fully
        --transparent background. Values between 0-30 are typically most useful.
        saga_winblend = 0,
        -- when cursor in saga window you config these to move
        move_in_saga = { prev = '<C-p>',next = '<C-n>'},
        -- Error, Warn, Info, Hint
        -- use emoji like
        -- { "🙀", "😿", "😾", "😺" }
        -- or
        -- { "😡", "😥", "😤", "😐" }
        -- and diagnostic_header can be a function type
        -- must return a string and when diagnostic_header
        -- is function type it will have a param `entry`
        -- entry is a table type has these filed
        -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
        -- diagnostic_header = { " ", " ", " ", "ﴞ " },
        diagnostic_header = { " ", " ", "  ", " " },
        -- show diagnostic source
        show_diagnostic_source = true,
        -- add bracket or something with diagnostic source, just have 2 elements
        diagnostic_source_bracket = {},
        -- preview lines of lsp_finder and definition preview
        max_preview_lines = 10,
        -- use emoji lightbulb in default
        code_action_icon = "💡",
        -- if true can press number to execute the codeaction in codeaction window
        code_action_num_shortcut = true,
        -- same as nvim-lightbulb but async
        code_action_lightbulb = {
            enable = true,
            sign = true,
            enable_in_insert = true,
            sign_priority = 20,
            virtual_text = true,
        },
        -- finder icons
        finder_icons = {
          def = '  ',
          ref = '諭 ',
          link = '  ',
        },
        -- finder do lsp request timeout
        -- if your project big enough or your server very slow
        -- you may need to increase this value
        finder_request_timeout = 1500,
        finder_action_keys = {
            open = "o",
            vsplit = "s",
            split = "i",
            tabe = "t",
            quit = "q",
            scroll_down = "<C-f>",
            scroll_up = "<C-b>", -- quit can be a table
        },
        code_action_keys = {
            quit = "q",
            exec = "<CR>",
        },
        rename_action_quit = "<C-c>",
        rename_in_select = true,
        definition_preview_icon = "  ",
        -- show symbols in winbar must nightly
        symbol_in_winbar = {
            in_custom = false,
            enable = false,
            separator = ' ',
            show_file = true,
            click_support = false,
        },
        -- show outline
        show_outline = {
          win_position = 'right',
          --set special filetype win that outline window split.like NvimTree neotree
          -- defx, db_ui
          win_with = '',
          win_width = 30,
          auto_enter = true,
          auto_preview = true,
          virt_text = '┃',
          jump_key = 'o',
          -- auto refresh when change buffer
          auto_refresh = true,
        },
        -- custom lsp kind
        -- usage { Field = 'color code'} or {Field = {your icon, your color code}}
        custom_kind = {},
        -- if you don't use nvim-lspconfig you must pass your server name and
        -- the related filetypes into this table
        -- like server_filetype_map = { metals = { "sbt", "scala" } }
        server_filetype_map = {},
    })
end

configs.nvim_lspconfig = function()
    require("lsp").setup()
end

configs.LuaSnip = function()
    local ls = require('luasnip')
    local types = require('luasnip.util.types')
    ls.config.set_config({
        history = true,
        enable_autosnippets = true,
        updateevents = 'TextChanged,TextChangedI',
        ext_opts = {
            [types.choiceNode] = {
                active = {
                    virt_text = { { '<- choiceNode', 'Comment' } },
                },
            },
        },
    })
    require("luasnip.loaders.from_vscode").lazy_load()
end

configs.nvim_cmp = function()
    -- 加载依赖
    local cmp = require('cmp')
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end

    cmp.setup({
        window = {
            completion = cmp.config.window.bordered(),
            documentation = cmp.config.window.bordered(),
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-u>"] = cmp.mapping.scroll_docs(-4),
            ["<C-d>"] = cmp.mapping.scroll_docs(4),
            ["<C-e>"] = cmp.mapping.close(),
            ["<Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                elseif has_words_before() then
                    cmp.complete()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<S-Tab>"] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-k>"] = function(fallback)
                if require("luasnip").jumpable(-1) then
                    vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
                elseif require('neogen').jumpable(true) then
                    require('neogen').jump_prev()
                else
                    fallback()
                end
            end,
            ["<C-j>"] = function(fallback)
                if require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
                elseif require('neogen').jumpable() then
                    require('neogen').jump_next()
                else
                    fallback()
                end
            end,
        }),
        sources = {
            {name = 'nvim_lsp'},
            {name = 'nvim_lua'},
            {name = 'luasnip'},
            {
                name = 'buffer',
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end,
                },
            },
            {
                name = 'path',
                option = {
                    trailing_slash = false,
                    get_cwd = function()
                        return vim.api.nvim_eval('fnamemodify(bufname("%"), ":p:h")')
                    end,
                },
            },
        },
    })
    local function callback()
        if vim.o.ft == 'lua' then
            vim.cmd [[exe 'PackerLoad cmp-nvim-lua']]
        else
            vim.api.nvim_create_autocmd('FileType', {
                group = 'packer_load_aucmds',
                pattern = 'lua',
                once = true,
                command = [[lua require('packer.load')({'cmp-nvim-lua'}, { ft = "lua" }, _G.packer_plugins)]],
            })
        end
        vim.api.nvim_create_autocmd('InsertEnter', {
            group = 'packer_load_aucmds',
            pattern = '*',
            once = true,
            command = [[lua require("packer.load")({'LuaSnip'}, {event = 'InsertEnter *'}, _G.packer_plugins)]],
        })
        vim.api.nvim_create_autocmd('CmdLineEnter', {
            group = 'packer_load_aucmds',
            pattern = '/,:',
            once = true,
            command = [[lua require('packer.load')({'cmp-cmdline'}, {event = 'CmdLineEnter /,:'}, _G.packer_plugins)]],
        })
    end

    callback()
end

configs.cmp_luasnip = function()
    require("cmp").setup({
        snippet = {
            expand = function(args)
                require("luasnip").lsp_expand(args.body)
            end,
        },
    })
end

configs.cmp_cmdline = function()
    local cmp = require("cmp")
    if not packer_plugins['cmp-buffer'].loaded then
        vim.cmd [[exe 'PackerLoad cmp-buffer']]
    end
    if not packer_plugins['cmp-path'].loaded then
        vim.cmd [[exe 'PackerLoad cmp-path']]
    end
    cmp.setup.cmdline('/', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
            { name = 'cmdline' }
        })
    })
end

configs.cmp_under_comparator = function()
    local cmp = require("cmp")
    cmp.setup {
        sorting = {
            comparators = {
                cmp.config.compare.offset,
                cmp.config.compare.exact,
                cmp.config.compare.score,
                require("cmp-under-comparator").under,
                cmp.config.compare.kind,
                cmp.config.compare.sort_text,
                cmp.config.compare.length,
                cmp.config.compare.order,
            },
        },
    }
end

configs.lspkind = function()
    require("cmp").setup({
        formatting = {
            format = require("lspkind").cmp_format({
                mode = 'symbol', -- show only symbol annotations
                with_text = true, -- do not show text alongside icons
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

                -- The function below will be called before any actual modifications from lspkind
                -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                before = function (entry, vim_item)
                    -- Source 显示提示来源
                    vim_item.menu = "["..string.upper(entry.source.name).."]"
                    return vim_item
                end
            })
        }
    })
end

configs.nvim_autopairs = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local cmp = require('cmp')
    local handlers = require("nvim-autopairs.completion.handlers")

    npairs.setup({
        map_bs = true,
        map_c_h = false,
        map_c_w = true,
        check_ts = true,
        enable_check_bracket_line = false,
        ignored_next_char = "[%w%.]",
        fast_wrap = {
            map = '<M-e>',
            chars = { '{', '[', '(', '"', "'" },
            pattern = [=[[%'%"%)%>%]%)%}%,]]=],
            end_key = '$',
            keys = 'qwertyuiopzxcvbnmasdfghjkl',
            check_comma = true,
            highlight = 'Search',
            highlight_grey='Comment'
        },
    })

    cmp.event:on(
        "confirm_done",
        cmp_autopairs.on_confirm_done({
            filetypes = {
                -- "*" is an alias to all filetypes
                ["*"] = {
                    ["("] = {
                        kind = {
                            cmp.lsp.CompletionItemKind.Function,
                            cmp.lsp.CompletionItemKind.Method,
                        },
                        handler = handlers["*"],
                    },
                },
                -- Disable for tex
                tex = false,
            },
        })
    )
    npairs.add_rule(Rule('<', '>'))
end


return configs
