local M = {}

M.ensure_install = function(pkg_name)
    local registry = require("mason-registry")
    if not registry.is_installed(pkg_name) then
        local ok, pkg = pcall(registry.get_package, pkg_name)
        if ok then
            vim.notify(("installing %s"):format(pkg_name))
            return pkg:install({ version = nil }):once(
                "closed",
                vim.schedule_wrap(function()
                    if pkg:is_installed() then
                        vim.notify(("%s was successfully installed"):format(pkg_name))
                    else
                        vim.notify(
                            ("failed to install %s. Installation logs are available in :Mason and :MasonLog"):format(pkg_name),
                            vim.log.levels.ERROR
                        )
                    end
                end)
            )
        end
    end
end

return M
