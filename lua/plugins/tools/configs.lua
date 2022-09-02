local configs = {}


configs.nvim_treesitter = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {},
        sync_install = false,
        auto_install = false,
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = false,
        },
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = nil, -- Do not enable for files with more than n lines, int
            -- colors = {}, -- table of hex strings
            -- termcolors = {} -- table of colour name strings
        },
    })
    vim.api.nvim_set_option_value("foldmethod", "expr", {})
    vim.api.nvim_set_option_value("foldexpr", "nvim_treesitter#foldexpr()", {})
end

configs.nvim_context_vt = function()
    require('nvim_context_vt').setup({
      -- Enable by default. You can disable and use :NvimContextVtToggle to maually enable.
      -- Default: true
      enabled = true,

      -- Override default virtual text prefix
      -- Default: '-->'
      prefix = '',

      -- Disable virtual text for given filetypes
      -- Default: { 'markdown' }
      disable_ft = { 'markdown' },

      -- Disable display of virtual text below blocks for indentation based languages like Python
      -- Default: false
      disable_virtual_lines = false,

      -- Same as above but only for spesific filetypes
      -- Default: {}
      disable_virtual_lines_ft = { 'yaml' },

      -- How many lines required after starting position to show virtual text
      -- Default: 1 (equals two lines total)
      min_rows = 1,

      -- Same as above but only for spesific filetypes
      -- Default: {}
      min_rows_ft = {},
    })
end

configs.indent_blankline = function()
    require('indent_blankline').setup({
        show_end_of_line = true,
        show_current_context = true,
        show_current_context_start = true,
        filetype_exclude = require("settings").exclude_filetypes,
    })
end

