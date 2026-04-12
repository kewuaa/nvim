local mini_pairs = require("mini.pairs")

mini_pairs.setup({
    -- In which modes mappings from this `config` should be created
    modes = { insert = true, command = true, terminal = true },
    mappings = {
        ['('] = { action = 'open', pair = '()', neigh_pattern = '[^\\].' },
        ['['] = { action = 'open', pair = '[]', neigh_pattern = '[^\\].' },
        ['{'] = { action = 'open', pair = '{}', neigh_pattern = '[^\\].' },

        [')'] = { action = 'close', pair = '()', neigh_pattern = '[^\\].' },
        [']'] = { action = 'close', pair = '[]', neigh_pattern = '[^\\].' },
        ['}'] = { action = 'close', pair = '{}', neigh_pattern = '[^\\].' },

        ['"'] = { action = 'closeopen', pair = '""', neigh_pattern = '[^\\].', register = { cr = false } },
        ["'"] = { action = 'closeopen', pair = "''", neigh_pattern = '[^%a<&\\].', register = { cr = false } },
        ['`'] = { action = 'closeopen', pair = '``', neigh_pattern = '[^\\].', register = { cr = false } },
    },
    skip_ts = "string",
    skip_unbalanced = true,
    markdown = true
})

local mini_pairs_group = vim.api.nvim_create_augroup("mini_pairs", {
    clear = true
})
local add_pairs = function()
    local ft = vim.bo.filetype
    if vim.list_contains({"markdown", "typst"}, ft) then
        mini_pairs.map_buf(0, 'i', '$', {
            action = 'closeopen',
            pair = '$$',
            neigh_pattern = '[^\\]',
            register = { cr = true }
        })
    elseif ft == "rust" then
        mini_pairs.map_buf(0, 'i', '|', {
            action = 'closeopen',
            pair = '||',
            neigh_pattern = '[^%w\\]',
            register = { cr = false }
        })
    elseif ft == "html" then
        mini_pairs.map_buf(0, 'i', '<', {
            action = 'closeopen',
            pair = '<>',
            neigh_pattern = '[^\\]',
            register = { cr = true }
        })
    end
end
vim.schedule(add_pairs)
vim.api.nvim_create_autocmd("FileType", {
    desc = "add filetype specified pair",
    group = mini_pairs_group,
    callback = add_pairs,
})
local map_bs = function(lhs, rhs)
    vim.keymap.set('i', lhs, rhs, { expr = true, replace_keycodes = false })
end

map_bs('<C-h>', 'v:lua.MiniPairs.bs()')
map_bs('<C-w>', 'v:lua.MiniPairs.bs("\23")')
map_bs('<C-u>', 'v:lua.MiniPairs.bs("\21")')

-- add space inner brackets
local mini_pairs_callback = function()
    if vim.v.char == " " then
        local keys = vim.api.nvim_replace_termcodes(
            "<space><left>",
            true,
            false,
            true
        )
        vim.api.nvim_feedkeys(keys, "i", false)
    end
end
local mini_pairs_open = mini_pairs.open
mini_pairs.open = function(pairs, neigh_pattern)
    local ret = mini_pairs_open(pairs, neigh_pattern)
    if not vim.tbl_contains({ "{}", "$$" }, pairs) then
        return ret
    end
    vim.schedule(
        function()
            local autocmd_id = vim.api.nvim_create_autocmd("InsertCharPre", {
                once = true,
                group = mini_pairs_group,
                buffer = 0,
                callback = mini_pairs_callback
            })
            local cleanup_group = vim.api.nvim_create_augroup("PairSpaceCleanup", {clear = true})
            vim.api.nvim_create_autocmd({"InsertLeave", "CursorMovedI"}, {
                group = cleanup_group,
                callback = function()
                    pcall(vim.api.nvim_del_autocmd, autocmd_id)
                    vim.api.nvim_del_augroup_by_id(cleanup_group)
                end,
                desc = "delete autocmd for pair space adding"
            })
        end
    )
    return ret
end
-- hide completion menu before <CR>
local mini_pairs_cr = mini_pairs.cr
mini_pairs.cr = function(key)
    local res = mini_pairs_cr(key)
    local complete_info = vim.fn.complete_info()
    if complete_info.pum_visible == 1 then
        local idx = complete_info.selected
        res = vim.keycode(
            idx == -1 and "<C-e>" or "<C-y>"
        )..res
    end
    return res
end
