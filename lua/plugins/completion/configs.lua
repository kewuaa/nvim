local configs = {}

configs.mini_completion = function()
    local accept = function()
        local keys = "<C-y>"
        local complete_info = vim.fn.complete_info()
        if complete_info.pum_visible == 1 then
            local idx = complete_info.selected
            if idx == -1 then
                keys = "<C-n>" .. keys
            end
        end
        return keys
    end

    local source_func = "omnifunc"
    require("mini.completion").setup({
        lsp_completion = {
            source_func = source_func,
            auto_setup = false
        },
        mappings = {
            scroll_down = "<C-S-F>",
            scroll_up = "<C-S-B>"
        }
    })
    vim.bo[source_func] = "v:lua.MiniCompletion.completefunc_lsp"

    local group = vim.api.nvim_create_augroup("kewuaa.completion", { clear = true })
    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
            vim.bo[args.buf][source_func] = "v:lua.MiniCompletion.completefunc_lsp"
        end
    })
    vim.api.nvim_create_autocmd("CompleteDone", {
        group = group,
        callback = function()
            if vim.v.event.reason ~= "accept" then
                return
            end
            local completion_item = vim.tbl_get(vim.v.completed_item, "user_data", "lsp", "item")
            if completion_item == nil then
                return
            end
            -- Automatically add brackets
            local CompletionItemKind = vim.lsp.protocol.CompletionItemKind
            if
                completion_item.kind == CompletionItemKind.Function
                or completion_item.kind == CompletionItemKind.Method
            then
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                local prev_char = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1]
                if prev_char:match("%w") then
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(
                            "<C-g>U()<C-g>U<left>",
                            true,
                            false,
                            true
                        ), "n", false
                    )
                end
            end
        end
    })
    vim.keymap.set("i", "<C-y>", accept, {silent = true, noremap = true, expr = true})
end

configs.mini_snippets = function()
    local mini_snippets = require("mini.snippets")
    local loader = mini_snippets.gen_loader
    mini_snippets.setup({
        snippets = {
            loader.from_lang({
                lang_patterns = {
                    cpp = { "**/c.json", "**/cpp.json" },
                    cs = { "**/c.json", "**/csharp.json" },
                    javascript = { "**/c.json", "**/javascript.json" },
                    cython = { "**/python.json", "**/cython.json" },
                }
            })
        },
        mappings = {
            expand = "<C-j>",
            jump_next = "<TAB>",
            jump_prev = "<S-TAB>",
            stop = "<C-c>"
        }
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
                accept = "<C-l>",
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
