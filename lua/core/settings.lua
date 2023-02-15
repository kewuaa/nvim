local program_files_path = 'D:/Softwares/Program_Files/'
local pyversion = '39'
local settings = setmetatable(
    {
        exclude_filetypes = {
            "qf",
            "lazy",
            "help",
            "tutor",
            "netrw",
            "Outline",
            "NvimTree",
            "Trouble",
            "fugitive",
            "lspsagafinder",
            "lspsagaoutline",
            "TelescopePrompt",
            "toggleterm",
            "notify",
            "dap-repl",
            "dap-float",
            "dapui_watches",
            "dapui_console",
            "dapui_stacks",
            "dapui_breakpoints",
            "dapui_scopes",
           "DiffviewFiles",
            "",
        },
    },
    {
        __index = function(table, key)
            if key == 'rootmarks' then
                return {
                    '.git',
                }
            end
            local lang = string.match(key, '(.+)_path')
            if lang then
                lang = lang:gsub("^%l", string.upper)
                local path = string.format("%s%s/", program_files_path, lang)
                table[key] = path
                return path
            end
        end
    }
)

function settings:getpy(name)
    if name == 'envs' then
        return self.python_path .. 'envs/'
    elseif name == 'root' then
        return self.python_path .. string.format('python%s/python.exe', pyversion)
    end
    return string.format('%senvs/%s/Scripts/python.exe', self.python_path, name)
end

return settings
