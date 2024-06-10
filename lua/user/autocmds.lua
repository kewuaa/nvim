local M = {}
local bigfile = require("utils.bigfile")
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
            elseif vim.tbl_contains({"c", "cpp", "rust"}, ft) then
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
            bigfile.check_once(bufnr)
        end
    })
end

local register_on_complete_done = function()
    vim.api.nvim_create_autocmd("CompleteDone", {
        desc = "do on CompleteDone",
        callback = function()
            local selected_item = vim.v.completed_item
            local cp_item = vim.tbl_get(selected_item, "user_data", "nvim", "lsp", "completion_item")
            if not cp_item then
                return
            end
            local snip_body
            if selected_item.kind == "Snippet" then
                if cp_item.textEdit
                    and cp_item.textEdit.newText
                    and cp_item.textEdit.newText:find("%$") then
                    snip_body = cp_item.textEdit.newText
                elseif cp_item.data then
                    snip_body = cp_item.data.body
                end
            elseif cp_item.insertTextFormat == vim.lsp.protocol.InsertTextFormat.Snippet then
                if cp_item.textEdit
                    and cp_item.textEdit.newText
                    and cp_item.textEdit.newText:find("%$") then
                    snip_body = cp_item.textEdit.newText
                elseif cp_item.insertText and cp_item.insertText:find("%$") then
                    snip_body = cp_item.insertText
                end
            end
            if snip_body then
                local line, col = unpack(vim.api.nvim_win_get_cursor(0))
                vim.api.nvim_buf_set_text(0, line - 1, col - #selected_item.word, line - 1, col, {})

                local snip_sess = vim.snippet.active() and vim.snippet._session or nil
                vim.snippet.expand(snip_body)
                if snip_sess then
                    vim.snippet._session = snip_sess
                end
                return
            elseif vim.tbl_contains({"Function", "Method"}, selected_item.kind) then
                local cursor = vim.api.nvim_win_get_cursor(0)
                local prev_char = vim.api.nvim_buf_get_text(0, cursor[1] - 1, cursor[2] - 1, cursor[1] - 1, cursor[2], {})[1]
                if vim.fn.mode() ~= "s" and prev_char ~= "(" and prev_char ~= ")" then
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(
                            "()<left>",
                            true,
                            false,
                            true
                        ), "i", false
                    )
                end
            end
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
    register_on_complete_done()
end

return M
