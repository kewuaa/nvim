local M = {}
local cmp = require('cmp')
local luasnip = require('luasnip')

function M.config()
    cmp.setup({
        snippet = {
            expand = function(args)
                luasnip.lsp_expand(args.body)
            end,
        },
        sources = {
            {name = 'nvim_lsp'},
            {name = 'nvim_lua'},
            {name = 'nvim_lsp_signature_help'},
            {name = 'luasnip'},
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
        },
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
                elseif luasnip.expand_or_jumpable() then
                    luasnip.expand_or_jump()
                else
                    fallback()
                end
            end, { 'i', 's' }),
            ['<S-Tab>'] = cmp.mapping(function(fallback)
                if cmp.visible() then
                    cmp.select_prev_item()
                elseif luasnip.jumpable(-1) then
                    luasnip.jump(-1)
                else
                    fallback()
                end
            end, { 'i', 's' }),
        }),
    })
end

return M

