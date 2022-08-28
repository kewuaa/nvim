local M = {}
local map = vim.keymap.set

function M.setup()
    local pylsp = require('lsp.pylsp')
    -- local pyright = require("lsp.pyright")
    local lsp_config = require('lspconfig')


    -- Mappings.
    -- See `:help vim.diagnostic.*` for documentation on any of the below functions
    local opts = { noremap=true, silent=true }
    -- map('n', '<space>e', vim.diagnostic.open_float, opts)
    -- map('n', '<c-p>', vim.diagnostic.goto_prev, opts)
    -- map('n', '<c-n>', vim.diagnostic.goto_next, opts)
    -- map('n', '<space>q', vim.diagnostic.setloclist, opts)

    map("n", "<A-d>", "<cmd>Lspsaga open_floaterm python<CR>", opts)
    map("t", "<A-d>", "<C-\\><C-n><cmd>Lspsaga close_floaterm<CR>", opts)

    -- Use an on_attach function to only map the following keys
    -- after the language server attaches to the current buffer
    local on_attach = function(client, bufnr)
        -- Enable completion triggered by <c-x><c-o>
        vim.api.nvim_buf_set_option(bufnr, 'omnifunc', 'v:lua.vim.lsp.omnifunc')

        -- Mappings.
        -- See `:help vim.lsp.*` for documentation on any of the below functions
        local bufopts = { noremap=true, silent=true, buffer=bufnr }

        -- Show line diagnostics
        map("n", "<leader>cd", "<cmd>Lspsaga show_line_diagnostics<CR>", bufopts)

        -- Show cursor diagnostic
        map("n", "<leader>cd", "<cmd>Lspsaga show_cursor_diagnostics<CR>", bufopts)

        -- Diagnsotic jump can use `<c-o>` to jump back
        map("n", "[e", "<cmd>Lspsaga diagnostic_jump_next<CR>", bufopts)
        map("n", "]e", "<cmd>Lspsaga diagnostic_jump_prev<CR>", bufopts)

        -- Only jump to error
        map("n", "[E", function()
          require("lspsaga.diagnostic").goto_prev({ severity = vim.diagnostic.severity.ERROR })
        end, bufopts)
        map("n", "]E", function()
          require("lspsaga.diagnostic").goto_next({ severity = vim.diagnostic.severity.ERROR })
        end, bufopts)

        -- go to the definition
        map('n', 'gD', vim.lsp.buf.declaration, bufopts)
        map('n', 'gd', vim.lsp.buf.definition, bufopts)
        -- preview the definition
        map("n", "<leader>pd", "<cmd>Lspsaga preview_definition<CR>", bufopts)

        -- hover doc
        -- map('n', 'K', vim.lsp.buf.hover, bufopts)
        map("n", "K", "<cmd>Lspsaga hover_doc<CR>", bufopts)
        map('n', 'gi', vim.lsp.buf.implementation, bufopts)
        map('n', '<C-k>', vim.lsp.buf.signature_help, bufopts)

        map('n', '<space>D', vim.lsp.buf.type_definition, bufopts)

        -- rename
        -- map('n', '<space>rn', vim.lsp.buf.rename, bufopts)
        map("n", "<leader>rn", "<cmd>Lspsaga rename<CR>", bufopts)

        -- find references
        -- map('n', 'gr', vim.lsp.buf.references, bufopts)
        map("n", "gr", "<cmd>Lspsaga lsp_finder<CR>", bufopts)

        -- Outline
        map("n","<leader>o", "<cmd>LSoutlineToggle<CR>", bufopts)

        -- format
        map('n', '<space>f', vim.lsp.buf.formatting, bufopts)

        -- code action
        -- map('n', '<leader>ca', vim.lsp.buf.code_action, bufopts)
        map("n", "<leader>ca", "<cmd>Lspsaga code_action<CR>", bufopts)
        map("v", "<leader>ca", "<cmd><C-U>Lspsaga range_code_action<CR>", bufopts)

        local action = require("lspsaga.action")
        -- scroll in hover doc or  definition preview window
        map("n", "<C-f>", function()
            action.smart_scroll_with_saga(1)
        end, { silent = true })
        -- scroll in hover doc or  definition preview window
        map("n", "<C-b>", function()
            action.smart_scroll_with_saga(-1)
        end, { silent = true })

        -- workspace
        map('n', '<leader>wa', vim.lsp.buf.add_workspace_folder, bufopts)
        map('n', '<leader>wr', vim.lsp.buf.remove_workspace_folder, bufopts)
        map('n', '<leader>wl', function()
            print(vim.inspect(vim.lsp.buf.list_workspace_folders()))
        end, bufopts)

        -- trigger hook
        require('lsp.hook').trigger(client, bufnr)
    end

    local lsp_flags = {
      -- This is the default in Nvim 0.7+
      debounce_text_changes = 150,
    }
    local find_root = lsp_config.util.root_pattern
    local capabilities = vim.lsp.protocol.make_client_capabilities()
    capabilities = require('cmp_nvim_lsp').update_capabilities(capabilities)

    lsp_config.pylsp.setup({
        root_dir = find_root(unpack(pylsp.rootmarks)),
        name = 'pylsp',
        filetypes = {'python'},
        autostart = true,
        single_file_support = true,
        on_new_config = pylsp.update_config,
        cmd = {pylsp.path .. 'pylsp.exe'},
        on_attach = on_attach,
        settings = pylsp.settings,
        capabilities = capabilities,
        flags = lsp_flags,
    })
    -- lsp_config.pyright.setup({
    --     root_dir = find_root(unpack(pyright.rootmarks)),
    --     name = 'pyright',
    --     filetypes = {'python'},
    --     autostart = true,
    --     single_file_support = true,
    --     on_new_config = pyright.update_config,
    --     cmd = {pyright.path .. 'pyright-python-langserver.exe', '--stdio'},
    --     on_attach = on_attach,
    --     settings = pyright.settings,
    --     capabilities = capabilities,
    --     flags = lsp_flags,
    -- })
end

return M

