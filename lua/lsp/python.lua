local M = {}
local root_markers = {
    'ty.toml',
    'pyproject.toml',
    'setup.py',
    'setup.cfg',
    'requirements.txt',
    '.git'
}

M.ty = {
  cmd = { 'ty', 'server' },
  filetypes = { 'python' },
  root_markers = root_markers,
}

M.ruff = {
    cmd = { 'ruff', 'server' },
    filetypes = { 'python' },
    root_markers = root_markers,
    on_attach = function(client, _)
        client.server_capabilities.hoverProvider = false
    end,
    init_options = {
        settings = {
            lineLength = 88
        }
    },
}

return M
