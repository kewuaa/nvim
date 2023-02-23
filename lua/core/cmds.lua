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

api.nvim_create_autocmd('User', {
    once = true,
    pattern = 'VeryLazy',
    callback = function ()
        load_rplugin()
        load_clipboard()
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

local cc = vim.api.nvim_create_user_command
local commands = {
    {'OpenCmd', 'AsyncTask terminal'},
    {'GitCommit', 'AsyncTask git-commit'},
    {'GitPush', 'AsyncTask git-push'},
    {'GitCheckout', 'AsyncTask git-checkout'},
    {'GitReset', 'AsyncTask git-reset'},
    {'GitLog', 'AsyncTask git-log'},
}
for _, command in ipairs(commands) do
    cc(command[1], command[2], command[3] or {})
end
