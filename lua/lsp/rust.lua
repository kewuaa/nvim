local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
vim.list_extend(rootmarks, {
    "Cargo.toml", "rust-project.json"
})

M.rust_analyzer = {
    rootmarks = rootmarks,
    filetypes = {"rust"},
    cmd = {"rust-analyzer"},
}

return M
