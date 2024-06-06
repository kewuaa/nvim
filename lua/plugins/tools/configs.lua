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

configs.mini_pick = function()
    require("mini.pick").setup({
        -- Keys for performing actions. See `:h MiniPick-actions`.
        mappings = {
            caret_left  = '<Left>',
            caret_right = '<Right>',

            choose            = '<CR>',
            choose_in_split   = '<C-x>',
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

            scroll_down  = '<C-f>',
            scroll_left  = '<C-,>',
            scroll_right = '<C-.>',
            scroll_up    = '<C-b>',

            stop = '<Esc>',

            toggle_info    = '<S-Tab>',
            toggle_preview = '<Tab>',
        },
    })
end

configs.nvim_dap = function()
    local dap = require('dap')
    local utils = require("core.utils")
    local mason_utils = require("core.utils.mason")
    -- config for python
    mason_utils.ensure_install("debugpy")
    dap.adapters.python = {
        type = 'executable',
        command = "debugpy-adapter",
    }
    dap.configurations.python = {
        {
            -- The first three options are required by nvim-dap
            type = 'python', -- the type here established the link to the adapter definition: `dap.adapters.python`
            request = 'launch',
            name = "Launch file",

            -- Options below are for debugpy, see https://github.com/microsoft/debugpy/wiki/Debug-configuration-settings for supported options

            cwd = utils.get_cwd,
            program = function()
                local lsp = vim.lsp.get_clients({bufnr = 0})[1]
                local root = lsp.config.root_dir
                if root ~= nil then
                    return ("%s/main.py"):format(root)
                end
                return "${file}"
            end, -- This configuration will launch the current file if used.
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
            end,
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
            detached = utils.is_win and false or true,
        },
    }
    local program_for_c = function()
        local lsp = vim.lsp.get_clients({bufnr = 0})[1]
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

    require("core.autocmds").register_quick_quit("dap-float")
end

configs.asynctasks = function()
    local utils = require("core.utils")
    vim.g.asyncrun_save = 2
    vim.g.asyncrun_open = 10
    vim.g.asyncrun_rootmarks = {".git", ".tasks", ".root"}
    vim.g.asynctasks_term_focus = 1
    vim.g.asynctasks_template = 1
    vim.g.asynctasks_confirm = 0
    if utils.is_win then
        vim.g.asynctasks_term_pos = 'external'
        vim.g.asynctasks_environ = {
            exe_suffix = '.exe',
        }
    elseif utils.is_linux then
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
            add = { text = "▎" },
            change = { text = "▎" },
            delete = { text = "" },
            topdelete = { text = "" },
            changedelete = { text = "▎" },
            untracked = { text = "▎" },
        },
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

configs.mini_files = function()
    local mini_files = require("mini.files")
    mini_files.setup()

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
            vim.api.nvim_win_call(mini_files.get_target_window(), function()
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
            map_split(buf_id, '<C-x>', 'belowright horizontal')
            map_split(buf_id, '<C-v>', 'belowright vertical')
        end,
    })
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
