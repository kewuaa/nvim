local function setup_color()
    vim.g.starry_italic_comments = true
    vim.g.starry_italic_string = false
    vim.g.starry_italic_keywords = false
    vim.g.starry_italic_functions = false
    vim.g.starry_italic_variables = false
    vim.g.starry_contrast = true
    vim.g.starry_borders = false
    vim.g.starry_disable_background = false  -- set to true to disable background and allow transparent background
    -- not overwrite old values and may has some side effects
    vim.g.starry_daylight_switch = false  -- this allow using brighter color
    -- other themes: dracula, oceanic, dracula_blood, 'deep ocean', darker, palenight, monokai, mariana, emerald, middlenight_blue
end

local function config_color()
    vim.cmd [=[
        colorscheme monokai
    ]=]
    vim.fn.timer_start(1000, function(timer)
        vim.cmd [[
            hi CmpItemAbbrMatch guibg=none
            hi CmpItemAbbrMatch guifg=lightblue
            hi CmpItemAbbrMatchFuzzy guibg=none
            hi CmpItemAbbrMatchFuzzy guifg=lightblue
        ]] end)
end
return {
    -- 颜色主题
    {
        'ray-x/starry.nvim',
        opt = true,
        event = {'BufReadPre *', 'BufNewFile *'},
        setup = setup_color,
        config = config_color,
    },
}
