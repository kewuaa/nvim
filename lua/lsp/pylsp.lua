local pylsp = {}
local settings = require('settings')
local py3_path = settings.program_files_path .. 'Python/'


pylsp.default_env = py3_path .. 'global'
pylsp.path = py3_path .. 'pylsp/Scripts/'
pylsp.rootmarks = {}
for k, v in pairs(settings.rootmarks) do
    pylsp.rootmarks[k] = v
end
pylsp.rootmarks[#pylsp.rootmarks + 1] = '.venv'


function pylsp.update_config(new_config, new_root)
    local new_env = new_root .. '/.venv'
    if not (os.execute('cd ' .. new_env) == 0) then
        new_env = pylsp.default_env
    end
    new_config.settings.pylsp.plugins.jedi.environment = new_env
    new_config.settings.pylsp.plugins.jedi.extra_paths = {new_root}
    return new_config
end


pylsp.settings = {
    pylsp = {
        configurationSources = {},
        plugins = {
            pyflakes = {enabled = false},
            pycodestyle = {enabled = false},
            mccabe = {enabled = false},
            autopep8 = {enabled = false},
            yapf = {enabled = false},
            preload = {enabled = false},
            flake8 = {
                enabled = true,
                executable = pylsp.path .. 'flake8.exe',
                exclude = {'.git', '**/__pycache__', '.venv'},
                ignore = {'E402'},
                indentSize = 4,
            },
            jedi = {},
            jedi_completion = {
                cache_for = {'numpy', 'torch'},
                include_params = true,
                fuzzy = true,
            },
        },
    },

}

return pylsp

