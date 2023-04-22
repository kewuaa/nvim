local M = {}

M.jsonls = {
    filetypes = {'json', 'jsonc'},
    cmd = {'vscode-json-language-server', '--stdio'},
    init_options = {
        provideFormatter = true
    }
}

return M
