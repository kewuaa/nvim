local M = {}
local state = false
local group = "_lsp_utils_"
local lazy_refresh_buffers = {}

---toggle inlay hint
---@param enable boolean
local toggle_inlay_hint = function(enable)
    local client = vim.lsp.get_clients({bufnr = 0, method = "textDocument/inlayHint"})[1]
    if client == nil then
        vim.notify("no clients support textDocument/inlayHint", vim.log.levels.WARN)
        return
    end
    local buffers = vim.lsp.get_buffers_by_client_id(client.id)
    for _, bufnr in pairs(buffers) do
        vim.lsp.inlay_hint.enable(enable, {bufnr = bufnr})
    end
end

---toggle codelens
---@param enable boolean
local toggle_codelens = function(enable)
    local client = vim.lsp.get_clients({bufnr = 0, method = "textDocument/codeLens"})[1]
    if client == nil then
        vim.notify("no clients support textDocument/codeLens", vim.log.levels.WARN)
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
                if vim.tbl_contains(visible_bufs, bufnr) then
                    vim.lsp.codelens.refresh({bufnr = bufnr})
                else
                    if not vim.tbl_contains(lazy_refresh_buffers, bufnr) then
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

---toggle inlay hint and codelens
---and register autocmd to disable them in insert mode and enable them in normal mode
M.toggle = function()
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

return M
