local M = {}
local quick_quit_fts = { 'qf', 'help' }

local quick_quit = function()
    vim.api.nvim_create_autocmd('filetype', {
        desc = "custom filetype callback",
        callback = function()
            local ft = vim.bo.filetype
            -- quick quit
            if vim.tbl_contains(quick_quit_fts, ft) then
                vim.keymap.set('n', 'q', '<cmd>q<CR>', {silent = true, buffer = 0})
            -- change commentstring
            elseif vim.tbl_contains({"c", "cpp", "rust", "typst"}, ft) then
                vim.bo.commentstring = "// %s"
            end
        end
    })
end

local restore_cursor = function()
    vim.api.nvim_create_autocmd("BufReadPre", {
        desc = "restore cursor position",
        callback = function(args)
            local bufnr = args.buf
            local exclude_fts = require("user.settings").exclude_filetypes
            vim.api.nvim_create_autocmd("Filetype", {
                once = true,
                buffer = bufnr,
                callback = function()
                    -- Stop if not a normal buffer
                    if vim.bo.buftype ~= '' then return end

                    -- Stop if filetype is ignored
                    if vim.tbl_contains(exclude_fts, vim.bo.filetype) then return end

                    -- Stop if line is already specified (like during start with `nvim file +num`)
                    local cursor_line = vim.api.nvim_win_get_cursor(0)[1]
                    if cursor_line > 1 then return end

                    -- Stop if can't restore proper line for some reason
                    local mark_line = vim.api.nvim_buf_get_mark(0, [["]])[1]
                    local n_lines = vim.api.nvim_buf_line_count(0)
                    if not (1 <= mark_line and mark_line <= n_lines) then return end

                    -- Restore cursor and open just enough folds
                    vim.cmd([[normal! g`"zv]])

                    -- Center window
                    vim.cmd('normal! zz')
                end
            })
        end
    })
end

local number_toggle = function()
    local numbertoggle_group = vim.api.nvim_create_augroup("_number_toggle_", {clear = true})
    vim.api.nvim_create_autocmd({
        "BufEnter",
        "FocusGained",
        "InsertLeave",
        "CmdlineLeave",
        "WinEnter",
    }, {
       group = numbertoggle_group,
       callback = function()
          if vim.o.nu and vim.api.nvim_get_mode().mode ~= "i" then
             vim.opt.relativenumber = true
          end
       end,
    })
    vim.api.nvim_create_autocmd({
        "BufLeave",
        "FocusLost",
        "InsertEnter",
        "CmdlineEnter",
        "WinLeave",
    }, {
       group = numbertoggle_group,
       callback = function()
          if vim.o.nu then
             vim.opt.relativenumber = false
             vim.cmd "redraw"
          end
       end,
    })

    vim.api.nvim_create_autocmd("BufReadPre", {
        desc = "bigfile autocmd",
        callback = function(args)
            local bufnr = args.buf
            require("utils.bigfile").check_once(bufnr)
        end
    })
end

---register filetypes to auto map 'q' to quit
---@param ... string
M.register_quick_quit = function(...)
    local fts = {...}
    for _, ft in pairs(fts) do
        quick_quit_fts[#quick_quit_fts+1] = ft
    end
end

M.init = function()
    quick_quit()
    restore_cursor()
    number_toggle()
end

return M
