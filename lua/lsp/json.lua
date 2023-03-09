local M = {}

M.jsonls = {
    filetypes = {'json', 'jsonc'},
    cmd = {'vscode-json-language-server.cmd', '--stdio'},
    init_options = {
        provideFormatter = true
    }
}

return M
