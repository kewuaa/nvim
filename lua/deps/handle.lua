local M = {}
local keymaps = require("user.keymaps")

---@type table<string, function[]|boolean>
local handles = {}

---add handle
---@param plugin string
---@param handle function
local add = function(plugin, handle)
    if not handles[plugin] then
        handles[plugin] = {handle}
    else
        table.insert(handles[plugin], handle)
    end
end

---remove handle
---@param plugin string
local remove = function(plugin)
    if handles[plugin] and handles[plugin] ~= true then
        for _, cancel in ipairs(handles[plugin]) do
            cancel()
        end
        handles[plugin] = true
    end
end

---return if the plugin is loaded
---@param plugin string
M.if_loaded = function(plugin)
    if handles[plugin] == nil then
        vim.notify(plugin.." not register yet", vim.log.levels.ERROR)
        return false
    end
    return handles[plugin] == true
end

---load plugin
---@param plugin PlugSpec
M.load = function(plugin)
    local task = function()
        if plugin.lazy_opts.delay_install then
            require("mini.deps").add(plugin, {bang = false})
            if plugin.config then
                plugin.config()
            end
            return
        end
        if plugin.depends then
            for _, depend in ipairs(plugin.depends) do
                local t = type(depend)
                if t == "string" then
                    local name = vim.fn.fnamemodify(depend, ":t")
                    if handles[name] ~= true then
                        vim.cmd.packadd(name)
                        handles[name] = true
                    end
                elseif t == "table" then
                    local name = depend.name or vim.fn.fnamemodify(depend.source, ":t")
                    if handles[name] ~= true then
                        vim.cmd.packadd(name)
                        if depend.config then
                            depend.config()
                        end
                        handles[name] = true
                    end
                else
                    vim.notify("unexpected type")
                end
            end
        end
        vim.cmd.packadd(plugin.name)
        if plugin.config then
            plugin.config()
        end
    end

    if handles[plugin.name] == true then
        vim.notify("load "..plugin.name.." repeatedly", vim.log.levels.WARN)
        return
    end
    remove(plugin.name)
    local delay = plugin.lazy_opts.delay
    if delay > 0 then
        vim.fn.timer_start(delay, task)
    else
        task()
    end
end

---create lazy handle for command
---@param plugin PlugSpec
M.create_lazy_commands = function(plugin)
    local cmds = plugin.lazy_opts.cmds
    if not cmds then
        return
    end
    add(plugin.name, function()
        for _, cmd in ipairs(cmds) do
            pcall(vim.api.nvim_del_user_command, cmd)
        end
    end)
    for _, cmd in ipairs(cmds) do
        vim.api.nvim_create_user_command(
            cmd,
            function(event)
                local command = {
                    cmd = cmd,
                    bang = event.bang or nil,
                    mods = event.smods,
                    args = event.fargs,
                    count = event.count >= 0 and event.range == 0 and event.count or nil,
                }

                if event.range == 1 then
                    command.range = { event.line1 }
                elseif event.range == 2 then
                    command.range = { event.line1, event.line2 }
                end

                M.load(plugin)

                local info = vim.api.nvim_get_commands({})[cmd] or vim.api.nvim_buf_get_commands(0, {})[cmd]
                if not info then
                    vim.schedule(function()
                        vim.notify(
                            ("Command `%s` not found after loading %s"):format(cmd, plugin.name),
                            vim.log.levels.ERROR
                        )
                    end)
                    return
                end

                command.nargs = info.nargs
                if event.args and event.args ~= "" and info.nargs and info.nargs:find("[1?]") then
                    command.args = { event.args }
                end
                vim.cmd(command)
            end,
            {
                bang = true,
                range = true,
                nargs = "*",
                complete = function(_, line)
                    M.load(plugin)
                    -- NOTE: return the newly loaded command completion
                    return vim.fn.getcompletion(line, "cmdline")
                end,
            }
        )
    end
end

---create lazy handle for events
---@param plugin PlugSpec
M.create_lazy_events = function(plugin)
    local events = plugin.lazy_opts.events
    if not events then
        return
    end
    local group = vim.api.nvim_create_augroup(
        ("_%s_event_handle_"):format(plugin.name),
        {clear = true}
    )
    add(plugin.name, function()
        pcall(vim.api.nvim_del_augroup_by_id, group)
    end)
    for _, event in ipairs(events) do
        local pattern = "*"
        if event:match("^%w+%s+[^%s]+$") then
            local pair = vim.fn.split(event, " ")
            event = pair[1]
            pattern = pair[2]
        end
        vim.api.nvim_create_autocmd(event, {
            group = group,
            pattern = pattern,
            callback = function()
                M.load(plugin)
            end
        })
    end
end

---create lazy handle for keys
---@param plugin PlugSpec
M.create_lazy_keys = function(plugin)
    local keys = plugin.lazy_opts.keys
    if not keys then
        return
    end
    add(plugin.name, function()
        for _, key in ipairs(keys) do
            local opts = nil
            if key.opts and key.opts.buffer then
                opts = {buffer = key.opts.buffer}
            end
            pcall(vim.keymap.del, key.mode, key.lhs, opts)
            if key.rhs then
                keymaps.set(key.mode, key.lhs, key.rhs, key.opts)
            end
        end
    end)
    for _, key in ipairs(keys) do
        vim.keymap.set(
            key.mode,
            key.lhs,
            function()
                M.load(plugin)
                if key.rhs then
                    vim.validate({
                        rhs = {
                            key.rhs,
                            function(rhs)
                                local t = type(rhs)
                                return t == "string" or t == "function"
                            end,
                            "rhs must be string or function"
                        }
                    })
                    local expr_keys
                    if key.opts and key.opts.expr then
                        expr_keys = type(key.rhs) == "string" and vim.api.nvim_eval(key.rhs) or key.rhs()
                    else
                        if type(key.rhs) == "function" then
                            key.rhs()
                        else
                            expr_keys = key.rhs
                        end
                    end
                    if expr_keys then
                        vim.api.nvim_feedkeys(
                            vim.api.nvim_replace_termcodes(expr_keys, true, false, true),
                            "i", false
                        )
                    end
                else
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(key.lhs, true, false, true),
                        "i", false
                    )
                end
            end,
            {
                nowait = true,
                expr = false
            }
        )
    end
end

return M