configs.trouble = function()
    require("trouble").setup({
        position = "bottom", -- position of the list can be: bottom, top, left, right
        height = 10, -- height of the trouble list when position is top or bottom
        width = 50, -- width of the list when position is left or right
        icons = true, -- use devicons for filenames
        mode = "workspace_diagnostics", -- "workspace_diagnostics", "document_diagnostics", "quickfix", "lsp_references", "loclist"
        fold_open = "", -- icon used for open folds
        fold_closed = "", -- icon used for closed folds
        group = true, -- group results by file
        padding = true, -- add an extra new line on top of the list
        action_keys = { -- key mappings for actions in the trouble list
            -- map to {} to remove a mapping, for example:
            -- close = {},
            close = "q", -- close the list
            cancel = "<esc>", -- cancel the preview and get back to your last window / buffer / cursor
            refresh = "r", -- manually refresh
            jump = {"<cr>", "<tab>"}, -- jump to the diagnostic or open / close folds
            open_split = { "<c-x>" }, -- open buffer in new split
            open_vsplit = { "<c-v>" }, -- open buffer in new vsplit
            open_tab = { "<c-t>" }, -- open buffer in new tab
            jump_close = {"o"}, -- jump to the diagnostic and close the list
            toggle_mode = "m", -- toggle between "workspace" and "document" diagnostics mode
            toggle_preview = "P", -- toggle auto_preview
            hover = "K", -- opens a small popup with the full multiline message
            preview = "p", -- preview the diagnostic location
            close_folds = {"zM", "zm"}, -- close all folds
            open_folds = {"zR", "zr"}, -- open all folds
            toggle_fold = {"zA", "za"}, -- toggle fold of current file
            previous = "k", -- preview item
            next = "j" -- next item
        },
        indent_lines = true, -- add an indent guide below the fold icons
        auto_open = false, -- automatically open the list when you have diagnostics
        auto_close = false, -- automatically close the list when you have no diagnostics
        auto_preview = true, -- automatically preview the location of the diagnostic. <esc> to close preview and go back to last window
        auto_fold = false, -- automatically fold a file trouble list at creation
        auto_jump = {"lsp_definitions"}, -- for the given modes, automatically jump if there is only a single result
        signs = {
            -- icons / text used for a diagnostic
            error = "",
            warning = "",
            hint = "",
            information = "",
            other = "﫠"
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    })
end

configs.symbols_outline = function()
    require('symbols-outline').setup({
        highlight_hovered_item = true,
        show_guides = true,
        auto_preview = false,
        position = 'right',
        relative_width = true,
        width = 25,
        auto_close = false,
        show_numbers = false,
        show_relative_numbers = false,
        show_symbol_details = true,
        preview_bg_highlight = 'Pmenu',
        autofold_depth = nil,
        auto_unfold_hover = true,
        fold_markers = { '', '' },
        keymaps = { -- These keymaps can be a string or a table for multiple keys
            close = {"<Esc>", "q"},
            goto_location = "<Cr>",
            focus_location = "o",
            hover_symbol = "<C-K>",
            toggle_preview = "K",
            rename_symbol = "r",
            code_actions = "a",
            fold = "h",
            unfold = "l",
            fold_all = "W",
            unfold_all = "E",
            fold_reset = "R",
        },
        lsp_blacklist = {},
        symbol_blacklist = {},
        symbols = {
            File = {icon = "", hl = "TSURI"},
            Module = {icon = "", hl = "TSNamespace"},
            Namespace = {icon = "", hl = "TSNamespace"},
            Package = {icon = "", hl = "TSNamespace"},
            Class = {icon = "𝓒", hl = "TSType"},
            Method = {icon = "ƒ", hl = "TSMethod"},
            Property = {icon = "", hl = "TSMethod"},
            Field = {icon = "", hl = "TSField"},
            Constructor = {icon = "", hl = "TSConstructor"},
            Enum = {icon = "ℰ", hl = "TSType"},
            Interface = {icon = "ﰮ", hl = "TSType"},
            Function = {icon = "", hl = "TSFunction"},
            Variable = {icon = "", hl = "TSConstant"},
            Constant = {icon = "", hl = "TSConstant"},
            String = {icon = "𝓐", hl = "TSString"},
            Number = {icon = "#", hl = "TSNumber"},
            Boolean = {icon = "⊨", hl = "TSBoolean"},
            Array = {icon = "", hl = "TSConstant"},
            Object = {icon = "⦿", hl = "TSType"},
            Key = {icon = "🔐", hl = "TSType"},
            Null = {icon = "NULL", hl = "TSType"},
            EnumMember = {icon = "", hl = "TSField"},
            Struct = {icon = "𝓢", hl = "TSType"},
            Event = {icon = "🗲", hl = "TSType"},
            Operator = {icon = "+", hl = "TSOperator"},
            TypeParameter = {icon = "𝙏", hl = "TSParameter"}
        }
    })
end

configs.telescope = function()
    vim.cmd [[exe 'PackerLoad plenary.nvim telescope-fzf-native.nvim']]
    local telescope = require("telescope")

    telescope.setup({
        defaults = {
            prompt_prefix = '🔭 ',
            selection_caret = ' ',
            layout_config = {
                horizontal = { prompt_position = 'top', results_width = 0.6 },
                vertical = { mirror = false },
            },
            sorting_strategy = 'ascending',
            file_previewer = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
            qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        }
    })
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    telescope.load_extension('fzf')
end

configs.asynctasks = function()
    vim.g.asyncrun_mode = 4
    vim.g.asyncrun_save = 2
    vim.g.asyncrun_bell = 1
    vim.g.asyncrun_rootmarks = require("settings").py3_rootmarks
    vim.g.asynctasks_term_focus = 0
    vim.g.asynctasks_term_pos = 'external'
    vim.g.asynctasks_template = 1
end

configs.vim_terminal_help = function()
    vim.g.terminal_cwd = 0
    vim.g.terminal_height = 10
    vim.g.terminal_pos = 'rightbelow'
    vim.g.terminal_list = 0
    vim.g.terminal_close = 1
end

configs.gitsigns = function()
    require('gitsigns').setup {
        signs = {
            add          = {hl = 'GitSignsAdd'   , text = '+', numhl='GitSignsAddNr'   , linehl='GitSignsAddLn'},
            change       = {hl = 'GitSignsChange', text = '│', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
            delete       = {hl = 'GitSignsDelete', text = '-', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            topdelete    = {hl = 'GitSignsDelete', text = '‾', numhl='GitSignsDeleteNr', linehl='GitSignsDeleteLn'},
            changedelete = {hl = 'GitSignsChange', text = '~', numhl='GitSignsChangeNr', linehl='GitSignsChangeLn'},
        },
        on_attach = function(bufnr)
            local gs = package.loaded.gitsigns

            local function map(mode, l, r, opts)
                opts = opts or {}
                opts.buffer = bufnr
                vim.keymap.set(mode, l, r, opts)
            end

            -- Navigation
            map('n', ']c', function()
                if vim.wo.diff then return ']c' end
                vim.schedule(function() gs.next_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            map('n', '[c', function()
                if vim.wo.diff then return '[c' end
                vim.schedule(function() gs.prev_hunk() end)
                return '<Ignore>'
            end, {expr=true})

            -- Actions
            map({'n', 'v'}, '<leader>hs', ':Gitsigns stage_hunk<CR>')
            map({'n', 'v'}, '<leader>hr', ':Gitsigns reset_hunk<CR>')
            map('n', '<leader>hS', gs.stage_buffer)
            map('n', '<leader>hu', gs.undo_stage_hunk)
            map('n', '<leader>hR', gs.reset_buffer)
            map('n', '<leader>hp', gs.preview_hunk)
            map('n', '<leader>hb', function() gs.blame_line{full=true} end)
            map('n', '<leader>tb', gs.toggle_current_line_blame)
            map('n', '<leader>hd', gs.diffthis)
            map('n', '<leader>hD', function() gs.diffthis('~') end)
            map('n', '<leader>td', gs.toggle_deleted)

            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>')
        end
    }
end

configs.nvim_tree = function()
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = "u", action = "dir_up" },
          },
        },
      },
    })
