local pylsp = {}
local settings = require('settings')
local default_env = settings.py3_path .. 'global'
local path = settings.py3_path .. 'pylsp/Scripts/'
local rootmarks = settings.rootmarks
rootmarks[#rootmarks + 1] = '.venv'


pylsp.rootmarks = rootmarks
pylsp.filetypes = {'python'}
pylsp.cmd = {path .. 'pylsp.exe'}
pylsp.settings = {
    pylsp = {
        configurationSources = {},
        plugins = {
            pyflakes = {enabled = false},
            pycodestyle = {enabled = false},
            autopep8 = {enabled = false},
            yapf = {enabled = false},
            flake8 = {
                enabled = true,
                executable = path .. 'flake8.exe',
                exclude = {'.git', '**/__pycache__', '.venv'},
                ignore = {'E402'},
                indentSize = 4,
            },
            jedi = {},
            jedi_completion = {
                include_params = true,
                fuzzy = true,
            },
        },
    },

}
pylsp.on_new_config = function(new_config, new_root)
    local new_env = new_root .. '/.venv'
    if not (os.execute('cd ' .. new_env) == 0) then
        new_env = default_env
    end
    new_config.settings.pylsp.plugins.jedi.environment = new_env
    new_config.settings.pylsp.plugins.jedi.extra_paths = {new_root}
    return new_config
end


return pylsp
