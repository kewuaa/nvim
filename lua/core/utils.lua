local M = {}
local fn = vim.fn


M.get_cwd = function ()
    local activate_clients = vim.lsp.buf_get_clients()
    local num = #activate_clients
    local root = nil
    if num > 0 then
        root = activate_clients[num].config.root_dir
    end
    if not root then
        root = fn.getcwd()
    end
    return root
end


return M
