local configs = {}

configs.nvim_cmp = function()
    local cmp = require('cmp')
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    local border = function(hl)
        return {
            { "╭", hl },
            { "─", hl },
            { "╮", hl },
            { "│", hl },
            { "╯", hl },
            { "─", hl },
            { "╰", hl },
            { "│", hl },
        }
    end
    local cmp_window = require("cmp.utils.window")
    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
        local info = self:info_()
        info.scrollable = false
        return info
    end

    cmp.setup({
        window = {
            completion = {
                border = border("Normal"),
                max_width = 80,
                max_height = 20,
            },
            documentation = {
                border = border("CmpDocBorder"),
            },
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            -- ["<C-p>"] = cmp.mapping.select_prev_item(),
            -- ["<C-n>"] = cmp.mapping.select_next_item(),
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
                else
                    fallback()
                end
            end,
            ["<C-j>"] = function(fallback)
                if require("luasnip").expand_or_jumpable() then
                    vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
                else
                    fallback()
                end
            end,
        }),
        sources = {
            { name = 'nvim_lsp' },
            { name = 'nvim_lua' },
            -- { name = 'tags' },
            { name = 'luasnip' },
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
                    get_cwd = require("core.utils").get_cwd,
                },
            },
        },
    })
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
    require("luasnip.loaders.from_vscode").lazy_load({paths = {require("core.settings").nvim_path .. '/mysnips'}})
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
    local lspkind = require("lspkind")
    lspkind.init({
        -- DEPRECATED (use mode instead): enables text annotations
        --
        -- default: true
        -- with_text = true,

        -- defines how annotations are shown
        -- default: symbol
        -- options: 'text', 'text_symbol', 'symbol_text', 'symbol'
        mode = 'symbol_text',

        -- default symbol map
        -- can be either 'default' (requires nerd-fonts font) or
        -- 'codicons' for codicon preset (requires vscode-codicons font)
        --
        -- default: 'default'
        preset = 'default',

        -- override preset symbols
        --
        -- default: {}
        symbol_map = {
            Text = "",
            Method = "",
            Function = "",
            Constructor = "",
            Field = "ﰠ",
            Variable = "",
            Class = "ﴯ",
            Interface = "",
            Module = "",
            Property = "ﰠ",
            Unit = "塞",
            Value = "",
            Enum = "",
            Keyword = "",
            Snippet = "",
            Color = "",
            File = "",
            Reference = "",
            Folder = "",
            EnumMember = "",
            Constant = "",
            Struct = "פּ",
            Event = "",
            Operator = "",
            TypeParameter = ""
        },
    })
    require("cmp").setup({
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function (entry, vim_item)
                local kind = lspkind.cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = " " .. strings[1] .. " "
                kind.menu = "    (" .. strings[2] .. ")"
                return kind
            end,
        }
    })
end

configs.nvim_autopairs = function()
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
    local handlers = require("nvim-autopairs.completion.handlers")
    local cmp = require('cmp')
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
            highlight_grey = 'Comment'
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
    npairs.add_rule(Rule("|", "|", { 'zig' }))
end


