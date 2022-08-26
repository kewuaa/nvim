local M = {}
local hooks = {}

function M.add(func)
    table.insert(hooks, func)
end

function M.trigger(client, bufnr)
    for i = 1, #hooks do
        hooks[i](client, bufnr)
    end
end

return M

