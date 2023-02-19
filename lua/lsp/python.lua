local M = {}
local settings = require('core.settings')
local utils = require('core.utils')
local read_toml = utils.read_toml
---@diagnostic disable-next-line: missing-parameter
local rootmarks = vim.list_extend(settings.get_rootmarks(), {'pyproject.toml'})
local find_root = utils.find_root(rootmarks)
local filetypes = {'python'}

M.base_settings = {
    rootmarks = rootmarks,
    filetypes = filetypes
}
M.parse_pyenv = function(root)
    if not root then
        local startpath = vim.fn.expand('%:p:h')
        root = find_root(startpath)
    end
    local venv = 'default'
    local environ = vim.g.asynctasks_environ
    local config_file = root .. '/pyproject.toml'
    if vim.fn.filereadable(config_file) == 1 then
        local config = read_toml(config_file)
        if config and config.tool then
            venv = config.tool.jedi and config.tool.jedi.venv or venv
        else
            vim.notify('could not parse python env from ' .. config_file)
        end
    end
    venv = settings:getpy(venv)
    environ.pyenv = venv
    vim.g.asynctasks_environ = environ
    return venv
end

return M
