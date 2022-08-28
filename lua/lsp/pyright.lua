local pyright = {}
local settings = require("settings")


pyright.default_venv_path = settings.py3_path
pyright.default_venv = 'global'
pyright.path = settings.py3_path .. 'pyright/Scripts/'
pyright.rootmarks = settings.py3_rootmarks


function pyright.update_config(new_config, new_root)
    local new_venv = '.venv'
    local new_venv_path = new_root
    if not os.execute('cd ' .. new_root .. '/.venv') == 0 then
        new_venv = pyright.default_venv
        new_venv_path = pyright.default_venv_path
        new_root = vim.api.nvim_eval('fnamemodify(bufname("%"), ":p:h")')
    end
    new_config.settings.python.venvPath = new_venv_path
    new_config.settings.python.venv = new_venv
    new_config.settings.python.extraPaths = {new_root}
    new_config.settings.python.root = new_root
    return new_config
end

pyright.settings = {
    python = {
        exclude = {'.git', '**/__pycache__/', '.venv/'},
        defineConstant = {
            DEBUG = true,
        },
        reportMissingImports = true,
        reportMissingTypeStubs = false,
        pythonVersion = '3.8',
        pythonPlatform = 'Windows',
    }
}

return pyright

