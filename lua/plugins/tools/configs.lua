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
    local mason = require("utils.mason")
    local names = require("lsp").setup()
    for _, name in ipairs(names) do
        mason.ensure_install(name)
    end
    vim.schedule(function()
        vim.lsp.enable(names)
    end)
end

configs.mini_pick = function()
    require("mini.pick").setup({
        -- Keys for performing actions. See `:h MiniPick-actions`.
        mappings = {
            caret_left  = '<c-b>',
            caret_right = '<c-f>',

            choose            = '<CR>',
            choose_in_split   = '<C-s>',
            choose_in_tabpage = '<C-t>',
            choose_in_vsplit  = '<C-v>',
            choose_marked     = '<M-CR>',

            delete_char       = '<C-h>',
            delete_char_right = '<Del>',
            delete_left       = '<C-u>',
            delete_word       = '<C-w>',

            mark     = '<C-CR>',
            mark_all = '<C-a>',

            move_down  = '<C-n>',
            move_start = '<C-g>',
            move_up    = '<C-p>',

            paste = '<C-r>',

            refine        = '<C-Space>',
            refine_marked = '<M-Space>',

            scroll_down  = '<C-S-f>',
            scroll_left  = '<C-,>',
            scroll_right = '<C-.>',
            scroll_up    = '<C-S-b>',

            stop = '<Esc>',

            toggle_info    = '<S-Tab>',
            toggle_preview = '<Tab>',
        },
    })
end

