local api, fn, uv = vim.api, vim.fn, vim.loop
local data_dir = require("core.settings").data_dir
local vim_path = require("core.settings").nvim_path
local modules_dir = vim_path .. "/lua/plugins"
local packer_compiled = data_dir .. "lua/_compiled.lua"
local bak_compiled = data_dir .. "lua/bak_compiled.lua"
local packer = nil
local Packer = {}
Packer.__index = Packer


function Packer:load_plugins()
    self.modules = {}
    local modules = fn.globpath(modules_dir, '*/init.lua', 0, 1)
    for _, m in ipairs(modules) do
        m = string.match(m, '[/\\]([^/\\]-)[/\\]init.lua')
        self.modules[#self.modules+1] = m
    end
end


function Packer:load_packer()
    if not packer then
        vim.cmd("packadd packer.nvim")
        packer = require("packer")
    end
    packer.init({
        display = {
            open_fn = function()
                return require("packer.util").float({
                    border = 'single',
                })
            end,
        },
        git = { clone_timeout = 120 },
        disable_commands = true,
        max_jobs = 30,
        compile_path = packer_compiled,
    })
    packer.reset()
    local use = packer.use
    -- manage itself
    use({
        'wbthomason/packer.nvim',
        opt = true,
    })
    self:load_plugins()
    for _, m in pairs(self.modules) do
        m = 'plugins.' .. m
        for _, plugin in ipairs(require(m)) do
            use(plugin)
        end
    end
end

function Packer:init_ensure_plugins()
    local packer_dir = data_dir .. "pack/packer/opt/packer.nvim"
    local state = uv.fs_stat(packer_dir)
    if not state then
        local cmd = "!git clone git@github.com:wbthomason/packer.nvim.git " .. packer_dir
        vim.cmd(cmd)
        uv.fs_mkdir(data_dir .. "lua", 511, function()
            assert(nil, "Failed to make packer compile dir. Please restart Nvim and we'll try it again!")
        end)
        self:load_packer()
        packer.install()
    end
end

local plugins = setmetatable({}, {
    __index = function(_, key)
        if not packer then
            Packer:load_packer()
        end
        return packer[key]
    end,
})

function plugins.back_compile()
    if vim.fn.filereadable(packer_compiled) == 1 then
        os.rename(packer_compiled, bak_compiled)
    end
    plugins.compile()
    vim.notify("Packer Compile Success!", vim.log.levels.INFO, { title = "Success!" })
end

function plugins.load_compile()
    if fn.filereadable(packer_compiled) == 1 then
        require("_compiled")
    else
        plugins.back_compile()
    end

    local cmds = { "Compile", "Install", "Update", "Sync", "Clean", "Status" }
    for _, cmd in ipairs(cmds) do
        api.nvim_create_user_command("Packer" .. cmd, function()
            require("plugins")[cmd == "Compile" and "back_compile" or string.lower(cmd)]()
            end, { force = true })
    end

    api.nvim_create_autocmd("User", {
        pattern = "PackerComplete",
        callback = function()
            require("plugins").back_compile()
        end,
    })
end

plugins.group = api.nvim_create_augroup('setup_plugins', {clear = true})

function plugins.check_loaded(...)
    local names = {...}
    require("packer.load")(names, {}, packer_plugins, false)
end

function plugins.delay_load(event, pattern, delay, plugin)
    local function load()
        require("packer.load")((type(plugin) == 'table' and plugin) or {plugin}, {event = event}, packer_plugins, false)
    end
    api.nvim_create_autocmd(event, {
        group = plugins.group,
        pattern = pattern,
        once = true,
        callback = function()
            if delay > 0 then
                fn.timer_start(delay, load)
            else
                load()
            end
        end
    })
end


return plugins
