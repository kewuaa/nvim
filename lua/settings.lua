local settings = {}
local program_files_path = 'D:/Softwares/Program_Files/'
setmetatable(settings, {
---@diagnostic disable-next-line: unused-local
    __index = function(table, key)
        if key == 'rootmarks' then
            return {
                '.git',
                '.root',
            }
        end
    end
})

settings.py3_path = program_files_path .. 'Python/'
settings.lua_path = program_files_path .. 'Lua/'
settings.c_path = program_files_path .. 'C/'
settings.zig_path = program_files_path .. 'Zig/'
settings.exclude_filetypes = {
    "qf",
    "help",
    "tutor",
    "netrw",
    "packer",
    "Outline",
    "NvimTree",
    "Trouble",
    "fugitive",
    "lspsagafinder",
    "lspsagaoutline",
    "startuptime",
    "TelescopePrompt",
    "toggleterm",
    "OverseerList",
    "overseerForm",
    "",
}
settings.run_file_config = {
    python = function(root, file)
        local venv = root .. '/.venv'
        local exe_path = venv .. '/Scripts/python.exe'
        if not (os.execute('cd ' .. venv) == 0) then
            exe_path = settings:getpy('global')
        end
        return {exe_path, file}
    end,
    zig = function(root, file)
        return {'zig', 'run', file}
    end,
    lua = function(root, file)
        return {'lua', file}
    end,
    javascript = function (root, file)
        return {'node', file}
    end,
}
setmetatable(settings.run_file_config, {
    __index = function (table, key)
        return function(root, file)
            local file_without_ext = string.gsub(file, '%.(%a*)', '')
            return {file_without_ext}
        end
    end
})

function settings:getpy(name)
    return self.py3_path .. name .. '/Scripts/python.exe'
end

return settings

