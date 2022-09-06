local settings = {}
local program_files_path = 'D:/Softwares/Program_Files/'

settings.py3_path = program_files_path .. 'Python/'
settings.nvim_py3 = settings.py3_path .. 'nvim/Scripts/python.exe'
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

return settings

