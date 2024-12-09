local configs = {}

configs.compl = function()
    local compl = require("compl")
    compl.setup({
        completion = {
            fuzzy = true,
            timeout = 100
        },
        info = {
            enable = true,
            timeout = 100,
        },
        snippet = {
            enable = true,
            paths = {
                vim.fn.stdpath("config") .. "/snippets"
            },
        },
    })
    compl.attach_buffer(vim.api.nvim_get_current_buf())
    vim.keymap.set("i", "<C-Space>", "<C-x><C-u>", {silent = true, noremap = true})
    vim.keymap.set("i", "<C-y>", compl.accept, {silent = true, noremap = true, expr = true})
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
