local M = {}
local map = vim.keymap.set
local servers = {
    'cpp',
    'dartls',
    'dockerls',
    'jsonls',
    'lua_ls',
    'pasls',
    'python',
    'rust_analyzer',
    'tsserver',
    'zls',
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    if client.name == 'pyright' then
        vim.schedule(function()
            require("core.utils.python").parse_pyenv(
                client.config.root_dir or vim.fn.expand("%:p:h")
            )
        end)
    end
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
        Error = "󰅚",
        Warn = "󰀪",
        Info = "",
        Hint = "󰌶",
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


local function add_auto_install_hook()
    local server_mapping = {
        ["clangd"] = "clangd",
        ["cmake"] = "cmake-language-server",
        ["dockerls"] = "dockerfile-language-server",
        ["jsonls"] = "json-lsp",
        ["lua_ls"] = "lua-language-server",
        ["neocmake"] = "neocmakelsp",
        ["pylsp"] = "python-lsp-server",
        ["pyright"] = "pyright",
        ["ruff_lsp"] = "ruff-lsp",
        ["rust_analyzer"] = "rust-analyzer",
        ["tsserver"] = "typescript-language-server",
    }
    local util = require("lspconfig.util")
    util.on_setup = util.add_hook_before(util.on_setup, function(config, user_config)
        local pkg_name = server_mapping[config.name]
        if not pkg_name then
            return
        end
        require("core.utils.mason").ensure_install(pkg_name)
    end)
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
    map(
        {"n", "t"},
        "<leader>tt",
        function()
            local cmd
            if require("core.settings").is_Windows then
                cmd = ("cd /d %s && %s"):format(
                    require("core.utils").get_cwd(),
                    vim.fn.executable("clink") == 1 and "cmd.exe /k clink inject" or "cmd.exe"
                )
            else
                cmd = ("cd %s && %s"):format(
                    require("core.utils").get_cwd(),
                    os.getenv("SHELL")
                )
            end
            require('lspsaga.floaterm'):open_float_terminal({cmd})
        end
    )

    add_auto_install_hook()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').default_capabilities(capabilities)
    local base_config = {
        on_attach = on_attach,
        capabilities = capabilities,
    }
    for _, name in ipairs(servers) do
        local ok, server = pcall(require, 'lsp.' .. name)
        if ok then
            for server_name, config in pairs(server) do
                if config.rootmarks then
                    config.root_dir = lsp_config.util.root_pattern(unpack(config.rootmarks))
                    config.rootmarks = nil
                end
                lsp_config[server_name].setup(vim.tbl_extend('force', base_config, config))
            end
        else
            lsp_config[name].setup(base_config)
        end
    end
end
M.on_attach = on_attach

return M
