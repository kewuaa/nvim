local M = {}

function M.config()
    require('nvim-autopairs').setup({
        map_c_h = true,
        map_c_w = true,
    })

    if packer_plugins['nvim-cmp'] and packer_plugins['nvim-cmp'].loaded then
        -- If you want insert `(` after select function or method item
        local cmp_autopairs = require('nvim-autopairs.completion.cmp')
        local cmp = require('cmp')
        cmp.event:on(
          'confirm_done',
          cmp_autopairs.on_confirm_done()
        )
    end
end

return M

