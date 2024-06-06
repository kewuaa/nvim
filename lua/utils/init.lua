local M = {}
local api, fn = vim.api, vim.fn
local os_name = vim.loop.os_uname().sysname

M.is_linux = os_name == "Linux"
M.is_mac = os_name == "Darwin"
M.is_win = os_name == "Windows_NT"
M.is_wsl = vim.fn.has("wsl") == 1

---@return string root get root_dir of lsp if lsp attached else get cwd
M.get_cwd = function()
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

---@param bufnr number
---@return integer|nil size in MiB if buffer is valid, nil otherwise
M.cal_bufsize = function(bufnr)
    local ok, stats = pcall(
        vim.loop.fs_stat,
        api.nvim_buf_get_name(bufnr)
    )
    if ok and stats then
        return stats.size / (1024 * 1024)
    end
    return 0
end

return M
