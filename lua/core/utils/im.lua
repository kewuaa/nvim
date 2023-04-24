local M = {}
local exepath = vim.fn.stdpath('config') .. '/bin/imtoggle'
local imtoggle_enabled = false

local toggle_imtoggle = function()
    if not imtoggle_enabled then
        vim.notify('imtoggle enabled')
        vim.api.nvim_create_augroup('IM', {clear = true})
        vim.api.nvim_create_autocmd('InsertEnter', {
            group = 'IM',
            callback = function()
                vim.fn.system(exepath .. ' 1')
            end
        })
        vim.api.nvim_create_autocmd('InsertLeave', {
            group = 'IM',
            callback = function()
                vim.fn.system(exepath .. ' 0')
            end
        })
        imtoggle_enabled = true
    else
        vim.notify('imtoggle disabled')
        vim.api.nvim_del_augroup_by_name('IM')
        imtoggle_enabled = false
    end
end

M.init = function()
    if vim.fn.executable(exepath) then
        vim.keymap.set({'n', 'i'}, '<M-;>', toggle_imtoggle)
    else
        vim.notify('imtoggle not build')
    end
end

return M
