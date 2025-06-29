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
end

local cmd_completion = function()
    vim.cmd([[set wildcharm=<C-@>]])
    local term = vim.api.nvim_replace_termcodes('<C-@>', true, true, true)
    local timer = vim.uv.new_timer()
    local trigger_completion = vim.schedule_wrap(function()
        local cmdline = vim.fn.getcmdline()
        local curpos = vim.fn.getcmdpos()
        local last_char = cmdline:sub(curpos - 1, curpos - 1)

        if
            curpos == #cmdline + 1
            and vim.fn.pumvisible() == 0
            and last_char:match('[%w%/%:- ]')
            and not cmdline:match('^%d+$')
            and not vim.tbl_isempty(vim.fn.getcompletion(cmdline, "cmdline"))
        then
            vim.api.nvim_feedkeys(term, 'ti', false)
            vim.opt.eventignore:append('CmdlineChanged')
            vim.schedule(function()
                vim.fn.setcmdline(vim.fn.substitute(vim.fn.getcmdline(), '\\%x00', '', 'g'))
                vim.opt.eventignore:remove('CmdlineChanged')
            end)
        end
    end)

    vim.api.nvim_create_autocmd('CmdlineChanged', {
        desc = 'Auto show command line completion',
        group = vim.api.nvim_create_augroup('autocomplete-cmd', {}),
        pattern = ':',
        callback = function()
            assert(timer)
            timer:stop()
            timer:start(50, 0, trigger_completion)
        end,
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
    cmd_completion()
end

return M
