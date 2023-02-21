local jsonls = {}

jsonls.filetypes = {'json', 'jsonc'}
jsonls.cmd = {"vscode-json-language-server.cmd", "--stdio"}
jsonls.init_options = {
    provideFormatter = true
}

return jsonls
