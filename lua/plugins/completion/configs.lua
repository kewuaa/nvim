local configs = {}

configs.blink_cmp = function()
    require("blink.cmp").setup({
        keymap = {
            preset = 'default',
            ["<C-y>"] = {'select_and_accept', 'fallback'},
            ["<C-e>"] = {'cancel', 'fallback'},
        },

        appearance = {
            -- Sets the fallback highlight groups to nvim-cmp's highlight groups
            -- Useful for when your theme doesn't support blink.cmp
            -- will be removed in a future release
            use_nvim_cmp_as_default = false,
            -- Set to 'mono' for 'Nerd Font Mono' or 'normal' for 'Nerd Font'
            -- Adjusts spacing to ensure icons are aligned
            nerd_font_variant = 'mono'
        },

        fuzzy = {
            sorts = { "score", "label" }
        },

        -- default list of enabled providers defined so that you can extend it
        -- elsewhere in your config, without redefining it, via `opts_extend`
        sources = {
            completion = {
                enabled_providers = function(ctx)
                    local node = vim.treesitter.get_node()
                    if node and vim.tbl_contains(
                        {
                            'comment',
                            'line_comment',
                            'block_comment',
                        },
                        node:type()
                    ) then
                        return { 'path', 'buffer' }
                    else
                        return { 'path', 'snippets', 'lsp', 'buffer' }
                    end
                end,
            },
            providers = {
                path = {
                    opts = {
                        trailing_slash = false,
                        label_trailing_slash = true,
                        get_cwd = function(context)
                            return vim.fn.expand(('#%d:p:h'):format(context.bufnr))
                        end,
                        show_hidden_files_by_default = false,
                    }
                },
                snippets = {
                    enabled = function(ctx)
                        return ctx ~= nil
                        and ctx.trigger.kind ~= vim.lsp.protocol.CompletionTriggerKind.TriggerCharacter
                    end,
                    opts = {
                        friendly_snippets = false,
                        search_paths = {
                            vim.fn.stdpath('config') .. '/snippets',
                        },
                        global_snippets = { 'all' },
                        extended_filetypes = {
                            cython = {"python"},
                            cpp = {"c"},
                            cs = {"c"},
                            javascript = {"c"}
                        },
                        ignored_filetypes = {},
                        get_filetype = function(context)
                            return vim.bo.filetype
                        end
                    }
                },
                buffer = {
                    fallback_for = { 'lsp' },
                    opts = {
                        -- default to all visible buffers
                        get_bufnrs = function()
                            return vim
                            .iter(vim.api.nvim_list_wins())
                            :map(function(win) return vim.api.nvim_win_get_buf(win) end)
                            :filter(function(buf) return vim.bo[buf].buftype ~= 'nofile' end)
                            :totable()
                        end,
                    }
                },
            }
        },

        completion = {
            list = {
                max_items = 100,
                selection = "auto_insert",
            },

            accept = {
                -- experimental auto-brackets support
                auto_brackets = {
                    enabled = true,
                },
            },
        },

        -- experimental signature help support
        -- signature = { enabled = true },
    })
end

configs.nvim_lspconfig = function()
    require('lsp').setup()
    local utils = require('utils')
    require('utils.bigfile').register(
        {
            threshold = 0.5,
            callback = function(bufnr)
                vim.api.nvim_create_autocmd('LspAttach', {
                    buffer = bufnr,
                    callback = function(args)
                        vim.schedule(function()
                            vim.lsp.buf_detach_client(bufnr, args.data.client_id)
                        end)
                    end
                })
            end,
            defer = false
        }, {schedule = false}
    )
    local bufnr = vim.api.nvim_get_current_buf()
    if utils.cal_bufsize(bufnr) < 0.5 then
        local matching_configs = require('lspconfig.util').get_config_by_ft(vim.bo.filetype)
        for _, config in ipairs(matching_configs) do
            config.launch()
        end
    end
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
    vim.schedule(set_keymaps)
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
                accept = "<TAB>",
                accept_word = false,
                accept_line = false,
                next = "<M-]>",
                prev = "<M-[>",
                dismiss = "<C-]>",
            }
        },
    })
end

configs.fittencode = function()
    require("fittencode").setup({
        disable_specific_inline_completion = {
            suffixes = {}
        },
        inline_completion = {
            enable = true,
            auto_triggering_completion = false,
        },
        source_complection = {
            enable = false
        },
        keymaps = {
            inline = {
                ['<TAB>'] = 'accept_all_suggestions',
                ['<C-Down>'] = 'accept_line',
                ['<C-Right>'] = 'accept_word',
                ['<C-Up>'] = 'revoke_line',
                ['<C-Left>'] = 'revoke_word',
                ['<A-\\>'] = 'triggering_completion',
            },
            chat = {
                ['q'] = 'close',
                ['[c'] = 'goto_previous_conversation',
                [']c'] = 'goto_next_conversation',
                ['c'] = 'copy_conversation',
                ['C'] = 'copy_all_conversations',
                ['d'] = 'delete_conversation',
                ['D'] = 'delete_all_conversations',
            }
        },
        completion_mode = "inline"
    })
end

return configs
