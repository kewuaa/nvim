local M = {}
local map = vim.keymap.set
local servers = {
    'cpp',
    'dockerls',
    'jsonls',
    'lua_ls',
    'mesonlsp',
    'python',
    'rust_analyzer',
    'taplo',
    'tinymist',
    'ts_ls',
    'zls',
}

-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
local on_attach = function(client, bufnr)
    -- Enable completion triggered by <c-x><c-o>
    vim.api.nvim_buf_set_var(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    map('n', '[d', function() vim.diagnostic.jump({count = -1, float = true}) end, bufopts)
    map('n', ']d', function() vim.diagnostic.jump({count = 1, float = true}) end, bufopts)
    -- map('n', '<space>D', vim.diagnostic.open_float, bufopts)
    map('n', '<leader>ld', vim.diagnostic.setloclist, bufopts)

    -- go to the definition
    -- map('n', '', vim.lsp.buf.declaration, bufopts)
    map('n', 'gd', vim.lsp.buf.definition, bufopts)
    map('n', 'gD', vim.lsp.buf.type_definition, bufopts)

    -- hover doc
    map('n', 'K', vim.lsp.buf.hover, bufopts)
    map('n', 'gi', vim.lsp.buf.implementation, bufopts)
    map({'n', 'i'}, '<M-S-k>', vim.lsp.buf.signature_help, bufopts)

    -- rename
    map('n', '<leader>rn', vim.lsp.buf.rename, bufopts)

    -- find references
    map('n', 'gr', vim.lsp.buf.references, bufopts)

    -- format
    map('n', '<leader>fmt', function() vim.lsp.buf.format{async = true} end, bufopts)

    -- code action
    map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)

    -- workspace
    -- map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
    -- map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
    -- map('n', '<leader>wl', function()
    --     print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
    -- end, bufopts)
end

local function setup_ui()
    -- Set icons for sidebar.
    local diagnostic_icons = {
        Error = "󰅚",
        Warn = "󰀪",
        Info = "",
        Hint = "󰌶",
    }
    local text = {}
    local numhl = {}
    for type, icon in pairs(diagnostic_icons) do
        local key = vim.diagnostic.severity[type:upper()]
        text[key] = icon
        local numhl_name = "DiagnosticSign" .. type
        numhl[key] = numhl_name
    end
    vim.diagnostic.config({
      signs = {
          text = text,
          numhl = numhl,
      },
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
        ["pyright"] = "pyright",
        ["clangd"] = "clangd",
        ["cmake"] = "cmake-language-server",
        ["dockerls"] = "dockerfile-language-server",
        ["jsonls"] = "json-lsp",
        ["lua_ls"] = "lua-language-server",
        ["mesonlsp"] = "mesonlsp",
        ["neocmake"] = "neocmakelsp",
        ["ruff"] = "ruff",
        ["rust_analyzer"] = "rust-analyzer",
        ["taplo"] = "taplo",
        ["tinymist"] = "tinymist",
        ["ts_ls"] = "typescript-language-server",
    }
    local util = require("lspconfig.util")
    util.on_setup = util.add_hook_before(util.on_setup, function(config, user_config)
        local pkg_name = server_mapping[config.name]
        if not pkg_name then
            return
        end
        require("utils.mason").ensure_install(pkg_name, {
            success = function()
                require("lspconfig")[config.name].setup(config)
            end
        })
    end)
end


function M.setup()
    setup_ui()
    local lsp_config = require('lspconfig')

    add_auto_install_hook()

    local capabilities = vim.lsp.protocol.make_client_capabilities()
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
