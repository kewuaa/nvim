local M = {}

function M.setup()
    -- Set icons for sidebar.
    local diagnostic_icons = {
        Error = " ",
        Warn = " ",
        Info = " ",
        Hint = " ",
    }
    for type, icon in pairs(diagnostic_icons) do
        local hl = "DiagnosticSign" .. type
        vim.fn.sign_define(hl, { text = icon, texthl = hl })
    end

    vim.diagnostic.config({
      signs = true,
      update_in_insert = false,
      underline = true,
      severity_sort = true,
      virtual_text = {
        source = true,
      },
    })

    local kind = require("lspsaga.lspkind")
    kind[2][2] = " "
    kind[4][2] = " "
    kind[5][2] = "ﴯ "
    kind[6][2] = " "
    kind[7][2] = "ﰠ "
    kind[8][2] = " "
    kind[9][2] = " "
    kind[10][2] = " "
    kind[11][2] = " "
    kind[12][2] = " "
    kind[13][2] = " "
    kind[15][2] = " "
    kind[16][2] = " "
    kind[23][2] = " "
    kind[26][2] = " "

    local saga = require('lspsaga')

    saga.init_lsp_saga({
        -- Options with default value
        -- "single" | "double" | "rounded" | "bold" | "plus"
        border_style = "single",
        --the range of 0 for fully opaque window (disabled) to 100 for fully
        --transparent background. Values between 0-30 are typically most useful.
        saga_winblend = 0,
        -- when cursor in saga window you config these to move
        move_in_saga = { prev = '<C-p>',next = '<C-n>'},
        -- Error, Warn, Info, Hint
        -- use emoji like
        -- { "🙀", "😿", "😾", "😺" }
        -- or
        -- { "😡", "😥", "😤", "😐" }
        -- and diagnostic_header can be a function type
        -- must return a string and when diagnostic_header
        -- is function type it will have a param `entry`
        -- entry is a table type has these filed
        -- { bufnr, code, col, end_col, end_lnum, lnum, message, severity, source }
        -- diagnostic_header = { " ", " ", " ", "ﴞ " },
        diagnostic_header = { " ", " ", "  ", " " },
        -- show diagnostic source
        show_diagnostic_source = true,
        -- add bracket or something with diagnostic source, just have 2 elements
        diagnostic_source_bracket = {},
        -- preview lines of lsp_finder and definition preview
        max_preview_lines = 10,
        -- use emoji lightbulb in default
        code_action_icon = "💡",
        -- if true can press number to execute the codeaction in codeaction window
        code_action_num_shortcut = true,
        -- same as nvim-lightbulb but async
        code_action_lightbulb = {
            enable = true,
            sign = true,
            enable_in_insert = true,
            sign_priority = 20,
            virtual_text = true,
        },
        -- finder icons
        finder_icons = {
          def = '  ',
          ref = '諭 ',
          link = '  ',
        },
        -- finder do lsp request timeout
        -- if your project big enough or your server very slow
        -- you may need to increase this value
        finder_request_timeout = 1500,
        finder_action_keys = {
            open = "o",
            vsplit = "s",
            split = "i",
            tabe = "t",
            quit = "q",
            scroll_down = "<C-f>",
            scroll_up = "<C-b>", -- quit can be a table
        },
        code_action_keys = {
            quit = "q",
            exec = "<CR>",
        },
        rename_action_quit = "<C-c>",
        rename_in_select = true,
        definition_preview_icon = "  ",
        -- show symbols in winbar must nightly
        symbol_in_winbar = {
            in_custom = false,
            enable = false,
            separator = ' ',
            show_file = true,
            click_support = false,
        },
        -- show outline
        show_outline = {
          win_position = 'right',
          --set special filetype win that outline window split.like NvimTree neotree
          -- defx, db_ui
          win_with = '',
          win_width = 30,
          auto_enter = true,
          auto_preview = true,
          virt_text = '┃',
          jump_key = 'o',
          -- auto refresh when change buffer
          auto_refresh = true,
        },
        -- custom lsp kind
        -- usage { Field = 'color code'} or {Field = {your icon, your color code}}
        custom_kind = {},
        -- if you don't use nvim-lspconfig you must pass your server name and
        -- the related filetypes into this table
        -- like server_filetype_map = { metals = { "sbt", "scala" } }
        server_filetype_map = {},
    })

end

return M

