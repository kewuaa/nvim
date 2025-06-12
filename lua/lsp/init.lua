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
    -- Mappings.
    -- See `:help vim.lsp.*` for documentation on any of the below functions
    local bufopts = { noremap=true, silent=true, buffer=bufnr }

    map('n', '[d', function() vim.diagnostic.jump({count = -1, float = true}) end, bufopts)
    map('n', ']d', function() vim.diagnostic.jump({count = 1, float = true}) end, bufopts)

    -- go to the definition
    -- map('n', '', vim.lsp.buf.declaration, bufopts)
    map('n', 'gd', vim.lsp.buf.definition, bufopts)
    map('n', 'gD', vim.lsp.buf.type_definition, bufopts)

    -- format
    map('n', '<leader>fmt', function() vim.lsp.buf.format{async = true} end, bufopts)
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
