local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
vim.list_extend(rootmarks, {
    'xmake.lua', '*.lpi'
})

-- environment variables
-- PP — Path to the FPC compiler executable
-- FPCDIR — Path of the source code of the FPC standard library
-- LAZARUSDIR — Path of your Lazarus installation
-- FPCTARGET — Target OS (e.g. Linux, Darwin, ...)
-- FPCTARGETCPU — Target architecture (e.g. x86_64, AARCH64, ...)
M.pasls = {
    rootmarks = rootmarks,
    init_options = {
        fpcOptions = {
            "-Fu$(root)/unit",
        },
        -- procedure completions with parameters are inserted as snippets
        insertCompletionsAsSnippets = true,
        -- procedure completions with parameters (non-snippet) insert
        -- empty brackets (and insert as snippet)
        insertCompletionProcedureBrackets = true,
        -- workspaces folders will be added to unit paths (i.e. -Fu)
        includeWorkspaceFoldersAsUnitPaths = true,
        -- workspaces folders will be added to include paths (i.e. -Fi)
        includeWorkspaceFoldersAsIncludePaths = true,
        -- syntax will be checked when file opens or saves
        checkSyntax = true,
        -- syntax errors will be published as diagnostics
        publishDiagnostics = true,
        -- enable workspace symbols
        workspaceSymbols = true,
        -- enable document symbols
        documentSymbols = true,
        -- completions contain a minimal amount of extra information
        minimalisticCompletions = true,
        -- syntax errors as shown in the UI with ‘window/showMessage’
        showSyntaxErrors = true,
    }
}

return M
