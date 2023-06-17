local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()

M.yamlls = {
    rootmarks = rootmarks,
    filetypes = {"yaml", "yaml.docker-compose"},
    cmd = {"yaml-language-server", "--stdio"}
}

return M
