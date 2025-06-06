local M = {}

M.lua_ls = {
    cmd = { "lua-language-server" },
    filetypes = { "lua" },
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
