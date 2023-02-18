local python = require('lsp.python')
local jdls = vim.deepcopy(python.base_settings)

jdls.cmd = {'jedi-language-server.exe'}
jdls.init_options = {
    diagnostics = {
        enable = false,
    },
    jediSettings = {
        autoImportModules = {
            'numpy',
            'pandas',
            -- 'torch',
        }
    },
    workspace = {
        -- extraPaths = {},
        environmentPath = python.parse_pyenv(),
        symbols = {
            ignoreFolders = {
                '.git',
                '__pycache__',
                '.venv',
            }
        }
    }
}

return jdls
