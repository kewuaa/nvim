local settings = {}

settings.pyvenv_path = os.getenv('PYVENV')
function settings:getpy(name)
    local venv = string.format('%s/%s/Scripts/python.exe', self.pyvenv_path, name)
    if vim.fn.filereadable(venv) == 0 then
        vim.notify(string.format('python venv "%s" not found, "%s" not exist', name, venv))
    end
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
