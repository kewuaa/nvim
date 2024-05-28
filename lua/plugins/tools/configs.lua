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
end

configs.nvim_dap = function()
    local dap = require('dap')
    local is_Windows = require("core.settings").is_Windows
    local utils = require("core.utils")
    local mason_utils = require("core.utils.mason")
    -- config for python
    mason_utils.ensure_install("debugpy")
    dap.adapters.python = {
        type = 'executable';
        command = "debugpy-adapter",
    }
    dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            type = 'python'; -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch';
            name = "Launch file";

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            cwd = utils.get_cwd,
            program = function()
                local lsp = vim.lsp.get_active_clients()[1]
                local root = lsp.config.root_dir
                if root ~= nil then
                    return ("%s/main.py"):format(root)
                end
                return "${file}"
            end; -- This configuration will launch the current file if used.
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
    mason_utils.ensure_install("codelldb")
    dap.adapters.codelldb = {
        type = 'server',
        port = "${port}",
        executable = {
            command = "codelldb",
            args = { "--port", "${port}" },
            detached = is_Windows and false or true,
        },
    }
    local program_for_c = function()
        local lsp = vim.lsp.get_active_clients()[1]
        local root = lsp.config.root_dir
        if root ~= nil then
            return vim.fn.input(
                'Path to executable: ',
                ("%s/build/linux/x86_64/debug/"):format(root),
                "file"
            )
        end
        return vim.fn.expand("%:p:r")
    end
    dap.configurations.c = {
        {
            name = "Debug",
            type = "codelldb",
            request = "launch",
            program = program_for_c,
            cwd = utils.get_cwd,
            stopOnEntry = false,
        },
        {
            name = "Debug (with args)",
            type = "codelldb",
            request = "launch",
            program = program_for_c,
            args = function()
                local argument_string = vim.fn.input("Program arg(s) (enter nothing to leave it null): ")
                return vim.fn.split(argument_string, " ", true)
            end,
            cwd = utils.get_cwd,
            stopOnEntry = false,
        },
        {
            name = "Attach to a running process",
            type = "codelldb",
            request = "attach",
            program = program_for_c,
            stopOnEntry = false,
            waitFor = true,
        },
    }
    dap.configurations.cpp = dap.configurations.c
    dap.configurations.pascal = dap.configurations.c
    dap.configurations.rust = dap.configurations.c

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
    vim.g.asynctasks_term_focus = 1
    vim.g.asynctasks_template = 1
    vim.g.asynctasks_confirm = 0
    if settings.is_Windows then
        vim.g.asynctasks_term_pos = 'external'
        vim.g.asynctasks_environ = {
            exe_suffix = '.exe',
        }
    elseif settings.is_Linux then
        vim.g.asynctasks_term_pos = 'TAB'
        vim.g.asynctasks_environ = {
            exe_suffix = '',
        }
    end
    vim.g.asynctasks_extra_config = {vim.fn.stdpath('config') .. '/mytasks.ini'}
    vim.api.nvim_create_autocmd("User", {
        pattern = "PYVENVUPDATE",
        callback = function()
            local venv = require("core.utils.python").get_current_env()
            assert(venv ~= nil)
            vim.cmd(string.format('let g:asynctasks_environ["python"] = "%s"', venv.path))
        end
    })
end

configs.gitsigns = function()
    require('gitsigns').setup {
        signs = {
            add = { text = "▒" },
            change = { text = "▒" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▒" },
            untracked = { text = "▒" },
        },
        watch_gitdir = { interval = 1000, follow_files = true },
        current_line_blame = false,
        -- current_line_blame_opts = { delay = 1000, virtual_text_pos = "eol" },
        sign_priority = 6,
        update_debounce = 100,
        status_formatter = nil, -- Use default
        word_diff = false,
        diff_opts = { internal = true },
        on_attach = function(buffer)
            local gitsigns = package.loaded.gitsigns

            local function map(mode, l, r, desc)
                vim.keymap.set(mode, l, r, { buffer = buffer, desc = desc })
            end

            map("n", "]h", function() gitsigns.nav_hunk("next") end, "Next Hunk")
            map("n", "[h", function() gitsigns.nav_hunk("prev") end, "Prev Hunk")
            map("n", "]H", function() gitsigns.nav_hunk("last") end, "Last Hunk")
            map("n", "[H", function() gitsigns.nav_hunk("first") end, "First Hunk")
            map('n', '<leader>hs', gitsigns.stage_hunk, "stage hunk")
            map('n', '<leader>hr', gitsigns.reset_hunk, "reset hunk")
            map('v', '<leader>hs', function() gitsigns.stage_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "stage hunk")
            map('v', '<leader>hr', function() gitsigns.reset_hunk {vim.fn.line('.'), vim.fn.line('v')} end, "reset hunk")
            map('n', '<leader>hu', gitsigns.undo_stage_hunk, "undo stage hunk")
            map('n', '<leader>hS', gitsigns.stage_buffer, "stage buffer")
            map('n', '<leader>hR', gitsigns.reset_buffer, "reset buffer")
            map('n', '<leader>hp', gitsigns.preview_hunk, "preview hunk")
            map('n', '<leader>hb', function() gitsigns.blame_line{full=true} end, "blame line")
            map('n', '<leader>tb', gitsigns.toggle_current_line_blame, "toggle blame of current line")
            map('n', '<leader>hd', gitsigns.diffthis, "diff this")
            map('n', '<leader>hD', function() gitsigns.diffthis('~') end, "diff ~")
            map('n', '<leader>td', gitsigns.toggle_deleted, "toggle delete")
            -- Text object
            map({'o', 'x'}, 'ih', ':<C-U>Gitsigns select_hunk<CR>', "git hunk")
        end,
    }
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
            if vim.tbl_contains(ignore_buftypes, vim.bo.buftype) then
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
            if vim.tbl_contains(ignore_filetypes, vim.bo.filetype) and vim.bo.filetype ~= "help" then
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
