local M = {}
local imtoggle_enabled = false

local toggle_imtoggle = function()
    if not imtoggle_enabled then
        vim.notify('imtoggle enabled')
        vim.api.nvim_create_augroup('IM', {clear = true})
        vim.api.nvim_create_autocmd('InsertEnter', {
            group = 'IM',
            callback = vim.fn.IMSwitchToZH
        })
        vim.api.nvim_create_autocmd('InsertLeave', {
            group = 'IM',
            callback = vim.fn.IMSwitchToEN
        })
        imtoggle_enabled = true
    else
        vim.notify('imtoggle disabled')
        vim.api.nvim_del_augroup_by_name('IM')
        imtoggle_enabled = false
    end
end

M.init = function()
    vim.keymap.set({'n', 'i'}, '<M-;>', toggle_imtoggle)
end

return M
