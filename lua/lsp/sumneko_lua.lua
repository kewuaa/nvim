local sumneko_lua = {}
local settings = require("settings")
local lua_path = settings.program_files_path .. 'Lua/'


sumneko_lua.path = lua_path .. 'sumneko_lua/bin/'
sumneko_lua.rootmarks = {}
for k, v in pairs(settings.rootmarks) do
    sumneko_lua.rootmarks[k] = v
end

function sumneko_lua.update_config(new_config, new_root)
    new_config.settings.sumneko_lua.diagnostics = {
        globals = { "vim", "packer_plugins" }
    }
    new_config.settings.sumneko_lua.workspace.library = {
        [new_root .. '/lua'] = true,
    }
end


local runtime_path = vim.split(package.path, ';')
runtime_path[#runtime_path + 1] = "lua/?.lua"
runtime_path[#runtime_path + 1] = "lua/?/init.lua"
sumneko_lua.settings = {
    Lua = {
        runtime = {
            version = 'LuaJIT',
            path = runtime_path,
        },
        diagnostics = {
            globals = {
                'vim',
                'packer_plugins',
            }
        },
        workspace = {
            library = {
                vim.fn.fnamemodify(vim.fn.expand('$MYVIMRC'), ':h'),
            },
            maxPreload = 100000,
            preloadFileSize = 10000,
        },
        telemetry = { enable = false },
    }
}

return sumneko_lua
