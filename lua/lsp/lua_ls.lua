local M = {}
local runtime_path = vim.fn.split(package.path, ";")
vim.list_extend(runtime_path, {"?.lua", "?/init.lua"})

M.lua_ls = {
    settings = {
        Lua = {
            runtime = {
                version = "LuaJIT",
                path = { "?.lua", "?/init.lua" },
                pathStrict = true
            },
            completion ={
                keywordSnippet = "Disable"
            },
            workspace = {
                library = {
                    vim.fn.expand("$VIMRUNTIME/lua"),
                    vim.fn.stdpath("config") .. "/lua"
                }
            },
            diagnostics = {
                globals = {
                    'vim',
                }
            },
            hint = {
                enable = true
            },
            codeLens = {
                enable = true
            }
        }
    }
}

return M
