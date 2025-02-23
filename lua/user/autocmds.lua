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
    number_toggle()
end

return M
