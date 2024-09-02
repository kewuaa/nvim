local M = {}
local utils = require("utils")
local mason = require("utils.mason")
local rootmarks = {".git", "pyproject.toml"}
local mypy = {
    prefix = "mypy",
    lintSource = "mypy",
    lintStdin = false,
    lintOnSave = true,
    lintAfterOpen = true,
    lintIgnoreExitCode = true,
    lintCommand = vim.fn.join({
        "mypy",
        "--no-pretty",
        "--show-column-numbers",
        "--no-error-summary",
        "--no-color-output",
        "--exclude '/build.*/$'",
        "--exclude '/dist/$'",
        "--python-executable", utils.get_py(),
    }, " "),
    lintFormats = {
        '%f:%l:%c: %trror: %m',
        '%f:%l:%c: %tarning: %m',
        '%f:%l:%c: %tote: %m',
    },
    rootMarkers = rootmarks
}
local languages = {
    python = {
        mypy
    }
}
mason.ensure_install("mypy")

M.efm = {
    rootmarks = rootmarks,
    filetypes = vim.tbl_keys(languages),
    single_file_support = false,
    init_options = {
        documentFormatting = true,
        documentRangeFormatting = true,
        hover = false,
        documentSymbol = true,
        codeAction = true,
        completion = false
    },
    settings = {
        rootMarkers = rootmarks,
        languages = languages,
    }
}

return M
