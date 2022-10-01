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
        indent = {
            enable = true,
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
    vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
        group = 'setup_plugins',
        callback = function()
            vim.opt.foldmethod     = 'expr'
            vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
        end
    })
end

configs.hlargs = function()
    require("hlargs").setup({
        excluded_filetypes = require("settings").exclude_filetypes,
    })
end

configs.nvim_gps = function()
    local gps = require("nvim-gps")
    gps.setup({
        icons = {
            ["class-name"] = " ", -- Classes and class-like objects
            ["function-name"] = " ", -- Functions
            ["method-name"] = " ", -- Methods (functions inside class-like objects)
            ["container-name"] = '⛶ ',  -- Containers (example: lua tables)
            ["tag-name"] = '炙'         -- Tags (example: html tags)
        },
        languages = {
            -- You can disable any language individually here
            ["c"] = true,
            ["cpp"] = true,
            -- ["go"] = true,
            -- ["java"] = true,
            ["javascript"] = true,
            ["lua"] = true,
            ["python"] = true,
            -- ["rust"] = true,
        },
        separator = " > ",
    })
    local function setup_winbar()
        if gps.is_available() then
            vim.opt_local.winbar = [[%{luaeval("require('nvim-gps').get_location()")}]]
        end
    end
    vim.api.nvim_create_autocmd({'BufRead', 'BufNewFile'}, {
        group = 'setup_plugins',
        pattern = '*',
        callback = setup_winbar,
    })
    setup_winbar()
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
    require("plugins").check_loaded({
        'nvim-web-devicons',
    })
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

configs.telescope = function()
    require("plugins").check_loaded({
        'plenary.nvim',
        'telescope-fzf-native.nvim',
        'nvim-web-devicons',
    })
    local telescope = require("telescope")

    telescope.setup({
        defaults = {
            prompt_prefix = '🔭 ',
            selection_caret = ' ',
            layout_config = {
                horizontal = {
                    prompt_position = 'top',
                    results_width = 0.6,
                },
                vertical = {
                    mirror = false,
                },
            },
            sorting_strategy = 'ascending',
            file_previewer = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
            qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
            file_ignore_patterns = {
                "^%.git/",
                "^.venv/",
                "^__pycache__/",
                "^%.cache/",
                "^zig%-cache",
                "^zig%-out",
                "%.class",
                "%.pdf",
                "%.mkv",
                "%.mp4",
                "%.zip",
            },
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            },
        }
    })
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    telescope.load_extension('fzf')
    telescope.load_extension("notify")
end

configs.overseer = function()
    local overseer = require('overseer')
    overseer.setup({
        dap = false,
        task_list = {
            default_detail = 2,
        },
        log = {
            {
                type = "notify",
                level = vim.log.levels.WARN,
            },
        },
    })
    overseer.register_template({
        name = 'run file',
        builder = function(params)
            local ft = vim.bo.filetype
            local file = vim.fn.expand('%:p')
            local root = require('plugins').get_cwd()
            vim.cmd [[wa]]
            local cmd = require("settings").run_file_config[ft](root, file)
            return {
                cmd = cmd,
                name = 'run ' .. ft,
                components = {
                    {
                        "on_output_quickfix",
                        set_diagnostics = true,
                        open = true,
                    },
                    {
                        "on_complete_dispose",
                        statuses = {"SUCCESS"},
                    },
                    {
                        "on_result_diagnostics",
                        remove_on_restart = true,
                    },
                    "default",
                },
                cwd = root,
            }
        end,
        desc = "run the current file",
    })
    vim.api.nvim_create_user_command("OverseerRestartLast", function()
        local tasks = overseer.list_tasks({ recent_first = true })
        if vim.tbl_isempty(tasks) then
            vim.notify("No tasks found", vim.log.levels.WARN)
        else
            vim.cmd [[wa]]
            overseer.run_action(tasks[1], "restart")
        end
    end, {})
end

configs.dressing = function ()
    require("dressing").setup()
end

configs.notify = function ()
    local notify = require("notify")
    notify.setup({
        ---@usage Animation style one of { "fade", "slide", "fade_in_slide_out", "static" }
        stages = "slide",
        ---@usage Function called when a new window is opened, use for changing win settings/config
        on_open = nil,
        ---@usage Function called when a window is closed
        on_close = nil,
        ---@usage timeout for notifications in ms, default 5000
        timeout = 2000,
        -- Render function for notifications. See notify-render()
        render = "default",
        ---@usage highlight behind the window for stages that change opacity
        background_colour = "Normal",
        ---@usage minimum width for notification windows
        minimum_width = 50,
        ---@usage notifications with level lower than this would be ignored. [ERROR > WARN > INFO > DEBUG > TRACE]
        level = "TRACE",
        ---@usage Icons for the different levels
        icons = {
            ERROR = "",
            WARN = "",
            INFO = "",
            DEBUG = "",
            TRACE = "✎",
        },
    })

    vim.notify = notify
end

configs.toggleterm = function()
    local function shell()
        local shell_ = 'pwsh'
        if vim.fn.has('win32') then
            shell_ = 'powershell'
        end
        return shell_
    end
    local powershell_options = {
        shell = shell(),
        shellcmdflag = "-NoLogo -NoProfile -ExecutionPolicy RemoteSigned -Command [Console]::InputEncoding=[Console]::OutputEncoding=[System.Text.Encoding]::UTF8;",
        shellredir = "-RedirectStandardOutput %s -NoNewWindow -Wait",
        shellpipe = "2>&1 | Out-File -Encoding UTF8 %s; exit $LastExitCode",
        shellquote = "",
        shellxquote = "",
    }

    for option, value in pairs(powershell_options) do
        vim.opt[option] = value
    end
    require("toggleterm").setup({
        -- size can be a number or function which is passed the current terminal
        size = function(term)
            if term.direction == "horizontal" then
                return 15
            elseif term.direction == "vertical" then
                return vim.o.columns * 0.40
            end
        end,
        on_open = function()
            -- Prevent infinite calls from freezing neovim.
            -- Only set these options specific to this terminal buffer.
            vim.api.nvim_set_option_value("foldmethod", "manual", { scope = "local" })
            vim.api.nvim_set_option_value("foldexpr", "0", { scope = "local" })
        end,
        open_mapping = false, -- [[<c-\>]],
        hide_numbers = true, -- hide the number column in toggleterm buffers
        shade_filetypes = {},
        shade_terminals = false,
        shading_factor = "1", -- the degree by which to darken to terminal colour, default: 1 for dark backgrounds, 3 for light
        start_in_insert = true,
        insert_mappings = true, -- whether or not the open mapping applies in insert mode
        persist_size = true,
        direction = "horizontal",
        close_on_exit = true, -- close the terminal window when the process exits
        shell = vim.o.shell, -- change the default shell
    })
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
    require("plugins").check_loaded({
        'nvim-web-devicons',
    })
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
    require("plugins").check_loaded({
        'nvim-web-devicons',
    })
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
