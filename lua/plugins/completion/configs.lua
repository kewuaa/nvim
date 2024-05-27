local configs = {}

configs.nvim_cmp = function()
    local cmp = require('cmp')
    local compare = cmp.config.compare
    local has_words_before = function()
        local line, col = unpack(vim.api.nvim_win_get_cursor(0))
        return col ~= 0
            and vim.api.nvim_buf_get_lines(0, line - 1, line, true)[1]
                :sub(col, col)
                :match("%w") ~= nil
    end
    local cmp_window = require("cmp.utils.window")
    cmp_window.info_ = cmp_window.info
    cmp_window.info = function(self)
        local info = self:info_()
        info.scrollable = false
        return info
    end

    local lsp_source = { name = 'nvim_lsp' }
    local snip_source = { name = 'snippets', max_item_count = 10 }
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
            local buffer_type = vim.bo.buftype
            local filetype = vim.bo.filetype
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
        preselect = cmp.PreselectMode.None,
        snippet = {
            expand = function(args)
                -- Native sessions don't support nested snippet sessions.
                -- Always use the top-level session.
                -- Otherwise, when on the first placeholder and selecting a new completion,
                -- the nested session will be used instead of the top-level session.
                local session = vim.snippet.active() and vim.snippet._session or nil
                vim.snippet.expand(args.body)
                -- Restore top-level session when needed
                if session then
                    vim.snippet._session = session
                end
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
                local kind = vim_item.kind
                local name = ({
                    buffer = "[BUF]",
                    snippets = "[SNIP]",
                    nvim_lsp = "[LSP]",
                    path = "[PATH]",
                    cmdline = "[CMD]",
                    dap = "[DAP]",
                })[entry.source.name]
                vim_item.kind = ""
                vim_item.menu = string.format('(%s) %s', kind, name)
                return vim_item
            end,
        },
        mapping = cmp.mapping.preset.insert({
            ["<CR>"] = cmp.mapping.confirm({ select = true }),
            ["<C-p>"] = cmp.mapping.select_prev_item(),
            ["<C-e>"] = cmp.mapping.close(),
            ["<C-b>"] = cmp.mapping.scroll_docs(-4),
            ["<C-f>"] = cmp.mapping.scroll_docs(4),
            ["<Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_next_item()
                    elseif has_words_before() then
                        cmp.complete()
                    else
                        fallback()
                    end
                end,
                { "i", "s" }
            ),
            ["<S-Tab>"] = cmp.mapping(
                function(fallback)
                    if cmp.visible() then
                        cmp.select_prev_item()
                    else
                        fallback()
                    end
                end,
                { "i", "s" }
            ),
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
        { "dap-repl", "dapui_watches", "dapui_hover" },
        vim.tbl_deep_extend('force', config, { sources = { dap_source } })
    )

    cmp.event:on("confirm_done", function(event)
        local Kind = cmp.lsp.CompletionItemKind
        local item = event.entry:get_completion_item()
        if vim.tbl_contains({ Kind.Function, Kind.Method }, item.kind) then
            local cursor = vim.api.nvim_win_get_cursor(0)
            local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2], cursor[1] - 1, cursor[2] + 1, {})[1]
            if vim.fn.mode() ~= "s" and prev_char ~= "(" and prev_char ~= ")" then
                local keys = vim.api.nvim_replace_termcodes("()<left>", false, false, true)
                vim.api.nvim_feedkeys(keys, "i", true)
            end
        end
    end)

    require('core.utils.bigfile').register(
        512,
        function(_)
            cmp.setup.buffer({ enabled = false })
        end,
        { defer = true }
    )
end

configs.snippets = function()
    local config_path = vim.fn.stdpath("config")
    require("snippets").setup({
        create_cmp_source = true,
        friendly_snippets = false,
        extended_filetypes = {
            cython = {"python"},
            cpp = {"c"},
            cs = {"c"},
            javascript = {"c"}
        },
        search_paths = {
            config_path .. "/snippets"
        }
    })

    local map = vim.keymap.set
    local opts = {
        expr = true,
        silent = true,
    }
    map(
        {"i", "s"},
        "<C-j>",
        function()
            return vim.snippet.active({direction = 1}) and "<CMD>lua vim.snippet.jump(1)<CR>" or "<C-j>"
        end,
        opts
    )
    map(
        {"i", "s"},
        "<C-k>",
        function()
            return vim.snippet.active({direction = -1}) and "<CMD>lua vim.snippet.jump(-1)<CR>" or "<C-k>"
        end,
        opts
    )
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
            vim.lsp.buf.hover()
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

        map('n', '<C-S-K>', show_documentation, opts)
    end
    set_keymaps()
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
