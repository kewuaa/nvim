local settings = {}
settings.program_files_path = 'D:/Softwares/Program_Files/'

settings.rootmarks = {'.git', '.root'}
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

function settings:getpy(name)
    local py3_path = self.program_files_path .. 'Python/'
    return py3_path .. name .. '/Scripts/python.exe'
end

return settings

