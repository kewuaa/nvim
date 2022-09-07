local configs = {}


configs.guess_indent = function()
    -- This is the default configuration
    require('guess-indent').setup {
        auto_cmd = true,  -- Set to false to disable automatic execution
        filetype_exclude = require("settings").exclude_filetypes,  -- A list of filetypes for which the auto command gets disabled
        buftype_exclude = {  -- A list of buffer types for which the auto command gets disabled
            "help",
            "nofile",
            "terminal",
            "prompt",
        },
    }
    vim.cmd [[exe 'GuessIndent']]
end

configs.nvim_surround = function()
    require("nvim-surround").setup({
        keymaps = {
            insert = "<C-g>s",
            insert_line = "<C-g>S",
            normal = "ys",
            normal_cur = "yss",
            normal_line = "yS",
            normal_cur_line = "ySS",
            visual = "S",
            visual_line = "gS",
            delete = "ds",
            change = "cs",
        },
    })
end

configs.hop = function()
    require('hop').setup({
        keys = 'etovxqpdygfblzhckisuran'
    })
end

configs.nvim_comment = function()
    require('nvim_comment').setup({
        -- Linters prefer comment and line to have a space in between markers
        marker_padding = true,
        -- should comment out empty or whitespace only lines
        comment_empty = false,
        -- trim empty comment whitespace
        comment_empty_trim_whitespace = true,
        -- Should key mappings be created
        create_mappings = true,
        -- Normal mode mapping left hand side
        line_mapping = "gcc",
        -- Visual/Operator mapping left hand side
        operator_mapping = "gc",
        -- text object mapping, comment chunk,,
        comment_chunk_text_object = "ic",
        -- Hook function to call before commenting takes place
        hook = nil

    })
end

configs.iswap = function()
    require("iswap").setup({
        autoswap = true,
    })
end

configs.vim_illuminate = function()
    -- Use background for "Visual" as highlight for words. Change this behavior here!
    if vim.api.nvim_get_hl_by_name("Visual", true).background then
        local illuminate_bg = string.format("#%06x", vim.api.nvim_get_hl_by_name("Visual", true).background)

        vim.api.nvim_set_hl(0, "IlluminatedWordText", { bg = illuminate_bg })
        vim.api.nvim_set_hl(0, "IlluminatedWordRead", { bg = illuminate_bg })
        vim.api.nvim_set_hl(0, "IlluminatedWordWrite", { bg = illuminate_bg })
    end

    require("illuminate").configure({
        providers = {
            "lsp",
            "treesitter",
            "regex",
        },
        delay = 100,
        filetypes_denylist = require("settings").exclude_filetypes,
        under_cursor = true,
    })
end

configs.nvim_gomove = function()
    require("gomove").setup {
        -- whether or not to map default key bindings, (true/false)
        map_defaults = true,
        -- whether or not to reindent lines moved vertically (true/false)
        reindent = true,
        -- whether or not to undojoin same direction moves (true/false)
        undojoin = true,
        -- whether to not to move past end column when moving blocks horizontally, (true/false)
        move_past_end_col = false,
    }
end

configs.accelerated_jk = function()
    -- conservative deceleration 
    vim.g.accelerated_jk_enable_deceleration = 1
    -- if default key-repeat interval check(150 ms) is too short
    vim.g.accelerated_jk_acceleration_limit = 250

    local map = vim.keymap.set
    local opt = {
        noremap = true,
        silent = true,
    }
    map('n', 'j', '<Plug>(accelerated_jk_gj)', opt)
    map('n', 'k', '<Plug>(accelerated_jk_gk)', opt)

end


return configs
