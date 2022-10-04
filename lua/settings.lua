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


local run_file_config = {
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
setmetatable(run_file_config, {
    __index = function (table, key)
        return function(root, file)
            local file_without_ext = string.gsub(file, '%.(%a*)', '')
            return {file_without_ext}
        end
    end
})
local components = {
    {
        "on_output_quickfix",
        set_diagnostics = true,
        open = true,
    },
    {
        "on_complete_dispose",
        statuses = {"SUCCESS"},
    },
    {
        "on_result_diagnostics",
        remove_on_restart = true,
    },
    "default",
}
settings.templates = {
    {
        name = 'run file',
        builder = function(params)
            local ft = vim.bo.filetype
            local file = vim.fn.expand('%:p')
            local root = require('plugins').get_cwd()
            vim.cmd [[wa]]
            local cmd = run_file_config[ft](root, file)
            return {
                cmd = cmd,
                name = 'run ' .. ft,
                components = components,
                cwd = root,
            }
        end,
        desc = "run the current file",
    },
    {
        name = 'build c/c++',
        builder = function (params)
            local file = vim.fn.expand('%:p')
            local file_without_ext = string.gsub(file, '%.(%a*)', '')
            vim.cmd [[wa]]
            return {
                cmd = {'clang', '-O2', '-Wall', file, '-o', file_without_ext},
                name = 'build ' .. vim.bo.filetype,
                components = components,
                cwd = require("plugins").get_cwd(),
            }
        end,
        desc = 'build c/c++ file',
        condition = {
            filetype = {
                'c', 'cpp'
            }
        }
    },
    {
        name = 'build zig',
        builder = function (params)
            local file = vim.fn.expand("%:p")
            vim.cmd [[wa]]
            return {
                cmd = {'zig', 'build-exe', file},
                name = 'build zig',
                components = components,
                cwd = require("plugins").get_cwd(),
            }
        end,
        desc = 'build zig file',
        condition = {
            filetype = {'zig'},
        }
    },
    {
        name = 'test zig',
        builder = function (params)
            local file = vim.fn.expand("%:p")
            vim.cmd [[wa]]
            return {
                cmd = {'zig', 'test', file},
                name = 'test zig',
                components = components,
                cwd = require("plugins").get_cwd(),
            }
        end,
        desc = 'test zig file',
        condition = {
            filetype = {'zig'},
        }
    },
}

function settings:getpy(name)
    return self.py3_path .. name .. '/Scripts/python.exe'
end

return settings

