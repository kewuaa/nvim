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

local function switch_source_header_splitcmd(bufnr, splitcmd)
    local nvim_lsp = require("lspconfig")
    bufnr = nvim_lsp.util.validate_bufnr(bufnr)
    local clangd_client = nvim_lsp.util.get_active_client_by_name(bufnr, "clangd")
    local params = { uri = vim.uri_from_bufnr(bufnr) }
    if clangd_client then
        clangd_client.request("textDocument/switchSourceHeader", params, function(err, result)
        if err then
                error(tostring(err))
            end
            if not result then
                vim.notify("Corresponding file can’t be determined", vim.log.levels.ERROR, { title = "LSP Error!" })
                return
            end
            vim.api.nvim_command(splitcmd .. " " .. vim.uri_to_fname(result))
        end)
    else
        vim.notify(
            "Method textDocument/switchSourceHeader is not supported by any active server on this buffer",
            vim.log.levels.ERROR,
            { title = "LSP Error!" }
        )
    end
end

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
clangd.commands = {
    ClangdSwitchSourceHeader = {
        function()
            switch_source_header_splitcmd(0, "edit")
        end,
        description = "Open source/header in current buffer",
    },
    ClangdSwitchSourceHeaderVSplit = {
        function()
            switch_source_header_splitcmd(0, "vsplit")
        end,
        description = "Open source/header in a new vsplit",
    },
    ClangdSwitchSourceHeaderSplit = {
        function()
            switch_source_header_splitcmd(0, "split")
        end,
        description = "Open source/header in a new split",
    },
}

return clangd
