local configs = {}

configs.mini_completion = function()
    local fuzzy = require("mini.fuzzy")
    fuzzy.setup()
    local load_snippets = function(base)
        local ok, snippets = pcall(require, "snippets")
        if not ok then
            vim.notify_once("load snippets failed", vim.log.levels.WARN)
            return
        end
        local loaded_snippets = snippets.load_snippets_for_ft(vim.bo.filetype)
        if not loaded_snippets then
            return
        end
        local response = {}

        for key in pairs(loaded_snippets) do
            local snippet = loaded_snippets[key]
            local body
            if type(snippet.body) == "table" then
                body = table.concat(snippet.body, "\n")
            else
                body = snippet.body
            end

            local prefix = loaded_snippets[key].prefix
            if type(prefix) == "table" then
                for _, p in ipairs(prefix) do
                    table.insert(response, {
                        label = p .. "~",
                        kind = 15,
                        documentation = snippet.description,
                        data = {
                            prefix = base,
                            body = body,
                        },
                    })
                end
            else
                table.insert(response, {
                    label = prefix .. "~",
                    kind = 15,
                    documentation = snippet.description,
                    data = {
                        prefix = base,
                        body = body,
                    },
                })
            end
        end
        return response
    end
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
                local snippets = load_snippets(base)
                if snippets then
                    item = vim.list_extend(snippets, item)
                end
                return fuzzy.process_lsp_items(item, base)
            end
        }
    })
end

configs.snippets = function()
    local config_path = vim.fn.stdpath("config")
    require("snippets").setup({
        create_autocmd = true,
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
end

return configs
