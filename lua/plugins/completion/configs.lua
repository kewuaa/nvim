local configs = {}

configs.nvim_cmp = function()
    local cmp = require('cmp')
    local luasnip = require('luasnip')
    local compare = cmp.config.compare
    local t = function(str)
        return vim.api.nvim_replace_termcodes(str, true, true, true)
    end
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0 and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]:sub(col, col):match("%s") == nil
    end
    -- local border = function(hl)
    --     return {
    --         { "╭", hl },
    --         { "─", hl },
    --         { "╮", hl },
    --         { "│", hl },
    --         { "╯", hl },
    --         { "─", hl },
    --         { "╰", hl },
    --         { "│", hl },
    --     }
    -- end
    local cmp_window = require("cmp.utils.window")
    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
        local info = self:info_()
        info.scrollable = false
        return info
    end

    local lsp_source = { name = 'nvim_lsp' }
    -- local tag_source = { name = 'tags' }
    local snip_source = { name = 'luasnip' }
    local buffer_source = {
        name = 'buffer',
        option = {
            get_bufnrs = function()
                local bufs = {}
                local get_bufsize = require('core.utils').get_bufsize
                for _, win in ipairs(vim.api.nvim_list_wins()) do
                    local bufnr = vim.api.nvim_win_get_buf(win)
                    local size = get_bufsize(bufnr)
                    if size < 256 then
                        bufs[#bufs+1] = bufnr
                    end
                end
                return bufs
            end,
        },
    }
    local latex_symbol_source = { name = 'latex_symbols' }
    -- local bibliography_source = { name = 'pandoc_references' }
    local bibliography_source = { name = 'cmp_pandoc' }
    local path_source = {
        name = 'path',
        option = {
            trailing_slash = false,
            -- get_cwd = require("core.utils").get_cwd,
        },
    }
    local dap_source = { name = 'dap' }
    local config = {
        enabled = function()
            local buffer_type = vim.api.nvim_buf_get_option(0, 'buftype')
            local filetype = vim.api.nvim_buf_get_option(0, 'filetype')
            if buffer_type == 'prompt' then
                if vim.startswith(filetype, 'dapui_') or filetype == 'dap-repl' then
                    return true
                else
                    return false
                end
            else
                return true
            end
        end,
        -- window = {
        --     completion = {
        --         border = border("Normal"),
        --         max_width = 80,
        --         max_height = 20,
        --         winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None",
        --         col_offset = -3,
        --         side_padding = 0,
        --     },
        --     documentation = {
        --         border = border("CmpDocBorder"),
        --         winhighlight = "Normal:Normal,FloatBorder:FloatBorder,CursorLine:Visual,Search:None"
        --     },
        -- },
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        sorting = {
            priority_weight = 2,
            comparators = {
                compare.score,
                -- compare.offset, -- Items closer to cursor will have lower priority
                compare.locality, -- Items closer to cursor will have higher priority, conflicts with `offset`
                require("cmp-under-comparator").under,
            },
        },
        formatting = {
            fields = { "kind", "abbr", "menu" },
            format = function (entry, vim_item)
                local kind = require('lspkind').cmp_format({
                    mode = "symbol_text",
                    maxwidth = 50,
                    menu = ({
                        buffer = "",
                        nvim_lsp = "",
                        luasnip = "",
                        tags = "",
                        path = "",
                        -- pandoc_references = '[Pandoc]',
                        cmp_pandoc = '[Pandoc]',
                        latex_symbols = 'ﭨ',
                        dap = "[Dap]",
                    }),
                    ellipsis_char = '...',
                })(entry, vim_item)
                local strings = vim.split(kind.kind, "%s", { trimempty = true })
                kind.kind = string.format(' %s ', strings[1])
                kind.menu = string.format('(%s) %s', strings[2], kind.menu)
                return kind
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            -- ["<C-p>"] = cmp.mapping.select_prev_item(),
            -- ["<C-n>"] = cmp.mapping.select_next_item(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
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
            ["<C-k>"] = cmp.mapping(function(fallback)
                if luasnip.jumpable(-1) then
                    vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-j>"] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                    vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources({
            path_source,
        }, {
            lsp_source,
            -- tag_source,
            buffer_source,
            snip_source,
        }),
    }
    cmp.setup(config)
    cmp.setup.filetype({'markdown'}, vim.tbl_deep_extend("force", config, {
        sources = cmp.config.sources({
            path_source,
        }, {
                lsp_source,
                buffer_source,
                bibliography_source,
                latex_symbol_source,
                snip_source,
            })
    }))
    -- cmp.setup.filetype('cython', vim.tbl_deep_extend('force', config, {
    --     sources = cmp.config.sources({
    --         path_source,
    --     }, {
    --         tag_source,
    --         snip_source,
    --         buffer_source,
    --     })
    -- }))
    cmp.setup.filetype({"dap-repl", "dapui_watches", "dapui_hover"}, vim.tbl_deep_extend(
        'force', config, {
            sources = {
                dap_source
            }
        }
    ))
    require('core.utils.bigfile').register(
        512,
        function(_)
            cmp.setup.buffer({ enabled = false })
        end,
        { defer = true }
    )
end

configs.cmp_pandoc = function()
    local fts = {'markdown', 'pandoc', 'rmd'}
    local function setup_cmp_pandoc()
        require('cmp_pandoc').setup({
            filetypes = fts,
        })
    end
    if vim.fn.index(fts, vim.bo.filetype) < 0 then
        vim.api.nvim_create_autocmd('FileType', {
            pattern = table.concat(fts, ','),
            once = true,
            callback = setup_cmp_pandoc
        })
    else
        setup_cmp_pandoc()
    end
end

configs.LuaSnip = function()
    local ls = require('luasnip')
    ls.config.set_config({
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        delete_check_events = "TextChanged,InsertLeave",
    })
    require("luasnip.loaders.from_vscode").lazy_load()
end

configs.nvim_lspconfig = function ()
    require('lsp').setup()
    local utils = require('core.utils')
    local threshold = 512
    require('core.utils.bigfile').register(threshold, function(bufnr)
        vim.api.nvim_create_autocmd('LspAttach', {
            buffer = bufnr,
            callback = function(args)
                vim.schedule(function()
                    vim.lsp.buf_detach_client(bufnr, args.data.client_id)
                end)
            end
        })
    end, {do_now = false})
    local bufnr = vim.api.nvim_get_current_buf()
    if utils.get_bufsize(bufnr) < threshold then
        local matching_configs = require('lspconfig.util').get_config_by_ft(vim.bo.filetype)
        for _, config in ipairs(matching_configs) do
            config.launch()
        end
    end
end

configs.lspsaga = function()
    local saga = require('lspsaga')
    saga.setup({
        finder = {
            edit = { 'o', '<CR>' },
            vsplit = '<c-v>',
            split = '<c-x>',
            tabe = '<c-t>',
            quit = { 'q', '<ESC>' },
        },
        definition = {
            edit = '<C-c>o',
            vsplit = '<C-c>v',
            split = '<C-c>x',
            tabe = '<C-c>t',
            quit = 'q',
            close = '<Esc>',
        },
        diagnostic = {
            on_insert = false,
            show_code_action = false,
            keys = {
                exec_action = 'o',
                quit = 'q',
                go_action = 'g'
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
        outline = {
            auto_preview = false,
        },
        ui = {
            border = 'single',
            -- colors = require("catppuccin.groups.integrations.lsp_saga").custom_colors(),
            -- kind = require("catppuccin.groups.integrations.lsp_saga").custom_kind(),
        },
    })
end

configs.neodev = function()
    require('neodev').setup({
        library = {
            plugins = { "nvim-dap-ui" },
            types = true,
            runtime = true,
        },
        setup_jsonls = true,
        lspconfig = true,
    })
end

configs.mason_lspconfig = function()
    require('mason-lspconfig').setup({
        automatic_installation = {
            exclude = {
                'zls',
            },
        },
    })
end

return configs
