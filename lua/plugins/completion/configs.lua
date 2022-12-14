local configs = {}


configs.lspsaga = function()
    local saga = require('lspsaga')
    saga.init_lsp_saga({
        -- "single" | "double" | "rounded" | "bold" | "plus"
        border_style = "single",
        finder_action_keys = {
            open = "o",
            vsplit = "v",
            split = "h",
            tabe = "t",
            quit = "q",
        },
        definition_action_keys = {
            edit = '<C-c>o',
            vsplit = '<C-c>v',
            split = '<C-c>h',
            tabe = '<C-c>t',
            quit = 'q',
        },
        rename_action_quit = "<C-c>",
        -- show symbols in winbar must nightly
        -- in_custom mean use lspsaga api to get symbols
        -- and set it to your custom winbar or some winbar plugins.
        -- if in_cusomt = true you must set in_enable to false
        symbol_in_winbar = {
            in_custom = false,
            enable = true,
            separator = ' ',
            show_file = true,
            -- define how to customize filename, eg: %:., %
            -- if not set, use default value `%:t`
            -- more information see `vim.fn.expand` or `expand`
            -- ## only valid after set `show_file = true`
            file_formatter = "",
            click_support = function(node, clicks, button, modifiers)
                -- To see all avaiable details: vim.pretty_print(node)
                local st = node.range.start
                local en = node.range['end']
                if button == "l" then
                    if clicks == 2 then
                        -- double left click to do nothing
                    else -- jump to node's starting line+char
                        vim.fn.cursor(st.line + 1, st.character + 1)
                    end
                elseif button == "r" then
                    if modifiers == "s" then
                        print "lspsaga" -- shift right click to print "lspsaga"
                    end -- jump to node's ending line+char
                    vim.fn.cursor(en.line + 1, en.character + 1)
                elseif button == "m" then
                    -- middle click to visual select node
                    vim.fn.cursor(st.line + 1, st.character + 1)
                    vim.cmd "normal v"
                    vim.fn.cursor(en.line + 1, en.character + 1)
                end
            end
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
        local generate_cython_includes = function()
            if vim.fn.filereadable(cython_tags_cache_path) == 1 then
                cython_tags_exist = true
                return
            end
            local cython_path = vim.fn.exepath('cython')
            if cython_path ~= '' then
                local cython_includes_path = cython_path .. '/../../Lib/site-packages/Cython/Includes'
                local cmd = string.format(
                    '%s -R --fields=+niazS --extras=+q --output-format=e-ctags -f %s %s',
                    ctags_path,
                    cython_tags_cache_path,
                    cython_includes_path
                )
                local ret = os.execute(cmd)
                if ret == 0 then
                    cython_tags_exist = true
                end
            end
        end
        generate_cython_includes()
        vim.api.nvim_create_autocmd('FileType', {
            pattern = 'pyrex',
            callback = function()
                if cython_tags_exist then
                    vim.cmd('setlocal tags+=' .. cython_tags_cache_path)
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


    rootmarks[#rootmarks+1] = '.root'
    rootmarks[#rootmarks+1] = '.project'
    -- gutentags搜索工程目录的标志，碰到这些文件/目录名就停止向上一级目录递归
    vim.g.gutentags_project_root = rootmarks
    -- 排除部分gutentags搜索工程目录的标志
    vim.g.gutentags_exclude_project_root = {'.pyproject'}
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

configs.nvim_cmp = function()
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
        sources = cmp.config.sources(
            {
                { name = 'nvim_lsp' },
                { name = 'tags' },
                { name = 'luasnip' },
                {
                    name = 'path',
                    option = {
                        trailing_slash = false,
                        get_cwd = require("plugins").get_cwd,
                    },
                }
            },
            {
                { name = 'nvim_lua' },
                {
                    name = 'buffer',
                    option = {
                        get_bufnrs = function()
                            return vim.api.nvim_list_bufs()
                        end,
                    },
                },
            }
        ),
    })

    local packer = require("plugins")
    if vim.bo.ft == 'lua' then
        packer.check_loaded('cmp-nvim-lua')
    else
        packer.delay_load('FileType', 'lua', 0, 'cmp-nvim-lua')
    end
    packer.delay_load('InsertEnter', '*', 0, 'LuaSnip')
    packer.delay_load('CmdLineEnter', '/,:', 0, 'cmp-cmdline')
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
    require("plugins").check_loaded(
        'cmp-buffer',
        'cmp-path'
    )
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
    require("cmp").setup({
        formatting = {
            format = require("lspkind").cmp_format({
                mode = 'symbol', -- show only symbol annotations
                with_text = true, -- do not show text alongside icons
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)

                -- The function below will be called before any actual modifications from lspkind
                -- so that you can provide more controls on popup customization. (See [#30](https://github.com/onsails/lspkind-nvim/pull/30))
                before = function(entry, vim_item)
                    -- Source 显示提示来源
                    vim_item.menu = "[" .. string.upper(entry.source.name) .. "]"
                    return vim_item
                end
            })
        }
    })
end

configs.nvim_autopairs = function()
    require("plugins").check_loaded('nvim-cmp')
    local npairs = require("nvim-autopairs")
    local Rule = require("nvim-autopairs.rule")
    local cmp_autopairs = require('nvim-autopairs.completion.cmp')
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
        'confirm_done',
        cmp_autopairs.on_confirm_done()
    )
    npairs.add_rule(Rule('<', '>'))
    npairs.add_rule(Rule("|", "|", { 'zig' }))
end


return configs
