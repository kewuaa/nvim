local plugins = {}
local plugins_dir = vim.fn.stdpath('config') .. '/lua/plugins'

for _, plugin in ipairs(
    vim.fn.globpath(plugins_dir, '*/init.lua', false, 1)
) do
    plugin = string.match(plugin, '[/\\]([^/\\]-)[/\\]init.lua')
    vim.list_extend(
        plugins,
        require(string.format('plugins.%s', plugin))
    )
end

return plugins
