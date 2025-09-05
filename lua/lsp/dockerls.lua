local M = {
    disabled = not require("utils").has("docker")
            or not require("utils").has("npm")
}

M.dockerls = {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' },
    root_markers = { 'Dockerfile' },
}

return M
