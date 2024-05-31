local M = {}
local api, fn = vim.api, vim.fn
local utils = require("core.utils")
local imtoogle_enabled = false

local function switch_to_en()
    fn.system('fcitx5-remote -c')
end

local function switch_to_zh()
    fn.system('fcitx5-remote -o')
end

---toggle imtoggle
---@param opts table|nil if opts.silent is true, a notify will be sended
function M.toggle_imtoggle(opts)
    vim.validate({
        opts = {opts, "table", true}
    })

    if opts == nil then
        opts = { slient = false }
    end
    local enabled = opts.enabled or not imtoogle_enabled
    local im_switch_to_en = nil
    local im_switch_to_zh = nil
    if utils.is_win then
        im_switch_to_en = fn.IMSwitchToEN
        im_switch_to_zh = fn.IMSwitchToZH
    else
        im_switch_to_en = switch_to_en
        im_switch_to_zh = switch_to_zh
    end
    if enabled then
        if not opts.silent then
            vim.notify('imtoggle enabled')
        end
        local im = api.nvim_create_augroup('_IM_', {clear = true})
        api.nvim_create_autocmd('InsertEnter', {
            group = im,
            callback = im_switch_to_zh
        })
        api.nvim_create_autocmd('InsertLeave', {
            group = im,
            callback = im_switch_to_en
        })
        imtoogle_enabled = true
    else
        if not opts.silent then
            vim.notify('imtoggle disabled')
        end
        api.nvim_del_augroup_by_name('_IM_')
        imtoogle_enabled = false
    end
end

return M
