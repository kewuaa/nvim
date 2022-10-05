---@diagnostic disable: unused-local
local settings = {}
local program_files_path = 'D:/Softwares/Program_Files/'
setmetatable(settings, {
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
    "notify",
    "DressingSelect",
    "",
}


function settings:getpy(name)
    return self.py3_path .. name .. '/Scripts/python.exe'
end

return settings
