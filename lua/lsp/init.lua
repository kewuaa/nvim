local M = {}
local map = vim.keymap.set


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- if vim.bo.ft == "python" then
    --     if client.name == "pylsp" then
    --         client.server_capabilities.codeActionProvider = false
    --         client.server_capabilities.completionProvider = false
    --         client.server_capabilities.resolveProvider = false
    --         client.server_capabilities.definitionProvider = true

    --         client.server_capabilities.documentHighlightProvider = false

    --         client.server_capabilities.documentSymbolProvider = false
    --         client.server_capabilities.executeCommandProvider = false
    --         client.server_capabilities.hoverProvider = false
    --         client.server_capabilities.referencesProvider = false
    --         client.server_capabilities.renameProvider = false
    --         client.server_capabilities.signatureHelpProvider = false

    --         -- client.server_capabilities.textDocumentSync = false

    --         client.server_capabilities.typeDefinitionProvider = true
    --         client.server_capabilities.workspace = false
    --         client.server_capabilities.workspaceProvider = false
    --         client.server_capabilities.workspaceSymbolProvider = false
    --     elseif client.name == "pyright" then
    --         client.server_capabilities.definitionProvider = false
    --         client.server_capabilities.typeDefinitionProvider = false
    --     end
    -- end
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    -- Show line diagnostics
    map("n", "<leader>sl", "<cmd>Lspsaga show_line_diagnostics<CR>", bufopts)
    -- Show cursor diagnostic
    map("n", "<leader>sc", "<cmd>Lspsaga show_cursor_diagnostics<CR>", bufopts)
    -- Show buffer diagnostic
    map("n", "<leader>sb", "<cmd>Lspsaga show_buf_diagnostics<CR>", bufopts)

    -- Diagnsotic jump can use `<c-o>` to jump back
    map("n", "]e", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)
    map("n", "[e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)

    -- Only jump to error
    map("n", "[E", function()
      require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
    end, bufopts)
    map("n", "]E", function()
      require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
    end, bufopts)

    -- go to the definition
    -- map('n', 'gD', vim.lsp.buf.declaration, bufopts)
    map("n", "gd", "<cmd>Lspsaga peek_definition<CR>", bufopts)
    map("n","gD", "<cmd>Lspsaga goto_definition<CR>", bufopts)
    -- map('n', 'gd', vim.lsp.buf.definition, bufopts)

    -- hover doc
    -- map('n', 'K', vim.lsp.buf.hover, bufopts)
    map("n", "K", "<cmd>Lspsaga hover_doc<CR>", bufopts)
    -- map('n', 'gi', vim.lsp.buf.implementation, bufopts)
    -- map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

    -- map('n', '<space>D', vim.lsp.buf.type_definition, bufopts)

    -- rename
    -- map('n', '<space>rn', vim.lsp.buf.rename, bufopts)
    map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", bufopts)

    -- find references
    -- map('n', 'gr', vim.lsp.buf.references, bufopts)
    map("n", "gr", "<cmd>Lspsaga finder<CR>", bufopts)

    -- Outline
    map("n","<leader>o", "<cmd>Lspsaga outline<CR>", bufopts)

    -- Callhierarchy
    map("n", "<Leader>ci", "<cmd>Lspsaga incoming_calls<CR>", bufopts)
    map("n", "<Leader>co", "<cmd>Lspsaga outgoing_calls<CR>", bufopts)

    -- format
    -- map('n', '<space>f', function() vim.lsp.buf.format{async = true} end, bufopts)

    -- code action
    -- map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
    map({'n', 'v'}, '<leader>ca', '<cmd>Lspsaga code_action<CR>', bufopts)

    -- workspace
    -- map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- map('n', '<leader>wl', function()
    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
    require("plugins.attach").lsp(client, bufnr)
end

local function setup_ui()
    -- Set icons for sidebar.
    local diagnostic_icons = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
    }
    for type, icon in pairs(diagnostic_icons) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
    end

    vim.diagnostic.config({
      signs = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      virtual_text = {
        source = true,
      },
    })
end


function M.setup()
    setup_ui()
    local lsp_config = require('lspconfig')

    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    -- local opts = { noremap=true, silent=true }
    -- map('n', '<space>e', vim.diagnostic.open_float, opts)
    -- map('n', '<c-p>', vim.diagnostic.goto_prev, opts)
    -- map('n', '<c-n>', vim.diagnostic.goto_next, opts)
    -- map('n', '<space>q', vim.diagnostic.setloclist, opts)
    map({"n", "t"}, "<A-=>", "<cmd>Lspsaga term_toggle<CR>")

    local lsp_flags = {
      -- This is the default in Nvim 0.7+
      debounce_text_changes = 150,
    }
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    local base_config = {
        loglevel = vim.lsp.protocol.MessageType.Error,
        autostart = true,
        single_file_support = true,
        on_attach = on_attach,
        capabilities = capabilities,
        flags = lsp_flags,
        root_dir = lsp_config.util.find_git_ancestor,
    }
    for _, lang in ipairs({
        'python',
        'c_cpp',
        'zig',
        'haskell',
        'rust',
        'lua',
        'js_ts',
        'markdown',
        'vim',
        'toml',
        'json',
    }) do
        local ok, config = pcall(require, 'lsp.' .. lang)
        if ok then
            for name, server in pairs(config) do
                if vim.fn.executable(server.cmd[1]) == 1 then
                    if server.rootmarks then
                        server.root_dir = lsp_config.util.root_pattern(unpack(server.rootmarks))
                        server.rootmarks = nil
                    end
                    lsp_config[name].setup(
                        vim.tbl_extend('force', base_config, server)
                    )
                else
                    vim.notify(string.format('%s not executable', server.cmd[1]))
                end
            end
        else
            vim.notify(string.format('load lsp of %s failed', lang))
        end
    end
end

return M
