local clangd = {}
local settings = require("core.settings")
local gcc_path = vim.fn.fnamemodify(vim.fn.exepath('gcc'), ':p:h')
local rootmarks = settings.get_rootmarks()
---@diagnostic disable-next-line: missing-parameter
vim.list_extend(rootmarks, {
    'compile_commands.json',
    'compile_flags.txt',
    '.clangd',
    '.clang-tidy',
    '.clang-format',
})

clangd.rootmarks = rootmarks
clangd.filetypes = {
    "c",
    "cpp",
    "objc",
    "objcpp",
    "cuda",
    "proto",
}
clangd.cmd = {
    vim.fn.fnamemodify(gcc_path, ':h:h') .. '/clangd/bin/clangd.exe',
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

return clangd