configs.lspsaga = function()
    local saga = require('lspsaga')
    saga.setup({
        finder = {
            edit = { 'o', '<CR>' },
            vsplit = 's',
            split = 'i',
            tabe = 't',
            quit = { 'q', '<ESC>' },
        },
        definition = {
            edit = '<C-c>o',
            vsplit = '<C-c>v',
            split = '<C-c>i',
            tabe = '<C-c>t',
            quit = 'q',
            close = '<Esc>',
        },
        code_action = {
            num_shortcut = true,
            keys = {
                quit = 'q',
                exec = '<CR>',
            },
        },
        lightbulb = {
            enable = true,
            enable_in_insert = true,
            sign = true,
            sign_priority = 40,
            virtual_text = true,
        },
        diagnostic = {
            twice_into = false,
            show_code_action = true,
            show_source = true,
            keys = {
                exec_action = 'o',
                quit = 'q',
                go_action = 'g'
            },
        },
        outline = {
            win_position = 'right',
            win_with = '',
            win_width = 30,
            show_detail = true,
            auto_preview = true,
            auto_refresh = true,
            auto_close = true,
            custom_sort = nil,
            keys = {
                jump = 'o',
                expand_collapse = 'u',
                quit = 'q',
            },
        },
        callhierarchy = {
            show_detail = false,
            keys = {
                edit = 'e',
                vsplit = 's',
                split = 'i',
                tabe = 't',
                jump = 'o',
                quit = 'q',
                expand_collapse = 'u',
            },
        },
        symbol_in_winbar = {
            enable = true,
            separator = ' ',
            hide_keyword = true,
            show_file = true,
            folder_level = 2,
        },
        ui = {
            -- currently only round theme
            theme = 'round',
            -- border type can be single,double,rounded,solid,shadow.
            border = 'solid',
            winblend = 0,
            expand = '',
            collapse = '',
            preview = ' ',
            code_action = '💡',
            diagnostic = '🐞',
            incoming = ' ',
            outgoing = ' ',
            colors = {
                --float window normal bakcground color
                normal_bg = '#1d1536',
                --title background color
                title_bg = '#afd700',
                red = '#e95678',
                magenta = '#b33076',
                orange = '#FF8700',
                yellow = '#f7bb3b',
                green = '#afd700',
                cyan = '#36d0e0',
                blue = '#61afef',
                purple = '#CBA6F7',
                white = '#d1d4cf',
                black = '#1c1c19',
            },
            kind = {},
        },
    })
end

configs.nvim_lspconfig = function()
    require("lsp").setup()
end

