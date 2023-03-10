local M = {}
local settings = require("core.settings")
local gcc_path = vim.fn.fnamemodify(vim.fn.exepath('gcc'), ':p:h')
---@diagnostic disable-next-line: missing-parameter

M.clangd = {
    ---@diagnostic disable-next-line: missing-parameter
    rootmarks = vim.list_extend(
        settings.get_rootmarks(),
        {
            'compile_commands.json',
            'compile_flags.txt',
            '.clangd',
            '.clang-tidy',
            '.clang-format',
        }
    ),
    filetypes = {
        "c",
        "cpp",
        "objc",
        "objcpp",
        "cuda",
        "proto",
    },
    cmd = {
        'clangd.exe',
        "--background-index",
        "--pch-storage=memory",
        -- You MUST set this arg ↓ to your c/cpp compiler location (if not included)!
        "--query-driver=" .. string.format('%s/%s,%s/%s', gcc_path, 'gcc', gcc_path, 'g++'),
        "--clang-tidy",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion-decorators",
        "--header-insertion=iwyu",
    }
}
M.cmake = {
    ---@diagnostic disable-next-line: missing-parameter
    rootmarks = vim.list_extend(settings.get_rootmarks(), {'cmake', 'build'}),
    filetypes = {'cmake'},
    cmd = {'cmake-language-server.exe'},
    init_options = {
        buildDirectory = 'build'
    }
}

return M
