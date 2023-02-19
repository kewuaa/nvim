local settings = {}

settings.pyenv_path = 'D:/Softwares/Program_Files/Python/envs'
function settings:getpy(name)
    return string.format('%s/%s/Scripts/python.exe', self.pyenv_path, name)
end
settings.tags_path = 'D:/Softwares/Program_Files/Tags'
settings.exclude_filetypes = {
    "qf",
    "lazy",
    "help",
    "tutor",
    "netrw",
    "Outline",
    "NvimTree",
    "Trouble",
    "fugitive",
    "lspsagafinder",
    "lspsagaoutline",
    "TelescopePrompt",
    "toggleterm",
    "notify",
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
