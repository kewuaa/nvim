local M = {}
local settings = require("core.settings")
local imtoogle_enabled = false

local function switch_to_en()
    vim.fn.system('fcitx5-remote -c')
end

local function switch_to_zh()
    vim.fn.system('fcitx5-remote -o')
end

function M.toggle_imtoggle(opts)
     if opts == nil then
         opts = {
             slient = false,
         }
     end
     local enabled = opts.enabled or not imtoogle_enabled
     local im_switch_to_en = nil
     local im_switch_to_zh = nil
     if settings.is_Windows then
         im_switch_to_en = vim.fn.IMSwitchToEN
         im_switch_to_zh = vim.fn.IMSwitchToZH
     else
         im_switch_to_en = switch_to_en
         im_switch_to_zh = switch_to_zh
     end
     if enabled then
         if not opts.silent then
             vim.notify('imtoggle enabled')
         end
         vim.api.nvim_create_augroup('IM', {clear = true})
         vim.api.nvim_create_autocmd('InsertEnter', {
             group = 'IM',
             callback = im_switch_to_zh
         })
         vim.api.nvim_create_autocmd('InsertLeave', {
             group = 'IM',
             callback = im_switch_to_en
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
    vim.keymap.set({'n'}, '<leader>ti', M.toggle_imtoggle)
end

return M
