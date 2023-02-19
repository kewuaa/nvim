local python = require('lsp.python')
local ruff_lsp = vim.deepcopy(python.base_settings)

ruff_lsp.cmd = {'ruff-lsp.exe'}
ruff_lsp.on_attach = function() end
ruff_lsp.init_options = {
    args = {
        '--line-length=80',
        '--ignore=E402',
        '--exclude=.git,**/__pycache__,build,dist',
    }
}

return ruff_lsp
