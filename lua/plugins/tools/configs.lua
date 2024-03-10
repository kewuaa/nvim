local configs = {}

configs.mason = function()
    require("mason").setup({
        PATH = "prepend",
        max_concurrent_installers = 4,
        ui = {
            icons = {
                package_installed = "✓",
                package_pending = "➜",
                package_uninstalled = "✗"
            }
        }
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
            error = "󰅚",
            warning = "󰀪",
            hint = "󰌶",
            information = "",
            other = ""
        },
        use_diagnostic_signs = false -- enabling this will use the signs defined in your lsp client
    })
end

configs.telescope = function()
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

configs.nvim_dap = function()
    local dap = require('dap')
    local is_Windows = require("core.settings").is_Windows
    local data_path = vim.fn.stdpath("data")
    -- config for python
    dap.adapters.python = {
        type = 'executable';
        command = require('core.settings'):getpy('default');
        args = { '-m', 'debugpy.adapter' };
    }
    dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch';
            name = "Launch file";

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            cwd = require('core.utils').get_cwd,
            program = "${file}"; -- This configuration will launch the current file if used.
            pythonPath = function()
                -- debugpy supports launching an application with a different interpreter then the one used to launch debugpy itself.
                -- The code below looks for a `venv` or `.venv` folder in the current directly and uses the python within.
                -- You could adapt this - to for example use the `VIRTUAL_ENV` environment variable.
                local pyenv = require("core.utils.python").get_current_env()
                if pyenv then
                    return pyenv.path
                else
                    return require('core.settings'):getpy('default')
                end
            end;
        },
    }

    -- config for c/c++/rust
    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            -- command = vim.fn.exepath("codelldb"), -- Find codelldb on $PATH
            command = ("%s/mason/packages/codelldb/extension/adapter/codelldb"):format(data_path),
            args = { "--port", "${port}" },
            detached = is_Windows and false or true,
        },
    }
    dap.configurations.c = {
        {
            name = "Debug",
            type = "codelldb",
            request = "launch",
            program = function()
                 return vim.fn.input(
                     'Path to executable (default to "a.exe"): ',
                     vim.fn.expand("%:p:r"),
                     "file"
                 )
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
        {
            name = "Debug (with args)",
            type = "codelldb",
            request = "launch",
            program = function()
                 return vim.fn.input(
                     'Path to executable (default to "a.exe"): ',
                     vim.fn.expand("%:p:r"),
                     "file"
                 )
            end,
            args = function()
                local argument_string = vim.fn.input("Program arg(s) (enter nothing to leave it null): ")
                return vim.fn.split(argument_string, " ", true)
            end,
            cwd = "${workspaceFolder}",
            stopOnEntry = false,
        },
        {
            name = "Attach to a running process",
            type = "codelldb",
            request = "attach",
            program = function()
                 return vim.fn.input(
                     'Path to executable (default to "a.exe"): ',
                     vim.fn.expand("%:p:r"),
                     "file"
                 )
            end,
            stopOnEntry = false,
            waitFor = true,
        },
    }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.rust = dap.configurations.c

    -- config for dotnet
    dap.adapters.coreclr = {
        type = "executable",
        command = ("%s/mason/packages/netcoredbg/netcoredbg/netcoredbg"):format(data_path),
        args = {'--interpreter=vscode'}
    }
    dap.configurations.cs = {
        {
            name = "netcoredbg",
            type = "coreclr",
            request = "launch",
            program = function()
                return vim.fn.input('Path to dll:', require("core.utils").get_cwd() .. '/bin/Debug/', 'file')
            end,
        },
    }

    -- config for ui
    local dapui = require('dapui')
    local dap_icons = {
        Breakpoint = "󰝥",
        BreakpointCondition = "󰟃",
        BreakpointRejected = "",
        LogPoint = "",
        Pause = "",
        Play = "",
        RunLast = "↻",
        StepBack = "",
        StepInto = "󰆹",
        StepOut = "󰆸",
        StepOver = "󰆷",
        Stopped = "",
        Terminate = "ﱢ",
    }
    dapui.setup({
        layouts = {
            {
                elements = {
                    -- Provide as ID strings or tables with "id" and "size" keys
                    {
                        id = "scopes",
                        size = 0.25, -- Can be float or integer > 1
                    },
                    { id = "breakpoints", size = 0.25 },
                    { id = "stacks", size = 0.25 },
                    { id = "watches", size = 0.25 },
                },
                size = 40,
                position = "left",
            },
            { elements = { "repl" }, size = 10, position = "bottom" },
        },
        controls = {
            enabled = true,
            -- Display controls in this session
            element = "repl",
            icons = {
                pause = dap_icons.Pause,
                play = dap_icons.Play,
                step_into = dap_icons.StepInto,
                step_over = dap_icons.StepOver,
                step_out = dap_icons.StepOut,
                step_back = dap_icons.StepBack,
                run_last = dap_icons.RunLast,
                terminate = dap_icons.Terminate,
            },
        },
    })
    vim.fn.sign_define(
        "DapBreakpoint",
        { text = dap_icons.Breakpoint, texthl = "DapBreakpoint", linehl = "", numhl = "" }
    )
    vim.fn.sign_define(
        "DapBreakpointCondition",
        { text = dap_icons.BreakpointCondition, texthl = "DapBreakpoint", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapStopped", { text = dap_icons.Stopped, texthl = "DapStopped", linehl = "", numhl = "" })
    vim.fn.sign_define(
        "DapBreakpointRejected",
        { text = dap_icons.BreakpointRejected, texthl = "DapBreakpoint", linehl = "", numhl = "" }
    )
    vim.fn.sign_define("DapLogPoint", { text = dap_icons.LogPoint, texthl = "DapLogPoint", linehl = "", numhl = "" })

    dap.listeners.after.event_initialized["dapui_config"] = function()
        dapui.open()
    end
    dap.listeners.before.event_terminated["dapui_config"] = function()
        dapui.close()
    end
    dap.listeners.before.event_exited["dapui_config"] = function()
        dapui.close()
    end

    local api = vim.api
    local keymap_restore = {}
    dap.listeners.after['event_initialized']['me'] = function()
        for _, buf in pairs(api.nvim_list_bufs()) do
            local keymaps = api.nvim_buf_get_keymap(buf, 'n')
            for _, keymap in pairs(keymaps) do
                if keymap.lhs == "K" then
                    table.insert(keymap_restore, keymap)
                    api.nvim_buf_del_keymap(buf, 'n', 'K')
                end
            end
        end
        api.nvim_set_keymap(
            'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
    end

    dap.listeners.after['event_terminated']['me'] = function()
        for _, keymap in pairs(keymap_restore) do
            api.nvim_buf_set_keymap(
                keymap.buffer,
                keymap.mode,
                keymap.lhs,
                keymap.rhs,
                { silent = keymap.silent == 1 }
            )
        end
        keymap_restore = {}
    end

    require("nvim-dap-virtual-text").setup({})
end

configs.asynctasks = function()
    local settings = require("core.settings")
    local rootmarks = settings.get_rootmarks()
    vim.list_extend(rootmarks, {
        '.tasks',
        '.root'
    })
    vim.g.asyncrun_save = 2
    vim.g.asyncrun_open = 10
    vim.g.asyncrun_rootmarks = rootmarks
    vim.g.asynctasks_term_pos = 'external'
    vim.g.asynctasks_term_focus = 0
    vim.g.asynctasks_template = 1
    vim.g.asynctasks_confirm = 0
    if settings.is_Windows then
        vim.g.asynctasks_environ = {
            exe_suffix = '.exe',
        }
    elseif settings.is_Linux then
        vim.g.asynctasks_environ = {
            exe_suffix = '',
        }
    end
    vim.g.asynctasks_extra_config = {vim.fn.stdpath('config') .. '/mytasks.ini'}
end

configs.gitsigns = function()
    require('gitsigns').setup {
        signs = {
            add = {
                hl = "GitSignsAdd",
                text = "",
                numhl = "GitSignsAddNr",
                linehl = "GitSignsAddLn",
            },
            change = {
                hl = "GitSignsChange",
                text = "",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
            delete = {
                hl = "GitSignsDelete",
                text = "",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            topdelete = {
                hl = "GitSignsDelete",
                text = "‾",
                numhl = "GitSignsDeleteNr",
                linehl = "GitSignsDeleteLn",
            },
            changedelete = {
                hl = "GitSignsChange",
                text = "~",
                numhl = "GitSignsChangeNr",
                linehl = "GitSignsChangeLn",
            },
        },
        watch_gitdir = { interval = 1000, follow_files = true },
        current_line_blame = false,
        -- current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        diff_opts = { internal = true },
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
            map('n', '<leader>hs', gs.stage_hunk)
            map('n', '<leader>hr', gs.reset_hunk)
            map('v', '<leader>hs', function() gs.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
            map('v', '<leader>hr', function() gs.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end)
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

configs.neotree = function()
    vim.g.neo_tree_remove_legacy_commands = 1
    require('neo-tree').setup({
        default_component_configs = {
            icon = {
                folder_closed = "",
                folder_open = "",
                folder_empty = "",
            },
            git_status = {
                symbols = {
                    -- Change type
                    added     = "", -- or "✚", but this is redundant info if you use git_status_colors on the name
                    modified  = "", -- or "", but this is redundant info if you use git_status_colors on the name
                    deleted   = "✖",-- this can only be used in the git_status source
                    renamed   = "",-- this can only be used in the git_status source
                    -- Status type
                    untracked = "",
                    ignored   = "",
                    unstaged  = "",
                    staged    = "",
                    conflict  = "",
                }
            },
        },
        window = {
            mappings = {
                ['s'] = 'none',
                ['S'] = 'none',
                ['<c-x>'] = 'open_split',
                ['<c-v>'] = 'open_vsplit',
            }
        },
        filesystem = {
            bind_to_cwd = false,
            filtered_items = {
                visible = false, -- when true, they will just be displayed differently than normal items
                hide_dotfiles = true,
                hide_gitignored = true,
                always_show = {
                    ".gitignore"
                }
            },
            window = {
                mappings = {
                    ['o'] = 'system_open',
                }
            },
            commands = {
                system_open = function(state)
                    local settings = require("core.settings")
                    local node = state.tree:get_node()
                    local path = node:get_id()
                    if settings.is_Windows then
                        vim.api.nvim_command('silent !explorer ' .. path)
                    elseif settings.is_Linux then
                        vim.api.nvim_command('silent !xdg-open ' .. path)
                    end
                end,
            }
        },
        event_handlers = {
            {
                event = "neo_tree_window_after_open",
                handler = function(args)
                    if args.position == "left" or args.position == "right" then
                        vim.cmd("wincmd =")
                    end
                end
            },
            {
                event = "neo_tree_window_after_close",
                handler = function(args)
                    if args.position == "left" or args.position == "right" then
                        vim.cmd("wincmd =")
                    end
                end
            },
            {
                event = "file_renamed",
                handler = function(args)
                    -- fix references to file
                    print(args.source .. " renamed to " .. args.destination)
                end
            },
            {
                event = "file_moved",
                handler = function(args)
                    -- fix references to file
                    print(args.source .. " moved to " .. args.destination)
                end
            },
        },
        source_selector = {
            winbar = true,
            statusline = false
        }
    })
end

configs.nvim_window_picker = function()
    require'window-picker'.setup({
        autoselect_one = true,
        include_current = false,
        filter_rules = {
            -- filter using buffer options
            bo = {
                -- if the file type is one of following, the window will be ignored
                filetype = { 'neo-tree', "neo-tree-popup", "notify" },

                -- if the buffer type is one of following, the window will be ignored
                buftype = { 'terminal', "quickfix" },
            },
        },
        other_win_hl_color = '#e35e4f',
        use_winbar = 'always', -- "always" | "never" | "smart"
    })
end

configs.focus = function()
    local ignore_filetypes = require("core.settings").exclude_filetypes
    local ignore_buftypes = { 'nofile', 'prompt', 'popup' }
    local augroup = vim.api.nvim_create_augroup('FocusDisable', { clear = true })

    vim.api.nvim_create_autocmd('WinEnter', {
        group = augroup,
        callback = function(_)
            if vim.tbl_contains(ignore_buftypes, vim.bo.buftype)
                then
                    vim.w.focus_disable = true
                else
                    vim.w.focus_disable = false
                end
            end,
            desc = 'Disable focus autoresize for BufType',
        })

        vim.api.nvim_create_autocmd('FileType', {
            group = augroup,
            callback = function(_)
                if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) then
                    vim.b.focus_disable = true
                else
                    vim.b.focus_disable = false
                end
            end,
            desc = 'Disable focus autoresize for FileType',
        })
    require('focus').setup({
        ui = {
            number = false, -- Display line numbers in the focussed window only
            relativenumber = false, -- Display relative line numbers in the focussed window only
            hybridnumber = false, -- Display hybrid line numbers in the focussed window only
            absolutenumber_unfocussed = false, -- Preserve absolute numbers in the unfocussed windows

            cursorline = true, -- Display a cursorline in the focussed window only
            cursorcolumn = false, -- Display cursorcolumn in the focussed window only
            colorcolumn = {
                enable = false, -- Display colorcolumn in the foccused window only
                list = '+1', -- Set the comma-saperated list for the colorcolumn
            },
            signcolumn = false, -- Display signcolumn in the focussed window only
            winhighlight = false, -- Auto highlighting for focussed/unfocussed windows
        }
    })
end

configs.markdown_preview = function()
    vim.api.nvim_create_autocmd('filetype', {
        pattern = 'markdown',
        command = [[nmap <silent><buffer> <M-q> :MarkdownPreviewToggle<CR>]]
    })
end

configs.leetcode = function()
    require("leetcode").setup({
        arg = "leetcode",
        lang = "cpp",
        cn = {
            enabled = true,
        },
        injector = {
            ["python3"] = {
                before = true
            },
            ["cpp"] = {
                before = { "#include <bits/stdc++.h>", "using namespace std;" },
                after = "int main() {}",
            },
        },
        image_support = false,
    })
end

configs.pantran = function()
    require("pantran").setup{
        -- Default engine to use for translation. To list valid engine names run
        -- `:lua =vim.tbl_keys(require("pantran.engines"))`.
        default_engine = "google",
        -- Configuration for individual engines goes here.
        engines = {
            google = {
                -- Default languages can be defined on a per engine basis. In this case
                -- `:lua require("pantran.async").run(function()
                -- vim.pretty_print(require("pantran.engines").yandex:languages()) end)`
                -- can be used to list available language identifiers.
                default_source = "auto",
                default_target = "zh-CN",
                format = "html"
            },
        },
        controls = {
            mappings = {
                edit = {
                    n = {
                        -- Use this table to add additional mappings for the normal mode in
                        -- the translation window. Either strings or function references are
                        -- supported.
                        ["j"] = "gj",
                        ["k"] = "gk"
                    },
                    i = {
                        -- Similar table but for insert mode. Using 'false' disables
                        -- existing keybindings.
                        ["<C-y>"] = false,
                        ["<C-a>"] = require("pantran.ui.actions").yank_close_translation
                    }
                },
                -- Keybindings here are used in the selection window.
                select = {
                    n = {
                        -- ...
                    }
                }
            }
        }
    }
end

return configs
