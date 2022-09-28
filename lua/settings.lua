local settings = {}
local program_files_path = 'D:/Softwares/Program_Files/'

settings.py3_path = program_files_path .. 'Python/'
settings.lua_path = program_files_path .. 'Lua/'
settings.c_path = program_files_path .. 'C/'
settings.rust_path = program_files_path .. 'Rust/'

settings.rootmarks = {
    '.git',
    '.root',
}
settings.exclude_filetypes = {
    "fugitive",
    "help",
    "tutor",
    "netrw",
    "packer",
    "Outline",
    "NvimTree",
    "Quickfix List",
    "Trouble",
    "lspsagafinder",
    "lspsagaoutline",
    "startuptime",
    "TelescopePrompt",
    "toggleterm",
    "",
}

function settings:getpy(name)
    return self.py3_path .. name .. '/Scripts/python.exe'
end

return settings

