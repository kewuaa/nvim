local settings = {}

settings.pyvenv_path = os.getenv('PYVENV')
function settings:getpy(name)
    local venv = string.format('%s/%s/Scripts/python.exe', self.pyvenv_path, name)
    assert(vim.fn.filereadable(venv) == 1)
    return venv
end
settings.exclude_filetypes = {
    "qf",
    "lazy",
    "help",
    "tutor",
    "netrw",
    "Outline",
    "NvimTree",
    "neo-tree",
    "neo-tree-pop",
    "Trouble",
    "fugitive",
    "sagafinder",
    "sagaoutline",
    "sagarename",
    "TelescopePrompt",
    "toggleterm",
    "notify",
    "mason",
    "dap-repl",
    "dap-float",
    "dapui_watches",
    "dapui_console",
    "dapui_stacks",
    "dapui_breakpoints",
    "dapui_scopes",
    "DiffviewFiles",
    "DiffviewFileHistory",
    "JABSwindow",
    "",
}
settings.get_rootmarks = function()
    return {
        '.git'
    }
end

return settings
