local function setup_color()
end

local function config_color()
    require("dracula").setup({
        show_end_of_buffer = true,
    })
    vim.cmd [[
        colorscheme dracula
        hi Pmenu guibg=none
        hi CmpItemAbbrMatch guibg=none
    ]]
end
return {
    -- 颜色主题
    {
        'Mofiqul/dracula.nvim',
        opt = true,
        event = {'BufReadPre *', 'BufNewFile *'},
        -- setup = setup_color,
        config = config_color,
    },
}
