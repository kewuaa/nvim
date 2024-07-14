local M = {}
local utils = require("utils")
local exe_suffix = utils.is_win and "Scripts/python.exe" or "bin/python"

---@class PyVenv
---@field name string python venv name
---@field path string python venv path

---@type PyVenv|nil current python venv
local current_env = nil

M.venv_root = os.getenv("PYVENV") or ""
if M.venv_root == "" then
    vim.schedule(function()
        vim.notify("nil environment variable `PYVENV`, use the python in path instead", vim.log.levels.WARN)
    end)
elseif utils.is_win then
    M.venv_root = M.venv_root:gsub("\\", "/")
end

M.get_venv = function(name)
    vim.validate({
        name = {name, "string", false}
    })

    if not M.venv_root then
        return "python"
    end
    local venv = ("%s/%s/%s"):format(M.venv_root, name, exe_suffix)
    if vim.fn.executable(venv) == 0 then
        vim.notify(
            ('python venv "%s" not found, "%s" not exist, use the python in path instead'):format(name, venv),
            vim.log.levels.WARN
        )
        return "python"
    end
    return venv
end

---@param root string root path
---@return string python venv path
function M.parse_pyenv(root)
    vim.validate({
        root = {root, "string", false}
    })

    local venv = nil
    local name = nil
    local local_venv = ("%s/.venv/%s"):format(root, exe_suffix)
    if vim.fn.executable(local_venv) == 1 then
        venv = local_venv
        name = vim.fn.fnamemodify(root, ":t")
    else
        venv = nil
        local config_file = ('%s/pyproject.toml'):format(root)
        if vim.fn.filereadable(config_file) == 1 then
            local lines = vim.fn.readfile(config_file)
            local find = false
            for _, line in ipairs(lines) do
                if not find then
                    if string.match(line, '[tool.basedpyright]') then
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
            venv = M.get_venv(venv)
        else
            local env = os.getenv("VIRTUAL_ENV")
            if env then
                venv = ("%s/%s"):format(env:gsub("\\", "/"), exe_suffix)
            else
                venv = M.get_venv("default")
            end
        end
        name = vim.fn.fnamemodify(venv, ':h:h:t')
    end
    current_env = {
        name = name,
        path = venv,
    }
    vim.api.nvim_exec_autocmds("User", {pattern = "PYVENVUPDATE", modeline = false})
    return venv
end

function M.get_current_env()
    return current_env
end

return M
