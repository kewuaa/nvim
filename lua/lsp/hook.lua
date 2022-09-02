local M = {}
local hooks = {}

function M.add(func)
    table.insert(hooks, func)
end

function M.trigger(client, bufnr)
    for _, func in pairs(hooks) do
        func(client, bufnr)
    end
end

return M

