local os_name = vim.loop.os_uname().sysname
local settings = {
    pyvenv_path = os.getenv('PYVENV'),
    is_mac = os_name == "Darwin",
    is_Linux = os_name == "Linux",
    is_Windows = os_name == "Windows_NT",
    is_wsl = vim.fn.has("wsl") == 1,

    get_rootmarks = function()
        return {
            '.git'
        }
    end
}

function settings:getpy(name)
    local venv = string.format(
        (self.is_Linux or self.is_wsl) and "%s/%s/bin/python" or "%s/%s/Scripts/python.exe",
        self.pyvenv_path,
        name
    )
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

return settings
