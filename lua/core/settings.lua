local program_files_path = 'D:/Softwares/Program_Files/'


local settings = setmetatable({}, {
    __index = function(_, key)
        if key == 'rootmarks' then
            return {
                '.git',
            }
        end
        local lang = string.match(key, '(.+)_path')
        if lang then
            lang = lang:gsub("^%l", string.upper)
            return string.format("%s%s/", program_files_path, lang)
        end
    end
})

function settings:getpy(name)
    if name == 'envs' then
        return self.python_path .. 'envs'
    end
    return string.format('%senvs/%s/Scripts/python.exe', self.python_path, name)
end


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
settings.data_dir = string.format("%s/site/", vim.fn.stdpath("data"))
settings.vim_path = vim.fn.stdpath("config")


return settings
