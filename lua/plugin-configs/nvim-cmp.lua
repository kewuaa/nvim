local M = {}
local cmp = require('cmp')

function M.config()
    vim.cmd [[
        exe 'PackerLoad lspkind-nvim'
    ]]
    cmp.setup({
        mapping = cmp.mapping.preset.insert({
            ['<C-b>'] = cmp.mapping.scroll_docs(-4),
            ['<C-f>'] = cmp.mapping.scroll_docs(4),
            ['<C-Space>'] = cmp.mapping.complete(),
            ['<CR>'] = cmp.mapping.confirm {
                behavior = cmp.ConfirmBehavior.Replace,
                select = true,
            },
            ['<Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_next_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
        formatting = {
            format = require('lspkind').cmp_format({
                with_text = true, -- do not show text alongside icons
                maxwidth = 50, -- prevent the popup from showing more than provided characters (e.g 50 will not show more than 50 characters)
                before = function (entry, vim_item)
                    -- Source 显示提示来源
                    vim_item.menu = "["..string.upper(entry.source.name).."]"
                    return vim_item
                end
            })
        },
        sources = {
            {name = 'nvim_lsp'},
            {
                name = 'buffer',
                option = {
                    get_bufnrs = function()
                        return vim.api.nvim_list_bufs()
                    end,
                },
            },
            {
                name = 'path',
                option = {
                    trailing_slash = false,
                    get_cwd = function()
                        return vim.api.nvim_eval('fnamemodify(bufname("%"), ":p:h")')
                    end,
                },
            },
        }
    })
end

return M

