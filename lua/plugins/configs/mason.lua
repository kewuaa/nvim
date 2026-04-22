local utils = require("utils")
local mason_utils = require("utils.mason")

utils.on_command({ "Mason" }, function()
    vim.cmd.packadd("mason.nvim")

    require("mason").setup({
        PATH = "skip",
        max_concurrent_installers = 4,
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
    })

    for _, config in ipairs(vim.lsp.get_configs({})) do
        mason_utils.ensure_install(config.name)
    end
end)
