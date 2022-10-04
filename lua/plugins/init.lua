local M = {}

function M.init()
    local fn = vim.fn
    local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
    if fn.empty(fn.glob(install_path)) > 0 then
      fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
      vim.cmd [[packadd packer.nvim]]
    end

    require('plugins.keymaps')
    local packer = require("packer")
    local use = packer.use
    local modules = {
        'completion',
        'editor',
        'tools',
        'ui',
    }

    packer.init({
        display = {
            open_fn = function()
                return require("packer.util").float({
                    border = 'single',
                })
            end,
            working_sym = 'ﰭ',
            error_sym = '',
            done_sym = '',
            removed_sym = '',
            moved_sym = 'ﰳ',
        },
        git = { clone_timeout = 120 },
    })
    packer.reset()

    vim.api.nvim_create_augroup('setup_plugins', {
        clear = true,
    })

    -- manage itself
    use({
        'wbthomason/packer.nvim',
        opt = false
    })
    -- filetype
    use({
        'nathom/filetype.nvim',
        opt = false,
    })

    for _, module in pairs(modules) do
        module = 'plugins.' .. module
        for _, plugin in pairs(require(module)) do
            use(plugin)
        end
    end
end

function M.check_loaded(plugins)
    for _, name in ipairs(plugins) do
        if packer_plugins[name] then
            if not packer_plugins[name].loaded then
                vim.cmd(string.format([[packadd %s]], name))
            end
        else
            print(string.format('plugin %s not found', name))
        end
    end
end

function M.get_cwd()
    local activate_clients = vim.lsp.buf_get_clients()
    local num = #activate_clients
    if num > 0 then
        local root = activate_clients[num].config.root_dir
        if root then
            return root
        else
            return vim.fn.getcwd()
        end
    else
        return vim.fn.getcwd()
    end
end

M.init()
return M
