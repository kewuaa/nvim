local M = {}
local lua_path = vim.fn.fnamemodify(vim.fn.exepath('lua'), ':p:h')

M.lua_ls = {
    filetypes = {'lua'},
    cmd = {vim.fn.fnamemodify(lua_path, ':h:h') .. '/lua-language-server/bin/lua-language-server.exe'},
    settings = {
        Lua = {
            runtime = {
                version = 'LuaJIT',
            },
            diagnostics = {
                globals = {
                    'vim',
                }
            },
            workspace = {
                maxPreload = 100000,
                preloadFileSize = 10000,
            },
            telemetry = { enable = false },
            -- Do not override treesitter lua highlighting with sumneko lua highlighting
            semantic = { enable = false },
        }
    }
}

return M
