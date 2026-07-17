local M = {
    disabled = not require("utils").has("docker", "npm")
}

M["dockerfile-language-server"] = {
    cmd = { 'docker-langserver', '--stdio' },
    filetypes = { 'dockerfile' },
    root_markers = { 'Dockerfile' },
}

return M
