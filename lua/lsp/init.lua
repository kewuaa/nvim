local M = {}
local group = vim.api.nvim_create_augroup("kewuaa.lsp", { clear = true })


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


-- Use an on_attach function to only map the following keys
-- after the language server attaches to the current buffer
function M.on_attach(client, bufnr)
    local map = vim.keymap.set
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


function M.setup()
    setup_ui()

    vim.lsp.config("*", {
        capabilities = vim.lsp.protocol.make_client_capabilities(),
        root_markers = { ".git" }
    })

    local names = {}
    local lsp_path = vim.fn.stdpath("config") .. "/lua/lsp"
    for _, file in ipairs(vim.fn.readdir(lsp_path)) do
        if file:match("%.lua$") and file ~= "init.lua" then
            local module_name = "lsp." .. file:gsub("%.lua$", "")
            for name, config in pairs(require(module_name)) do
                names[#names+1] = name
                vim.lsp.config(name, config)
                -- vim.lsp.enable(name, true)
            end
        end
    end

    vim.api.nvim_create_autocmd("LspAttach", {
        group = group,
        callback = function(args)
            local client = vim.lsp.get_client_by_id(args.data.client_id)
            M.on_attach(client, args.buf)
        end
    })
    return names
end

return M