end

configs.JABS = function()
    require('jabs').setup({
        -- Options for the main window
        position = 'center', -- center, corner. Default corner
        width = 80, -- default 50
        height = 20, -- default 10
        border = 'single', -- none, single, double, rounded, solid, shadow, (or an array or chars). Default shadow

        offset = { -- window position offset
            top = 2, -- default 0
            bottom = 2, -- default 0
            left = 2, -- default 0
            right = 2, -- default 0
        },

        -- Options for preview window
        preview_position = 'left', -- top, bottom, left, right. Default top
        preview = {
            width = 40, -- default 70
            height = 60, -- default 30
            border = 'single', -- none, single, double, rounded, solid, shadow, (or an array or chars). Default double
        },

        -- Default highlights (must be a valid :highlight)
        highlight = {
            current = "Title", -- default StatusLine
            hidden = "StatusLineNC", -- default ModeMsg
            split = "WarningMsg", -- default StatusLine
            alternate = "StatusLine" -- default WarningMsg
        },

        -- Default symbols
        -- symbols = {
        --     current = "C", -- default 
        --     split = "S", -- default 
        --     alternate = "A", -- default 
        --     hidden = "H", -- default ﬘
        --     locked = "L", -- default 
        --     ro = "R", -- default 
        --     edited = "E", -- default 
        --     terminal = "T", -- default 
        --     default_file = "D", -- Filetype icon if not present in nvim-web-devicons. Default 
        -- },

        -- Keymaps
        keymap = {
            close = "d", -- Close buffer. Default D
            jump = "<CR>", -- Jump to buffer. Default <cr>
            h_split = "h", -- Horizontally split buffer. Default s
            v_split = "v", -- Vertically split buffer. Default v
            preview = "p", -- Open buffer preview. Default P
        },

        -- Whether to use nvim-web-devicons next to filenames
        use_devicons = true -- true or false. Default true
    })
end


return configs
