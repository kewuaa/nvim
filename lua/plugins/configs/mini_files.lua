local keymap = require("user.keymaps")
local mini_files = require("mini.files")

mini_files.setup({
    windows = {
        preview = true,
        width_focus = 30,
        width_nofocus = 15,
        width_preview = 50,
    }
})

-- toggle dotfiles
local show_dotfiles = true
local filter_show = function(fs_entry) return true end
local filter_hide = function(fs_entry)
    return not vim.startswith(fs_entry.name, '.')
end
local toggle_dotfiles = function()
    show_dotfiles = not show_dotfiles
    local new_filter = show_dotfiles and filter_show or filter_hide
    mini_files.refresh({ content = { filter = new_filter } })
end

-- open split
local map_split = function(buf_id, lhs, direction)
    local rhs = function()
        -- Make new window and set it as target
        local new_target_window
        vim.api.nvim_win_call(mini_files.get_explorer_state().target_window, function()
            vim.cmd(direction .. ' split')
            new_target_window = vim.api.nvim_get_current_win()
        end)

        mini_files.set_target_window(new_target_window)
    end

    -- Adding `desc` will result into `show_help` entries
    local desc = 'Split ' .. direction
    vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
end

local mini_files_group = vim.api.nvim_create_augroup("mini_files", {clear = true})
vim.api.nvim_create_autocmd('User', {
    group = mini_files_group,
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local buf_id = args.data.buf_id
        -- Tweak keys to your liking
        vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
        map_split(buf_id, '<C-s>', 'belowright horizontal')
        map_split(buf_id, '<C-v>', 'belowright vertical')
    end,
})

-- Set focused directory as current working directory
local set_cwd = function()
    local path = (mini_files.get_fs_entry() or {}).path
    if path == nil then return vim.notify('Cursor is not on valid entry') end
    vim.fn.chdir(vim.fs.dirname(path))
end

-- Yank in register full path of entry under cursor
local yank_path = function()
    local path = (mini_files.get_fs_entry() or {}).path
    if path == nil then return vim.notify('Cursor is not on valid entry') end
    vim.fn.setreg(vim.v.register, path)
end

-- Open path with system default handler (useful for non-text files)
local ui_open = function() vim.ui.open(mini_files.get_fs_entry().path) end

vim.api.nvim_create_autocmd('User', {
    group = mini_files_group,
    pattern = 'MiniFilesBufferCreate',
    callback = function(args)
        local b = args.data.buf_id
        vim.keymap.set('n', 'g~', set_cwd,   { buffer = b, desc = 'Set cwd' })
        vim.keymap.set('n', 'gX', ui_open,   { buffer = b, desc = 'OS open' })
        vim.keymap.set('n', 'gy', yank_path, { buffer = b, desc = 'Yank path' })
    end,
})

keymap.set("n", "<leader>fe", mini_files.open)
keymap.set("n", "<leader>fwd", function() require("mini.files").open(vim.api.nvim_buf_get_name(0), false) end)
