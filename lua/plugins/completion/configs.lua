local configs = {}

configs.mini_completion = function()
    local fuzzy = require("mini.fuzzy")
    fuzzy.setup()
    require("mini.completion").setup({
        delay = {
            completion = 100,
            info = 100,
            signature = 50
        },
        window = {
            info = { height = 25, width = 80, border = 'single' },
            signature = { height = 25, width = 80, border = 'single' },
        },
        lsp_completion = {
            source_func = "omnifunc",
            auto_setup = false,
            process_items = function(item, base)
                return fuzzy.process_lsp_items(item, base)
            end
        }
    })
    vim.keymap.set('i', '<Tab>',   [[pumvisible() ? "\<C-n>" : "\<Tab>"]],   { expr = true })
    vim.keymap.set('i', '<S-Tab>', [[pumvisible() ? "\<C-p>" : "\<S-Tab>"]], { expr = true })
    -- For using enter as completion, may conflict with some autopair plugin
    vim.keymap.set("i", "<cr>", function()
        local complete_info = vim.fn.complete_info()
        vim.print(complete_info)
        if complete_info.pum_visible == 1 then
            local keys = "<C-y>"
            local idx = complete_info.selected
            local selected_item
            if idx > -1 then
                selected_item = complete_info.items[idx + 1]
            else
                selected_item = complete_info.items[1]
                keys = "<C-n>" .. keys
            end
            if selected_item.kind == "Function" then
                local cursor = vim.api.nvim_win_get_cursor(0)
                local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2] - 1, cursor[1] - 1, cursor[2], {})[1]
                if vim.fn.mode() ~= "s" and prev_char ~= "(" and prev_char ~= ")" then
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(
                            "()<left>",
                            true,
                            false,
                            true
                        ), "i", false
                    )
                end
            end
            return keys
        else
            return "<CR>"
        end
    end, { expr = true, noremap = true })
end

configs.snippets = function()
    local config_path = vim.fn.stdpath("config")
    require("snippets").setup({
        create_cmp_source = false,
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
    require('core.utils.bigfile').register(
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
