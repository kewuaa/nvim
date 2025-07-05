local M = {}
local api = vim.api
local os_name = vim.uv.os_uname().sysname

M.is_linux = os_name == "Linux"
M.is_mac = os_name == "Darwin"
M.is_win = os_name == "Windows_NT"
M.is_wsl = vim.fn.has("wsl") == 1

M.has = function(...)
    for _, name in ipairs({ ... }) do
        if not vim.fn.executable(name) == 0 then
            return false
        end
    end
    return true
end

---wrap path with "" if path include space
---@param path string
---@return string wrapped path
M.wrap_path = function(path)
    vim.validate({
        path = {path, "string", false}
    })
    if path:find(" ") then
        path = '"'..path..'"'
    end
    return path
end

---@param bufnr number
---@return integer|nil size in MiB if buffer is valid, nil otherwise
M.cal_bufsize = function(bufnr)
    local ok, stats = pcall(
        vim.uv.fs_stat,
        api.nvim_buf_get_name(bufnr)
    )
    if ok and stats then
        return stats.size / (1024 * 1024)
    end
    return 0
end

---@return string path python3 executable path
M.find_py = function()
    if not M.has("uv") then
        vim.notify('uv not found, use python3 in path', vim.log.levels.WARN)
        return vim.fn.exepath("python3")
    end
    local cmd = {"uv", "python", "--python-preference=system", "find"}
    local res = vim.system(cmd, { text = true }):wait()
    if res.code ~= 0 then
        vim.notify(res.stderr, vim.log.levels.WARN)
        return "python"
    end
    return res.stdout:sub(1, -2)
end

---@type string
local cache_py
---@return string path similar with find_py, but use cache first
M.get_py = function()
    if cache_py == nil then
        cache_py = M.find_py()
    end
    return cache_py
end

---run command in terminal
---@param cmd string command to run
M.run_in_terminal = function(cmd)
    vim.validate({
        cmd = {cmd, "string", false},
    })
    vim.cmd("silent wall")
    vim.cmd(('-tab terminal %s'):format(cmd))
    vim.cmd("set nobuflisted")
    vim.cmd("setlocal nonumber signcolumn=no norelativenumber")
    vim.cmd.startinsert()
end

---@class FileRunOpts
---@field build boolean|nil if build file
---@field debug boolean|nil if debug

---run file
---@param opts FileRunOpts|nil
M.run_file = function(opts)
    vim.validate({
        opts = {opts, function(args)
            return args == nil or (args.build or args.debug)
        end, "nil or table with build or debug field"},
    })
    local ft = vim.bo.filetype
    local file = vim.fn.expand("%:p")
    local file_noext = vim.fn.expand("%:p:r")
    local exe_suffix = M.is_win and ".exe" or ""
    local program = ""
    if not opts then
        if ft == "python" then
            program = "uv run --python-preference=system"
        elseif ft == "javascript" then
            program = "node"
        elseif ft == "lua" then
            program = "nvim -l"
        elseif ft == "zig" then
            program = "zig run"
        elseif ft == "typst" then
            program = "tinymist preview"
        elseif ft == "go" then
            program = "go run"
        elseif ft == "cython" then
            vim.ui.open(file_noext..".html")
            return
        elseif vim.tbl_contains({"c", "cpp", "rust", "pascal"}, ft) then
            program = M.wrap_path(file_noext)
            file = ""
        else
            program = M.wrap_path(file)
            file = ""
        end
    elseif opts.build then
        if ft == "make" then
            program = "make -f"
        elseif ft == "typst" then
            program = "typst compile"
        elseif ft == "c" then
            program = "gcc -g -Wall -o"..file_noext..exe_suffix
        elseif ft == "cpp" then
            program = "g++ -g -Wall -o"..file_noext..exe_suffix
        elseif ft == "go" then
            program = "go build -o "..file_noext..exe_suffix
        elseif ft == "zig" then
            program = "zig build-exe -O Debug"
        elseif ft == "rust" then
            program = "rustc -g -o"..file_noext..exe_suffix
        elseif ft == "cython" then
            program = "cython -3 -a"
        elseif ft == "pascal" then
            program = "fpc -gw -gl"
        else
            vim.notify(("unsupport to build filetype `%s`"):format(ft), vim.log.levels.WARN)
            return
        end
    elseif opts.debug then
        if ft == "python" then
            program = "uv run --python-preference=system python -m pdb"
        elseif vim.tbl_contains({"c", "cpp", "rust", "pascal"}, ft) then
            program = "gdb"
            file = file_noext..exe_suffix
        else
            vim.notify(("unsupport to debug filetype `%s`"):format(ft), vim.log.levels.WARN)
            return
        end
    end
    file = file ~= "" and M.wrap_path(file) or file
    local cmd = ("%s %s"):format(program, file)
    M.run_in_terminal(cmd)
end

return M
