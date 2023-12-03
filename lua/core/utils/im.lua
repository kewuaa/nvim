local M = {}
local imtoogle_enabled = false

function M.toggle_imtoggle(opts)
     if opts == nil then
         opts = {
             slient = false,
         }
     end
     local enabled = opts.enabled or not imtoogle_enabled
     if enabled then
         if not opts.silent then
             vim.notify('imtoggle enabled')
         end
         vim.api.nvim_create_augroup('IM', {clear = true})
         vim.api.nvim_create_autocmd('InsertEnter', {
             group = 'IM',
             callback = vim.fn.IMSwitchToZH
         })
         vim.api.nvim_create_autocmd('InsertLeave', {
             group = 'IM',
             callback = vim.fn.IMSwitchToEN
         })
         imtoogle_enabled = true
     else
         if not opts.silent then
             vim.notify('imtoggle disabled')
         end
         vim.api.nvim_del_augroup_by_name('IM')
         imtoogle_enabled = false
     end
end

M.init = function()
    vim.keymap.set({'n', 'i'}, '<M-;>', M.toggle_imtoggle)
end

return M
