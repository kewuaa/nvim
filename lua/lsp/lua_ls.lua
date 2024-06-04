local M = {}

local library = function()
    local ret = {}
    local version = vim.version().prerelease and "nightly" or "stable"
    local f = debug.getinfo(1, "S").source:sub(2)
    local types = vim.uv.fs_realpath(vim.fn.fnamemodify(f, ":h:h:h") .. "/types/" .. version)
    table.insert(ret, types)

    local function add(lib, filter)
        ---@diagnostic disable-next-line: param-type-mismatch
        for _, p in ipairs(vim.fn.expand(lib .. "/lua", false, true)) do
            local plugin_name = vim.fn.fnamemodify(p, ":h:t")
            p = vim.uv.fs_realpath(p)
            if p and (not filter or filter[plugin_name]) then
                table.insert(ret, p)
            end
        end
    end
    add("$VIMRUNTIME")
    add(vim.fn.stdpath("config"))
    -- local site = vim.fn.stdpath("data") .. "/site"
    -- add(site .. "/pack/*/opt/*")
    -- add(site .. "/pack/*/start/*")
    return ret
end

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
                library = library()
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
