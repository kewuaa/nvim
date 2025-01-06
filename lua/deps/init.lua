local M = {}
local handle = require("deps.handle")
local path_package = vim.fn.stdpath('data') .. '/site/'
M.package_path = path_package .. "pack/deps/"

M.init = function()
    vim.opt.loadplugins = false
    -- Clone 'mini.nvim' manually in a way that it gets managed by 'mini.deps'
    local mini_path = path_package .. 'pack/deps/start/mini.deps'
    if not vim.uv.fs_stat(mini_path) then
        vim.cmd('echom "Installing `mini.deps`" | redraw')
        local clone_cmd = {
            'git', 'clone', '--filter=blob:none',
            'https://github.com/echasnovski/mini.deps', mini_path
        }
        vim.fn.system(clone_cmd)
        vim.cmd('packadd mini.deps | helptags ALL')
        vim.cmd('echom "Installed `mini.deps`" | redraw')
    end

    -- Set up 'mini.deps' (customize to your liking)
    local deps = require('mini.deps')
    deps.setup({ path = { package = path_package } })
    setmetatable(M, {__index = deps})
end

---@class Hook
---@field pre_install function|nil before creating plugin directory
---@field post_install function|nil after  creating plugin directory
---@field pre_checkout function|nil before making change in existing plugin
---@field post_checkout function|nil after making change in existing plugin

---@class KeySpec
---@field mode string|string[]
---@field lhs string
---@field rhs string|function|nil
---@field opts vim.keymap.set.Opts|nil

---@class LazyOpts
---@field cmds string[]|nil
---@field events string[]|nil
---@field keys KeySpec[]|nil
---@field very_lazy boolean|nil
---@field delay number|nil
---@field delay_install boolean|nil

---@class PlugSpec
---@field source string uri of plugin source
---@field name string|nil name to be used in disk
---@field checkout string|nil target state
---@field monitor string|nil monitor branch
---@field depends string[]|PlugSpec[]|nil
---@field hooks Hook|nil
---@field config function|nil
---@field lazy_opts LazyOpts|nil

---add plugin
---@param plugin PlugSpec
M.add = function(plugin)
    vim.validate({
        spec = {plugin, "table", false},
        source = {plugin.source, "string", false},
        name = {plugin.name, "string", true},
        checkout = {plugin.checkout, "string", true},
        monitor = {plugin.monitor, "string", true},
        depends = {plugin.depends, "table", true},
        hooks = {plugin.hooks, "table", true},
        config = {plugin.config, "function", true},
        lazy_opts = {plugin.lazy_opts, "table", true}
    })
    local deps = require("mini.deps")
    plugin.name = plugin.name or vim.fn.fnamemodify(plugin.source, ":t")
    if not plugin.lazy_opts then
        deps.add(plugin, {bang = false})
        if plugin.config then
            deps.later(plugin.config)
        end
        return
    end

    vim.validate({
        cmds = {plugin.lazy_opts.cmds, "table", true},
        keys = {plugin.lazy_opts.keys, "table", true},
        events = {plugin.lazy_opts.events, "table", true},
        very_lazy = {plugin.lazy_opts.very_lazy, "boolean", true},
        delay = {plugin.lazy_opts.delay, "number", true},
        delay_install = {plugin.lazy_opts.delay_install, "boolean", true}
    })
   plugin.lazy_opts.delay = plugin.lazy_opts.delay or 0

    if not plugin.lazy_opts.delay_install then
        deps.add(plugin, {bang = true})
        if plugin.lazy_opts.very_lazy then
            deps.later(function()
                handle.load(plugin)
            end)
        end
    end
    handle.create_lazy_commands(plugin)
    handle.create_lazy_events(plugin)
    handle.create_lazy_keys(plugin)
end

return M
