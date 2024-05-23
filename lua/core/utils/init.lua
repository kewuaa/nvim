local M = {}
local fn = vim.fn

M.get_cwd = function ()
    local activate_clients = vim.lsp.get_clients({
        bufnr = 0
    })
    local num = #activate_clients
    local root = nil
    if num > 0 then
        root = activate_clients[num].config.root_dir
    end
    if not root then
        local startpath = fn.expand('%:p:h')
        root = vim.fs.root(startpath, ".git") or vim.fn.expand("%:p:h")
    end
    return root
end

M.get_bufsize = function(bufnr)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats then
        return stats.size / 1024
    end
    return 0
end

M.init = function()
    require('core.utils.bigfile').init()
    require('core.utils.im').init()
end

return M