configs.nvim_dap = function()
    local dap = require('dap')
    local utils = require("utils")
    local mason_utils = require("utils.mason")
    local get_args = function()
        local argument_string = vim.fn.input("Program arg(s) (enter nothing to leave it null): ")
        return vim.fn.split(argument_string, " ", true)
    end
    -- config for python
    mason_utils.ensure_install("debugpy")
    dap.adapters.python = function(cb, config)
        local adapter = {
            type = 'executable',
            options = {
                source_filetype = "python"
            }
        }
        if utils.is_win then
            local debugpy_root = require("mason-registry").get_package("debugpy"):get_install_path()
            adapter.command = debugpy_root .. "/venv/Scripts/pythonw.exe"
            adapter.args = {"-m", "debugpy.adapter"}
        else
            adapter.command = vim.fn.exepath("debugpy-adapter")
        end
        cb(adapter)
    end
    dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            name = "Debug",
            type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch',

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            program = "${file}", -- This configuration will launch the current file if used.
            pythonPath = utils.find_py,
        },
        {
            name = "Debug (with args)",
            type = "python",
            request = "launch",
            args = get_args,
            program = "${file}", -- This configuration will launch the current file if used.
            pythonPath = utils.find_py,
        }
    }

    -- config for c/c++/rust
    dap.adapters.gdb = {
        type = 'executable',
        command = "gdb",
        args = {
            "--interpreter=dap",
            "--eval-command", "set print pretty on"
        },
    }
    local program_for_c = function()
        local file = vim.fn.input(
            'Path to executable: ',
            "",
            "file"
        )
        return file ~= "" and file or vim.fn.expand("%:p:r")
    end
    dap.configurations.c = {
        {
            name = "Debug",
            type = "gdb",
            request = "launch",
            program = program_for_c,
            stopOnEntry = false,
        },
        {
            name = "Debug (with args)",
            type = "gdb",
            request = "launch",
            program = program_for_c,
            args = get_args,
            stopOnEntry = false,
        },
        {
            name = "Attach to a running process",
            type = "gdb",
            request = "attach",
            program = program_for_c,
            pid = function()
                local name = vim.fn.input('Executable name (filter): ')
                return require("dap.utils").pick_process({ filter = name })
            end,
            stopOnEntry = false,
        },
        {
            name = "Attach to gdbserver :1234",
            type = "gdb",
            request = "attach",
            target = "localhost:1234",
            program = program_for_c,
            stopOnEntry = false,
        }
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

    local keymap_restore = {}
    dap.listeners.after['event_initialized']['me'] = function()
        for _, buf in pairs(vim.api.nvim_list_bufs()) do
            local keymaps = vim.api.nvim_buf_get_keymap(buf, 'n')
            for _, keymap in pairs(keymaps) do
                if keymap.lhs == "K" then
                    table.insert(keymap_restore, keymap)
                    vim.api.nvim_buf_del_keymap(buf, 'n', 'K')
                end
            end
        end
        vim.api.nvim_set_keymap(
            'n', 'K', '<Cmd>lua require("dap.ui.widgets").hover()<CR>', { silent = true })
    end

    dap.listeners.after['event_terminated']['me'] = function()
        for _, keymap in pairs(keymap_restore) do
            vim.keymap.set(
                keymap.mode,
                keymap.lhs,
                keymap.rhs or keymap.callback,
                { silent = keymap.silent == 1, buffer = keymap.buffer }
            )
        end
        keymap_restore = {}
    end

    require("user.autocmds").register_quick_quit("dap-float")
end

configs.mini_git = function()
    local mini_git = require("mini.git")
    mini_git.setup()

    local map = vim.keymap.set
    local opts = {silent = true, noremap = true}
    map("n", "<leader>gs", mini_git.show_at_cursor, opts)
    map("v", "<leader>gs", mini_git.show_range_history, opts)
    local bufopts = {
        buffer = 0,
        silent = true,
        noremap = true
    }
    local mini_git_group = vim.api.nvim_create_augroup("mini_git", {
        clear = true
    })
    vim.api.nvim_create_autocmd("FileType", {
        group = mini_git_group,
        pattern = "git",
        callback = function()
            map("n", "gs", function()
                mini_git.show_diff_source()
            end, bufopts)
        end
    })
end

configs.mini_diff = function()
    local mini_diff = require("mini.diff")
    mini_diff.setup({
        view = {
            style = 'sign',
            -- Signs used for hunks with 'sign' view
            signs = { add = '┃', change = '┃', delete = '' },
        },
        mappings = {
            textobject = "ih"
        }
    })

    local map = vim.keymap.set
    local opts = {
        silent = true,
        noremap = true
    }
    map("n", "ghp", function() mini_diff.toggle_overlay() end, opts)
end

configs.mini_files = function()
    local mini_files = require("mini.files")
    mini_files.setup({
        windows = {
            preview = true,
            width_focus = 30,
            width_nofocus = 15,
            width_preview = 50,
        }
    })

    -- toggle dotfiles
    local show_dotfiles = true
    local filter_show = function(fs_entry) return true end
    local filter_hide = function(fs_entry)
        return not vim.startswith(fs_entry.name, '.')
    end
    local toggle_dotfiles = function()
        show_dotfiles = not show_dotfiles
        local new_filter = show_dotfiles and filter_show or filter_hide
        mini_files.refresh({ content = { filter = new_filter } })
    end

    -- open split
    local map_split = function(buf_id, lhs, direction)
        local rhs = function()
            -- Make new window and set it as target
            local new_target_window
            vim.api.nvim_win_call(mini_files.get_explorer_state().target_window, function()
                vim.cmd(direction .. ' split')
                new_target_window = vim.api.nvim_get_current_win()
            end)

            mini_files.set_target_window(new_target_window)
        end

        -- Adding `desc` will result into `show_help` entries
        local desc = 'Split ' .. direction
        vim.keymap.set('n', lhs, rhs, { buffer = buf_id, desc = desc })
    end

    local mini_files_group = vim.api.nvim_create_augroup("mini_files", {clear = true})
    vim.api.nvim_create_autocmd('User', {
        group = mini_files_group,
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
            local buf_id = args.data.buf_id
            -- Tweak keys to your liking
            vim.keymap.set('n', 'g.', toggle_dotfiles, { buffer = buf_id })
            map_split(buf_id, '<C-s>', 'belowright horizontal')
            map_split(buf_id, '<C-v>', 'belowright vertical')
        end,
    })

    -- Set focused directory as current working directory
    local set_cwd = function()
        local path = (mini_files.get_fs_entry() or {}).path
        if path == nil then return vim.notify('Cursor is not on valid entry') end
        vim.fn.chdir(vim.fs.dirname(path))
    end

    -- Yank in register full path of entry under cursor
    local yank_path = function()
        local path = (mini_files.get_fs_entry() or {}).path
        if path == nil then return vim.notify('Cursor is not on valid entry') end
        vim.fn.setreg(vim.v.register, path)
    end

    -- Open path with system default handler (useful for non-text files)
    local ui_open = function() vim.ui.open(mini_files.get_fs_entry().path) end

    vim.api.nvim_create_autocmd('User', {
        group = mini_files_group,
        pattern = 'MiniFilesBufferCreate',
        callback = function(args)
            local b = args.data.buf_id
            vim.keymap.set('n', 'g~', set_cwd,   { buffer = b, desc = 'Set cwd' })
            vim.keymap.set('n', 'gX', ui_open,   { buffer = b, desc = 'OS open' })
            vim.keymap.set('n', 'gy', yank_path, { buffer = b, desc = 'Yank path' })
        end,
    })
end

configs.mini_misc = function()
    local mini_misc = require("mini.misc")
    mini_misc.setup({
        make_global = { "put", "put_text" }
    })
    mini_misc.setup_restore_cursor()
    mini_misc.setup_termbg_sync()
    mini_misc.setup_auto_root(
        { ".git", ".root" },
        function()
            local clients = vim.lsp.get_clients()
            for _, client in ipairs(clients) do
                if client.config.root_dir then
                    return client.config.root_dir
                end
            end
        end
    )
    require("user.keymaps").set("n", "<C-w>z", mini_misc.zoom)
    require("user.keymaps").set("n", "<C-w><C-z>", mini_misc.zoom)
end

configs.pantran = function()
    require("pantran").setup{
        default_engine = "google",
        engines = {
            google = {
                default_source = "auto",
                default_target = "zh-CN",
                format = "html"
            },
        },
    }
end

return configs
