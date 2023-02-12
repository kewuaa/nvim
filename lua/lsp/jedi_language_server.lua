local jdls = {}
local settings = require("core.settings")
local rootmarks = settings.rootmarks
local config_file_name = '.pyproject'
rootmarks[#rootmarks+1] = config_file_name


local find_env = function(start_path)
    local fnm = vim.fn.fnamemodify
    local cwd = fnm(start_path, ':p')
    local r = string.match(cwd, '^%a:[/\\]')
    local venv = 'default'
    local environ = vim.g.asynctasks_environ
    while true do
        local config_file = string.format('%s/%s', cwd, config_file_name)
        if vim.fn.filereadable(config_file) == 1 then
            for line in io.lines(config_file) do
                local items = vim.fn.split(line, '=', 1)
                if items[1] == 'venv' then
                    venv = items[2]
                end
            end
            break
        end
        if cwd == r then
            break
        end
        cwd = fnm(cwd, ':h')
    end
    venv = settings:getpy(venv)
    environ.pyenv = venv
    vim.g.asynctasks_environ = environ
    return venv
end

jdls.rootmarks = rootmarks
jdls.filetypes = {'python'}
jdls.cmd = {
    vim.fn.fnamemodify(settings:getpy('default'), ':h') .. '/jedi-language-server.exe'
}
jdls.init_options = {
    diagnostics = {
        enable = false,
    },
    jediSettings = {
        autoImportModules = { 'numpy', 'pandas', 'torch' }
    },
    workspace = {
        -- extraPaths = {},
        environmentPath = find_env(vim.fn.getcwd()),
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
