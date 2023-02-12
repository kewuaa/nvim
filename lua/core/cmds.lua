local api = vim.api
local map = vim.keymap.set
local bufopts = {
    silent = true,
    buffer = 0,
}
local function load_clipboard()
    api.nvim_del_var('loaded_clipboard_provider')
    api.nvim_command(string.format('source %s/autoload/provider/clipboard.vim', vim.env.VIMRUNTIME))
end
local function load_rplugin()
    api.nvim_del_var('loaded_remote_plugins')
    api.nvim_command(string.format('source %s/plugin/rplugin.vim', vim.env.VIMRUNTIME))
end

api.nvim_create_autocmd('CursorMoved', {
    once = true,
    pattern = '*',
    callback = function ()
        load_clipboard()
        load_rplugin()
    end
})
api.nvim_create_autocmd('filetype', {
    pattern = {
        'qf',
        'help',
        'notify',
        'TelescopePrompt',
        'dap-float',
    },
    callback = function ()
        map('n', 'q', '<cmd>q<CR>', bufopts)
    end
})
require('core.utils').init_bigfile_cmd()
