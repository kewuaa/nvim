local M = {}
local deps = require("core.deps")

local function load_clipboard()
    vim.api.nvim_del_var('loaded_clipboard_provider')
    vim.cmd(('source %s/autoload/provider/clipboard.vim'):format(vim.env.VIMRUNTIME))
end
local function load_rplugin()
    vim.api.nvim_del_var('loaded_remote_plugins')
    vim.cmd(('source %s/plugin/rplugin.vim'):format(vim.env.VIMRUNTIME))
end
local setup_filetype = function()
    vim.filetype.add({
        extension = {
            pyx = "cython",
            pxd = "cython",
            pxi = "cython",
            pyxdep = "python",
            pyxbld = "python",
        }
    })
end

M.init = function()
    deps.later(function()
        load_clipboard()
        load_rplugin()
        setup_filetype()
    end)
    require("plugins.ui")
    require("plugins.tools")
    require("plugins.editor")
    require("plugins.completion")
    require("plugins.treesitter")
end

return M
