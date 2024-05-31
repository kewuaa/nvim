local M = {}

M.exclude_filetypes = {
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
}

M.exclude_buftypes = {
    "terminal",
    "nofile"
}

return M
