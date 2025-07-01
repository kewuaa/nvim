local M = {
    disabled = not require("utils").has("docker")
}

M.dockerls = {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' },
    root_markers = { 'Dockerfile' },
}

return M
