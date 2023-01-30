local M = {}

function M.lsp(client, bufnr)
    local map = vim.keymap.set
    local bufopt = {
        noremap = true,
        silent = true,
        buffer = bufnr,
    }
    map("n", "<leader>xx", "<cmd>Trouble<cr>", bufopt)
    map("n", "<leader>xw", "<cmd>Trouble workspace_diagnostics<cr>", bufopt)
    map("n", "<leader>xd", "<cmd>Trouble document_diagnostics<cr>", bufopt)
    map("n", "<leader>xl", "<cmd>Trouble loclist<cr>", bufopt)
    map("n", "<leader>xq", "<cmd>Trouble quickfix<cr>", bufopt)
    map("n", "gR", "<cmd>Trouble lsp_references<cr>", bufopt)

    require("lsp_signature").on_attach({
        bind = true,
        use_lspsaga = true,
        doc_lines = 0,
        floating_window = false,
        -- hint_scheme = 'LspSignatureHintVirtualText',
        hint_prefix = ' ',
    }, bufnr)
end

return M
