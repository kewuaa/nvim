local M = {}

-- M.cmake = {
--     cmd = {"cmake-language-server"}
-- }
M.neocmake = {
    cmd = {"neocmakelsp", "--stdio"}
}

return M
