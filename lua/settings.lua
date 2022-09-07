local settings = {}
local program_files_path = 'D:/Softwares/Program_Files/'

settings.py3_path = program_files_path .. 'Python/'
settings.rootmarks = {'.git', '.venv'}
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
    "",
}

function settings.getpy(name)
    return settings.py3_path .. name .. '/Scripts/python.exe'
end

return settings

