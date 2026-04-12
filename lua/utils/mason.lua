local M = {}

---ensure that the package if installed
---@param name string name of lsp server
---@param callbacks table|nil callbacks that will be called after installing
M.ensure_install = function(name, callbacks)
    vim.validate({
        arg1 = {name, "string", false},
        arg2 = {callbacks, "table", true},
    })
    local registry = require("mason-registry")
    if not registry.is_installed(name) then
        local ok, pkg = pcall(registry.get_package, name)
        if ok then
            vim.notify(("installing %s"):format(name))
            return pkg:install({ version = nil }):once(
                "closed",
                vim.schedule_wrap(function()
                    if pkg:is_installed() then
                        vim.notify(("%s was successfully installed"):format(name))
                        if callbacks and callbacks.success and type(callbacks.success) == "function" then
                            callbacks.success()
                        end
                    else
                        vim.notify(
                            ("failed to install %s. Installation logs are available in :Mason and :MasonLog"):format(name),
                            vim.log.levels.ERROR
                        )
                        if callbacks and callbacks.failed and type(callbacks.failed) == "function" then
                            callbacks.failed()
                        end
                    end
                end)
            )
        end
    end
end

return M
