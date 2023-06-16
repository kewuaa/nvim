local M = {}
local settings = require("core.settings")
local gcc_path = vim.fn.fnamemodify(vim.fn.exepath('gcc'), ':p:h')
---@diagnostic disable-next-line: missing-parameter

M.clangd = {
    ---@diagnostic disable-next-line: missing-parameter
    rootmarks = vim.list_extend(
        settings.get_rootmarks(),
        {
            '.xmake.lua',
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
        'clangd',
        "--background-index",
        "--pch-storage=memory",
        -- You MUST set this arg ↓ to your c/cpp compiler location (if not included)!
        "--query-driver=" .. string.format('%s/%s,%s/%s', gcc_path, 'gcc', gcc_path, 'g++'),
        "--clang-tidy",
        "--all-scopes-completion",
        "--completion-style=detailed",
        "--header-insertion=never",
        "--fallback-style=google",
    }
}
-- M.cmake = {
--     ---@diagnostic disable-next-line: missing-parameter
--     rootmarks = vim.list_extend(settings.get_rootmarks(), {'cmake', 'build'}),
--     filetypes = {'cmake'},
--     cmd = {'cmake-language-server.exe'},
--     init_options = {
--         buildDirectory = 'build'
--     }
-- }

return M
