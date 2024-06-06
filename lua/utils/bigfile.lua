local M = {}
local utils = require("utils")

---@class Task
---@field threshold number threshold size
---@field callback function callback will be called when buffer size is bigger than threshold
---@field defer boolean if the callback will be deferrd

---@type table<number, Task> task list
local tasks = {
    {
        threshold = 1,
        callback = function(_)
            -- disable vimopts
            vim.opt_local.swapfile = false
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.undolevels = -1
            vim.opt_local.undoreload = 0
            vim.opt_local.list = false
            -- disable syntax
            vim.cmd "syntax clear"
            vim.opt_local.syntax = "OFF"
            -- disable filetypes
            vim.opt_local.filetype = ""
        end,
        defer = true
    }
}

---check the task
---@param task Task
---@param bufnr number buffer number
local check_task = function(task, bufnr)
    local buf_size = utils.cal_bufsize(bufnr)
    if buf_size > task.threshold then
        if task.defer then
            vim.fn.timer_start(1000, function()
                task.callback(bufnr)
            end)
        else
            vim.schedule(function()
                task.callback(bufnr)
            end)
        end
    end
end

----check the buffer
---@param bufnr number buffer number
M.check_once = function(bufnr)
    for _, task in ipairs(tasks) do
        check_task(task, bufnr)
    end
end

---register a task
---@param task Task
---@param opts table
M.register = function(task, opts)
    vim.validate({
        arg1 = {task, "table", false},
        threshold = {task.threshold, "number", false},
        callback = {task.callback, "function", false},
        defer = {task.defer, "boolean", true},

        arg2 = {opts, "table", false},
        schedule = {opts.schedule, "boolean", true}
    })
    task.defer = task.defer or false
    opts.schedule = opts.schedule or true
    tasks[#tasks+1] = task
    if opts.schedule then
        check_task(task, 0)
    end
end

return M
