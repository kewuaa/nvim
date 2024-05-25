local M = {}
local state = false
local group = "_lsp_utils_"
local lazy_refresh_buffers = {}

local toggle_inlay_hint = function(enable)
    local client = vim.lsp.get_clients({bufnr = 0})[1]
    if client == nil then
        return
    end
    if not client.supports_method("textDocument/inlayHint") then
        vim.notify(("%s seems not support inlayHint"):format(client.name))
        return
    end
    local buffers = vim.lsp.get_buffers_by_client_id(client.id)
    for _, bufnr in pairs(buffers) do
        vim.lsp.inlay_hint.enable(enable, {bufnr = bufnr})
    end
end

local toggle_codelens = function(enable)
    local client = vim.lsp.get_clients({bufnr = 0})[1]
    if client == nil then
        return
    end
    if not client.supports_method("textDocument/codeLens") then
        vim.notify(("%s seems not support codeLens"):format(client.name))
        return
    end
    local buffers = vim.lsp.get_buffers_by_client_id(client.id)
    if enable then
        if #buffers > 1 then
            local visible_bufs = {}
            for _, win in pairs(vim.api.nvim_list_wins()) do
                visible_bufs[#visible_bufs+1] = vim.api.nvim_win_get_buf(win)
            end
            for _, bufnr in pairs(buffers) do
                if vim.fn.index(visible_bufs, bufnr) > -1 then
                    vim.lsp.codelens.refresh({bufnr = bufnr})
                else
                    if vim.fn.index(lazy_refresh_buffers, bufnr) == -1 then
                        lazy_refresh_buffers[#lazy_refresh_buffers+1] = bufnr
                        vim.api.nvim_create_autocmd("BufEnter", {
                            desc = "lazy refresh",
                            group = group,
                            buffer = bufnr,
                            once = true,
                            callback = function()
                                local idx = vim.fn.index(lazy_refresh_buffers, bufnr)
                                table.remove(lazy_refresh_buffers, idx + 1)
                                vim.lsp.codelens.refresh({bufnr = bufnr})
                            end
                        })
                    end
                end
            end
        else
            for _, bufnr in pairs(buffers) do
                vim.lsp.codelens.refresh({bufnr = bufnr})
            end
        end
    else
        vim.lsp.codelens.clear(client.id, nil)
    end
end

local toggle = function()
    if state then
        state = false
        vim.api.nvim_del_augroup_by_name(group)
        toggle_inlay_hint(false)
        toggle_codelens(false)
    else
        state = true
        vim.api.nvim_create_augroup(group, {clear = true})
        toggle_inlay_hint(true)
        toggle_codelens(true)
        vim.api.nvim_create_autocmd("InsertEnter", {
            desc = "disable inlay hint and codelens when InsertEnter",
            group = group,
            callback = function()
                vim.lsp.inlay_hint.enable(false, {bufnr = 0})
                vim.lsp.codelens.clear(nil, 0)
            end
        })
        vim.api.nvim_create_autocmd("InsertLeave", {
            desc = "enable inlay hint and codelens when InsertLeave",
            group = group,
            callback = function()
                vim.lsp.inlay_hint.enable(true, {bufnr = 0})
                toggle_codelens(true)
            end
        })
        vim.api.nvim_create_autocmd("TextChanged", {
            desc = "enable codelens when TextChanged",
            group = group,
            callback = function()
                toggle_codelens(true)
            end
        })
        vim.api.nvim_create_autocmd("LspAttach", {
            desc = "enable when new buffer attached",
            group = group,
            callback = function()
                vim.lsp.inlay_hint.enable(true, {bufnr = 0})
                vim.lsp.codelens.refresh({bufnr = 0})
            end
        })
    end
end

function M.init()
    vim.keymap.set(
        "n",
        "<leader>lsp",
        function() toggle() end,
        {
            silent = true,
            noremap = true
        }
    )
end

return M
