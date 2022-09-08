local M = {}
local hooks = {}

function M.add(func)
    hooks[#hooks + 1] = func
end

function M.trigger(client, bufnr)
    for _, func in pairs(hooks) do
        func(client, bufnr)
    end
end

return M

