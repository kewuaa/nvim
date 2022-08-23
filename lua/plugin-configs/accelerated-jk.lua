local M = {}
local map = vim.api.nvim_set_keymap
local opt = {noremap = true, silent = true}

function M.config()
    -- conservative deceleration 
    vim.g.accelerated_jk_enable_deceleration = 1
    -- if default key-repeat interval check(150 ms) is too short
    vim.g.accelerated_jk_acceleration_limit = 250
    -- replace j and k mappings
    map('n', 'j', '<Plug>(accelerated_jk_gj)', opt)
    map('n', 'k', '<Plug>(accelerated_jk_gk)', opt)
end

return M

