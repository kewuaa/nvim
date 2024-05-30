local os_name = vim.loop.os_uname().sysname
local settings = {
    pyvenv_path = os.getenv('PYVENV'),
    is_mac = os_name == "Darwin",
    is_Linux = os_name == "Linux",
    is_Windows = os_name == "Windows_NT",
    is_wsl = vim.fn.has("wsl") == 1,

    get_rootmarks = function(...)
        local lst = {...}
        lst[#lst+1] = ".git"
        return lst
    end
}
if settings.pyvenv_path then
    if settings.is_Windows then
        settings.pyvenv_path = settings.pyvenv_path:gsub("\\", "/")
    end
else
    vim.notify("nil environment variable `PYVENV`, use the python in path instead")
end

function settings:getpy(name)
    if not settings.pyvenv_path then
        return "python"
    end
    local venv = ("%s/%s/%s/python"):format(
        self.pyvenv_path,
        name,
        self.is_Windows and "Scripts" or "bin"
    )
    if vim.fn.executable(venv) == 0 then
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
    "TelescopePrompt",
    "mininotify-history",
    "mason",
    "crates.nvim",
    "dap-repl",
    "dap-float",
    "dapui_watches",
    "dapui_console",
    "dapui_stacks",
    "dapui_breakpoints",
    "dapui_scopes",
    "DiffviewFiles",
    "DiffviewFileHistory",

    "terminal",
    "nofile"
}

return settings
