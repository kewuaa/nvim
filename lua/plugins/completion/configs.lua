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
                compare.offset, -- Items closer to cursor will have lower priority
                compare.exact,
                compare.score,
                compare.recently_used,
                -- compare.locality, -- Items closer to cursor will have higher priority, conflicts with `offset`
                compare.length,
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
                        buffer = "[BUF]",
                        luasnip = "[SNIP]",
                        nvim_lsp = "[LSP]",
                        path = "[PATH]",
                        cmdline = "[CMD]",
                        -- pandoc_references = '[PANDOC]',
                        cmp_pandoc = '[PANDOC]',
                        latex_symbols = '[LATEX]',
                        dap = "[DAP]",
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
                    luasnip.jump(-1)
                    -- vim.fn.feedkeys(t("<Plug>luasnip-jump-prev"), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
            ["<C-j>"] = cmp.mapping(function(fallback)
                if luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                    -- vim.fn.feedkeys(t("<Plug>luasnip-expand-or-jump"), "")
                else
                    fallback()
                end
            end, { "i", "s" }),
        }),
        sources = cmp.config.sources(
            { path_source },
            {
                snip_source,
                lsp_source,
                buffer_source,
            }
        ),
    }
    cmp.setup(config)
    -- `/` cmdline setup.
    cmp.setup.cmdline({'/', '?'}, {
        mapping = cmp.mapping.preset.cmdline(),
        sources = {
            { name = 'buffer' }
        }
    })
    -- `:` cmdline setup.
    cmp.setup.cmdline(':', {
        mapping = cmp.mapping.preset.cmdline(),
        sources = cmp.config.sources({
            { name = 'path' }
        }, {
                {
                    name = 'cmdline',
                    option = {
                        ignore_cmds = { 'Man', '!' }
                    }
                }
            })
    })
    cmp.setup.filetype(
        {'markdown'},
        vim.tbl_deep_extend(
            "force",
            config,
            {
                sources = cmp.config.sources(
                    { path_source },
                    {
                        snip_source,
                        lsp_source,
                        buffer_source,
                        bibliography_source,
                        latex_symbol_source,
                    }
                )
            })
    )
    cmp.setup.filetype(
        { "dap-repl", "dapui_watches", "dapui_hover" },
        vim.tbl_deep_extend('force', config, { sources = { dap_source } })
    )
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
    local config_path = vim.fn.stdpath("config")
    ls.config.set_config({
        history = true,
        updateevents = 'TextChanged,TextChangedI',
        delete_check_events = "TextChanged,InsertLeave",
    })
    require("luasnip.loaders.from_vscode").lazy_load({paths = ("%s/mysnips/vscode"):format(config_path)})
    require("luasnip.loaders.from_lua").lazy_load({paths = ("%s/mysnips/lua"):format(config_path)})
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
            keys = {
                edit = { 'o', '<CR>' },
                vsplit = '<c-v>',
                split = '<c-x>',
                tabe = '<c-t>',
                quit = { 'q', '<ESC>' },
            }
        },
        definition = {
            keys = {
                edit = '<C-c>o',
                vsplit = '<C-c>v',
                split = '<C-c>x',
                tabe = '<C-c>t',
                quit = 'q',
                close = '<Esc>',
            },
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
            plugins = {"lazy.nvim"},
            types = true,
            runtime = true,
        },
        setup_jsonls = true,
        lspconfig = true,
    })
end

configs.crates = function()
    local crates = require("crates")
    crates.setup({
        lsp = {
            enabled = true,
            on_attach = require("lsp").on_attach,
            actions = true,
            completion = true,
            hover = true,
        },
    })
    local function show_documentation()
        local filetype = vim.bo.filetype
        if vim.tbl_contains({ 'vim','help' }, filetype) then
            vim.cmd('h '..vim.fn.expand('<cword>'))
        elseif vim.tbl_contains({ 'man' }, filetype) then
            vim.cmd('Man '..vim.fn.expand('<cword>'))
        elseif vim.fn.expand('%:t') == 'Cargo.toml' and require('crates').popup_available() then
            crates.show_popup()
        else
            vim.api.nvim_command("Lspsaga hover_doc")
        end
    end
    local map = vim.keymap.set
    local function set_keymaps(bufnr)
        local opts = { silent = true, buffer = bufnr ~= nil and bufnr or true }
        map("n", "<leader>ct", crates.toggle, opts)
        map("n", "<leader>cr", crates.reload, opts)

        map("n", "<leader>cv", crates.show_versions_popup, opts)
        map("n", "<leader>cf", crates.show_features_popup, opts)
        map("n", "<leader>cd", crates.show_dependencies_popup, opts)

        map("n", "<leader>cu", crates.update_crate, opts)
        map("v", "<leader>cu", crates.update_crates, opts)
        map("n", "<leader>cU", crates.upgrade_crate, opts)
        map("v", "<leader>cU", crates.upgrade_crates, opts)

        map('n', 'K', show_documentation, opts)
    end
    if vim.fn.expand("%:t") == "Cargo.toml" then
        set_keymaps()
    end
    vim.api.nvim_create_autocmd("BufRead", {
        group = vim.api.nvim_create_augroup("crates_keymap", {clear = true}),
        pattern = "Cargo.toml",
        callback = function(params)
            set_keymaps(params.buf)
        end
    })
end

configs.copilot = function()
    require("copilot").setup({
        panel = {
            enabled = false,
        },
        suggestion = {
            enabled = true,
            auto_trigger = true,
            keymap = {
                accept = "<M-;>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
            }
        },
    })

    -- hide copilot suggestions when cmp menu is open
    -- to prevent odd behavior/garbled up suggestions
    local cmp_status_ok, cmp = pcall(require, "cmp")
    if cmp_status_ok then
        cmp.event:on("menu_opened", function()
            vim.b.copilot_suggestion_hidden = true
        end)

        cmp.event:on("menu_closed", function()
            vim.b.copilot_suggestion_hidden = false
        end)
    end
end

return configs
