local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks("build.zig")

M.zls = {
    rootmarks = rootmarks,
}

return M
