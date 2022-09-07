local function setup_color()
end

local function config_color()
    local monokai = require("monokai")
    local palette = monokai.classic
    monokai.setup({
        palette = require('monokai').soda,
        custom_hlgroups = {
            TSInclude = {
                fg = palette.aqua,
            },
            GitSignsAdd = {
                fg = palette.green,
                bg = palette.base2
            },
            GitSignsDelete = {
                fg = palette.pink,
                bg = palette.base2
            },
            GitSignsChange = {
                fg = palette.orange,
                bg = palette.base2
            },
        },
        italics = false,
    })
end
return {
    -- 颜色主题
    {
        'tanvirtin/monokai.nvim',
        opt = true,
        event = {'BufReadPre *', 'BufNewFile *'},
        -- setup = setup_color,
        config = config_color,
    },
}
