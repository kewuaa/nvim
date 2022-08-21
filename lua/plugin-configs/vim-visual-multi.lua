local M = {}
local map = vim.api.nvim_set_keymap
local opt = {noremap = true, silent = true}

function M.setup()
    vim.g.VM_default_mappings = 0
    vim.g.VM_mouse_mappings = 0
end

function M.config()
    map('n', '<c-d>', '<Plug>(VM-Find-Under)', opt)
    map('x', '<c-d>', '<Plug>(VM-Find-Subword-Under)', opt)
    map('n', '<C-Up>', '<Plug>(VM-Select-Cursor-Up)', opt)
    map('n', '<C-Down>', '<Plug>(VM-Select-Cursor-Down)', opt)
    map('n', '\\\\\\', '<Plug>(VM-Add-Cursor-At-Pos)', opt)
    map('n', '\\\\A', '<Plug>(VM-Select-All)', opt)
    map('n', '\\\\/', '<Plug>(VM-Start-Regex-Search)', opt)
    map('n', '\\\\gs', '<Plug>(VM-Reselect-Last)', opt)
end

return M

