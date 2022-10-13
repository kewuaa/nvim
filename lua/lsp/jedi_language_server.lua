local jdls = {}
local settings = require("settings")
local default_env = settings.python_path .. 'global'
local path = settings.python_path .. 'jdls/Scripts/'
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = '.venv'


local find_env = function(start_path)
    local fnm = vim.fn.fnamemodify
    local cwd = fnm(start_path, ':p')
    local r = string.match(cwd, '^%a:[/\\]')
    local venv = nil
    while true do
        venv = cwd .. '/.venv'
        if os.execute('cd ' .. venv) == 0 then
            break
        end
        if cwd == r then
            venv = default_env
            break
        end
        cwd = fnm(cwd, ':h')
    end
    return venv .. '/Lib/site-packages'
end


jdls.rootmarks = rootmarks
jdls.filetypes = {'python'}
jdls.cmd = {path .. 'jedi-language-server.exe'}
jdls.init_options = {
    workspace = {
        extraPaths = {find_env(vim.fn.getcwd())},
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
