local M = {}
local api, fn, log = vim.api, vim.fn, vim.log
local utils = require("core.utils")
local exe_suffix = utils.is_win and "Scripts/python.exe" or "bin/python"
local current_env = nil

M.venv_root = os.getenv("PYVENV") or ""
if M.venv_root == "" then
    vim.schedule(function()
        vim.notify("nil environment variable `PYVENV`, use the python in path instead", log.levels.WARN)
    end)
end

M.get_venv = function(name)
    vim.validate({
        name = {name, "string", false}
    })

    if M.venv_root then
        return "python"
    end
    local venv = ("%s/%s/%s"):format(M.venv_root, name, exe_suffix)
    if fn.executable(venv) == 0 then
        vim.notify(
            ('python venv "%s" not found, "%s" not exist, use the python in path instead'):format(name, venv),
            log.levels.WARN
        )
        return "python"
    end
    return venv
end

function M.parse_pyenv(root)
    vim.validate({
        root = {root, "string", false}
    })

    local venv = nil
    local name = nil
    local local_venv = ("%s/.venv/%s"):format(root, exe_suffix)
    if fn.executable(local_venv) == 1 then
        venv = local_venv
        name = fn.fnamemodify(root, ":t")
    else
        venv = nil
        local config_file = ('%s/pyproject.toml'):format(root)
        if fn.filereadable(config_file) == 1 then
            local lines = fn.readfile(config_file)
            local find = false
            for _, line in ipairs(lines) do
                if not find then
                    if string.match(line, '[tool.pyright]') then
                        find = true
                    end
                else
                    venv = string.match(line, 'venv%s*=%s*[\'\"](.*)[\'\"]')
                    if venv or string.match(line, '^[.*]') then
                        break
                    end
                end
            end
        end
        if venv then
            venv = M.get_venv(name)
        else
            local env = os.getenv("VIRTUAL_ENV")
            if env then
                venv = ("%s/%s"):format(env:gsub("\\", "/"), exe_suffix)
            else
                venv = M.get_venv("default")
            end
        end
        name = fn.fnamemodify(venv, ':h:h:t')
    end
    current_env = {
        name = name,
        path = venv,
    }
    api.nvim_exec_autocmds("User", {pattern = "PYVENVUPDATE", modeline = false})
    return venv
end

function M.get_current_env()
    return current_env
end

return M
