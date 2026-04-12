local mini_fuzzy = require("mini.fuzzy")
local mini_completion = require("mini.completion")

local accept = function()
    local keys = "<C-y>"
    local complete_info = vim.fn.complete_info()
    if complete_info.pum_visible == 1 then
        local idx = complete_info.selected
        if idx == -1 then
            keys = "<C-n>" .. keys
        end
    end
    return keys
end

local update_process_items = function()
    if vim.tbl_contains({ "c", "cpp" }, vim.bo.filetype) then
        vim.b.minicompletion_config = {
            lsp_completion = {
                process_items = function(items, base)
                    if base:sub(1, 1) == '.' then base = base:sub(2) end
                    return mini_completion.default_process_items(
                        items,
                        base,
                        { filtersort = mini_fuzzy.process_lsp_items }
                    )
                end
            }
        }
    end
end

local source_func = "omnifunc"
mini_fuzzy.setup()
mini_completion.setup({
    lsp_completion = {
        process_items = function(items, base)
            return mini_completion.default_process_items(
                items,
                base,
                { filtersort = mini_fuzzy.process_lsp_items }
            )
        end,
        source_func = source_func,
        auto_setup = false
    },
    mappings = {
        scroll_down = "<C-S-F>",
        scroll_up = "<C-S-B>"
    }
})
vim.bo[source_func] = "v:lua.MiniCompletion.completefunc_lsp"
update_process_items()

local group = vim.api.nvim_create_augroup("kewuaa.completion", { clear = true })
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        vim.bo[args.buf][source_func] = "v:lua.MiniCompletion.completefunc_lsp"
    end
})
vim.api.nvim_create_autocmd("FileType", {
    group = group,
    callback = update_process_items
})
vim.api.nvim_create_autocmd("CompleteDone", {
    group = group,
    callback = function()
        if vim.v.event.reason ~= "accept" then
            return
        end
        local completion_item = vim.tbl_get(vim.v.completed_item, "user_data", "lsp", "item")
        if completion_item == nil then
            return
        end
        -- Automatically add brackets
        local CompletionItemKind = vim.lsp.protocol.CompletionItemKind
        if
            completion_item.kind == CompletionItemKind.Function
            or completion_item.kind == CompletionItemKind.Method
            then
                local row, col = unpack(vim.api.nvim_win_get_cursor(0))
                local prev_char = vim.api.nvim_buf_get_text(0, row - 1, col - 1, row - 1, col, {})[1]
                local pair = vim.tbl_contains({ "tex", "plaintex", "bib" }, vim.bo.ft) and "{}" or "()"
                if prev_char:match("%w") then
                    vim.api.nvim_feedkeys(
                        vim.api.nvim_replace_termcodes(
                            "<C-g>U"..pair.."<C-g>U<left>",
                            true,
                            false,
                            true
                        ), "n", false
                    )
                end
            end
        end
    })
    vim.keymap.set("i", "<C-y>", accept, {silent = true, noremap = true, expr = true}
)
