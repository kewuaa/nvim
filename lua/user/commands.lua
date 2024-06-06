local M = {}
local api = vim.api

M.init = function()
    api.nvim_create_user_command('GitCommit', 'AsyncTask git-commit', {})
    api.nvim_create_user_command('GitPush', 'AsyncTask git-push', {})
    api.nvim_create_user_command('GitCheckout', 'AsyncTask git-checkout', {})
    api.nvim_create_user_command('GitReset', 'AsyncTask git-reset', {})
    api.nvim_create_user_command('GitLog', 'AsyncTask git-log', {})
end

return M