configs.vim_gutentags = function()
    local settings = require("core.settings")
    local rootmarks = settings.rootmarks
    local tags_cache_path = settings.tags_path .. '.cache/tags'
    local executable = vim.fn.executable


    local gutentags_modules = {}
    -- ctags.exe路径
    local ctags_path = settings.tags_path .. 'ctags/ctags.exe'
    if executable(ctags_path) == 1 then
        gutentags_modules[#gutentags_modules+1] = 'ctags'
        vim.g.gutentags_ctags_executable = ctags_path
        -- 配置ctags的参数,老的Exuberant-ctags不能有--extra=+q，注意
        vim.g.gutentags_ctags_extra_args = {
            '--fields=+niazS',
            '--extras=+q',
            '--c++-kinds=+px',
            '--c-kinds=+px',
            -- 老的Exuberant-ctags不能有下面这个参数
            '--output-format=e-ctags'
        }
        -- vim.g.gutentags_ctags_exclude_wildignore = 0
        -- local wildignore = vim.fn.split(require("core.options").wildignore, ',')
        -- wildignore[#wildignore+1] = '*.py'
        vim.g.gutentags_ctags_exclude = {'*.py'}

        local cython_tags_exist = false
        local cython_tags_cache_path = tags_cache_path .. '/cython.tags'
        local cython_includes_path = settings:getpy('envs') .. 'default/Lib/site-packages/Cython/Includes'
        local generate_cython_includes = function()
            if vim.fn.isdirectory(cython_includes_path) == 1 then
                local cmd = string.format(
                    '%s -R --language-force=python --fields=+niazS --extras=+q --output-format=e-ctags -f %s %s',
                    ctags_path,
                    cython_tags_cache_path,
                    cython_includes_path
                )
                local ret = os.execute(cmd)
                if ret == 0 then
                    cython_tags_exist = true
                    vim.notify('successfully generate cython includes')
                end
            else
                vim.notify('could not find cython in path')
            end
        end
        if vim.fn.filereadable(cython_tags_cache_path) == 1 then
            cython_tags_exist = true
        else
            generate_cython_includes()
        end
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'pyrex',
            callback = function()
                if cython_tags_exist then
                    vim.cmd('setlocal tags+=' .. cython_tags_cache_path)
                    vim.api.nvim_buf_create_user_command(0, 'UpdateCythonIncludes', generate_cython_includes, {})
                end
            end
        })

        local c_tags_exist = false
        local c_tags_cache_path = tags_cache_path .. '/c.tags'
        local c_includes_path = settings.c_path .. 'TDM-GCC-64/x86_64-w64-mingw32/include'
        local generate_c_includes = function ()
            if vim.fn.isdirectory(c_includes_path) == 1 then
                local cmd = string.format(
                    '%s -I __THROW -I __attribute_pure__ -I __nonnull -I __attribute__ --fields=+niazS --extras=+q --output-format=e-ctags -f %s %s',
                    ctags_path,
                    c_tags_cache_path,
                    vim.fn.join({
                        c_includes_path .. '/std*',
                        c_includes_path .. '/string*',
                        c_includes_path .. '/sys/time*',
                    }, ' ')
                    -- c_includes_path
                )
                local ret = os.execute(cmd)
                if ret == 0 then
                    c_tags_exist = true
                    vim.notify('successfully generate c includes')
                end
            else
                vim.notify('could not find c in path')
            end
        end
        if vim.fn.filereadable(c_tags_cache_path) == 1 then
            c_tags_exist = true
        else
            generate_c_includes()
        end
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'c,cpp',
            callback = function()
                if c_tags_exist then
                    vim.cmd('setlocal tags+=' .. c_tags_cache_path)
                    vim.api.nvim_buf_create_user_command(0, 'UpdateCIncludes', generate_c_includes, {})
                end
            end
        })
    else
        vim.notify(string.format('%s not executable', ctags_path))
    end

    local gtags_path = settings.tags_path .. 'gtags/bin/gtags.exe'
    local gtags_cscope_path = settings.tags_path .. 'gtags/bin/gtags-cscope.exe'
    if executable(gtags_path) == 1 and executable(gtags_cscope_path) == 1 then
        gutentags_modules[#gutentags_modules+1] = 'gtags_cscope'
        -- GTAGSLABEL告诉gtags默认C/C++/Java等六种原生支持的代码直接使用gtags本地分析器，而其他语言使用pygments模块
        vim.env.GTAGSLABEL = 'native-pygments'
        vim.env.GTAGSCONF = settings.tags_path .. 'gtags/share/gtags/gtags.conf'
        vim.g.gutentags_gtags_executable = gtags_path
        vim.g.gutentags_gtags_cscope_executable = gtags_cscope_path
        -- 禁用gutentags自动加载gtags数据库的行为
        vim.g.gutentags_auto_add_gtags_cscope = 0
    else
        vim.notify(string.format('%s or %s not executable', gtags_path, gtags_cscope_path))
    end
    vim.g.gutentags_modules = gutentags_modules


    rootmarks[#rootmarks+1] = 'root'
    -- gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
    vim.g.gutentags_project_root = rootmarks
    -- 排除部分gutentags搜索工程目录的标志
    -- vim.g.gutentags_exclude_project_root = {'.pyproject'}
    -- 禁用默认
    vim.g.gutentags_add_default_project_roots = 0
    -- 所生成的数据文件的名称
    vim.g.gutentags_ctags_tagfile = '.tags'
    -- 将自动生成的tags文件全部放入指定目录中，避免污染工程目录
    vim.g.gutentags_cache_dir = tags_cache_path
    -- 若目录不存在则创建
    if vim.fn.isdirectory(tags_cache_path) == 0 then
        os.execute('mkdir -p ' .. tags_cache_path)
    end
    -- 排除部分文件类型
    vim.g.gutentags_exclude_filetypes = {
        'vim',
        'lua',
        'json',
        'yaml',
        'javascript',
        'typescript',
    }
    -- 允许高级命令和选项
    vim.g.gutentags_define_advanced_commands = 1
    -- 排除.gitignore文件
    -- It allows having :
    --    git tracked files
    --    git untracked files with .gitignore files/dirs excluded
    vim.g.gutentags_file_list_command = {
        markers = {
            ['.git'] = 'bash -c "git ls-files; git ls-files --others --exclude-standard"',
        },
    }
end

configs.gutentags_plus = function()
    vim.g.gutentags_plus_switch = 1
    vim.g.gutentags_plus_nomap = 1
end

return configs
