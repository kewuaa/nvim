local M = {}

---delete all buffers except the current one
---@param force boolean if force to delete the buffer that had been modified
M.bufonly = function(force)
    local cur_buf = vim.api.nvim_get_current_buf()

    local deleted, modified = 0, 0

    local buffers = vim.api.nvim_list_bufs()
    for _, bufnr in ipairs(buffers) do
        -- iter is not equal to current buffer
        local bufname = vim.api.nvim_buf_get_name(bufnr)
        if bufname ~= "" and vim.api.nvim_buf_is_loaded(bufnr) and bufnr ~= cur_buf then
            if vim.bo[bufnr].modified then
                if force then
                    vim.api.nvim_buf_delete(bufnr, {force = true})
                    modified = modified + 1
                else
                    vim.notify(("BufOnly: buffer `%s` is modified, skipped"):format(bufname))
                end
            elseif vim.bo[bufnr].modifiable then
                vim.api.nvim_buf_delete(bufnr, {})
                deleted = deleted + 1
            end
        end
    end

    local msg = "BufOnly: delete " .. deleted .. " buffer(s)"
    if modified > 0 then
        msg = msg .. ", " .. modified .. " modified buffer(s)"
    end
    vim.notify(msg)
end

return M
