local M = {}
local fn = vim.fn

M.find_root_by = function(rootmarks)
    local fnm = fn.fnamemodify
    local globpath = fn.globpath
    local match = string.match
    return function(startpath)
        startpath = fnm(startpath, ':p')
        local root = startpath
        while true do
            local if_find = false
            for _, mark in ipairs(rootmarks) do
                ---@diagnostic disable-next-line: param-type-mismatch
                local match_path = globpath(startpath, mark, true, true)
                if #match_path > 0 then
                    root = startpath
                    if_find = true
                    break
                end
            end
            if if_find or match(startpath, '%a:[/\\]$') then
                break
            else
                startpath = fnm(startpath, ':h')
            end
        end
        return root
    end
end

local find_root = M.find_root_by(require('core.settings').get_rootmarks())
M.get_cwd = function ()
    local activate_clients = vim.lsp.get_active_clients({
        bufnr = 0
    })
    local num = #activate_clients
    local root = nil
    if num > 0 then
        root = activate_clients[num].config.root_dir
    end
    if not root then
        local startpath = fn.expand('%:p:h')
        root = find_root(startpath)
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
    require('core.utils.python').init()
    require('core.utils.im').init()
end

return M
