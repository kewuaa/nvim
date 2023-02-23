local M = {}
local settings = require('core.settings')
local utils = require('core.utils')
local read_toml = utils.read_toml
---@diagnostic disable-next-line: missing-parameter
local rootmarks = vim.list_extend(settings.get_rootmarks(), {'pyproject.toml'})
local find_root = utils.find_root_by(rootmarks)
local parse_pyenv = require('core.utils.python').parse_pyenv
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
    return parse_pyenv(root)
end

return M
