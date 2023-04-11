local configs = {}


configs.filetype = function()
    require('filetype').setup({
        overrides = {
            extensions = {
                zig = 'zig',
                zir = 'zig',
            }
        }
    })
end

configs.nvim_treesitter = function()
    require('nvim-treesitter.configs').setup({
        ensure_installed = {
            'python',
            'c',
            'cpp',
            'make',
            'cmake',
            'zig',
            'lua',
            'vim',
            'javascript',
            'typescript',
            'ini',
            'markdown',
            'markdown_inline',
            'json',
            'vimdoc',
            'gitignore',
            'yaml',
            'toml',
        },
        highlight = {
            enable = true,
            additional_vim_regex_highlighting = { "c", "cpp" },
            ---@diagnostic disable-next-line: unused-local
            disable = function(lang, bufnr)
                local size = require('core.utils').get_bufsize(bufnr)
                if size > 512 then
                    local ok1, illuminate = pcall(require, 'illuminate.engine')
                    if ok1 then
                        illuminate.stop_buf(bufnr)
                    end
                    local ok2, indent_blankline = pcall(require, 'indent_blankline.commands')
                    if ok2 then
                        indent_blankline.disable()
                    end
                    vim.b.miniindentscope_disable = true
                    return true
                end
            end,
        },
        incremental_selection = {
            enable = true,
            keymaps = {
                init_selection = "+", -- set to `false` to disable one of the mappings
                node_incremental = "+",
                scope_incremental = false,
                node_decremental = "_",
            },
        },
        textobjects = {
            select = {
                enable = true,
                keymaps = {
                    ["af"] = "@function.outer",
                    ["if"] = "@function.inner",
                    ["ac"] = "@class.outer",
                    ["ic"] = "@class.inner",
                },
            },
            move = {
                enable = true,
                set_jumps = true, -- whether to set jumps in the jumplist
                goto_next_start = {
                    ["]["] = "@function.outer",
                    ["]m"] = "@class.outer",
                },
                goto_next_end = {
                    ["]]"] = "@function.outer",
                    ["]M"] = "@class.outer",
                },
                goto_previous_start = {
                    ["[["] = "@function.outer",
                    ["[m"] = "@class.outer",
                },
                goto_previous_end = {
                    ["[]"] = "@function.outer",
                    ["[M"] = "@class.outer",
                },
            },
            swap = {
                enable = false,
                swap_next = {
                    ["<leader>s"] = "@parameter.inner",
                },
                swap_previous = {
                    ["<leader>S"] = "@parameter.inner",
                },
            },
        },
        indent = {
            enable = true,
        },
        rainbow = {
            enable = true,
            -- disable = { "jsx", "cpp" }, list of languages you want to disable the plugin for
            extended_mode = true, -- Also highlight non-bracket delimiters like html tags, boolean or table: lang -> boolean
            max_file_lines = 2000, -- Do not enable for files with more than n lines, int
        },
    })
    -- vim.api.nvim_create_autocmd({'BufEnter','BufAdd','BufNew','BufNewFile','BufWinEnter'}, {
    --     group = vim.api.nvim_create_augroup('TS_FOLD_WORKAROUND', {}),
    --     callback = function()
    --         vim.opt.foldmethod     = 'expr'
    --         vim.opt.foldexpr       = 'nvim_treesitter#foldexpr()'
    --     end
    -- })
    local ts_repeat_move = require "nvim-treesitter.textobjects.repeatable_move"
    local map = vim.keymap.set
    -- Repeat movement with ; and ,
    -- ensure ; goes forward and , goes backward regardless of the last direction
    -- map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move_next)
    -- map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_previous)

    -- vim way: ; goes to the direction you were moving.
    map({ "n", "x", "o" }, ";", ts_repeat_move.repeat_last_move)
    map({ "n", "x", "o" }, ",", ts_repeat_move.repeat_last_move_opposite)

    -- Optionally, make builtin f, F, t, T also repeatable with ; and ,
    map({ "n", "x", "o" }, "f", ts_repeat_move.builtin_f)
    map({ "n", "x", "o" }, "F", ts_repeat_move.builtin_F)
    map({ "n", "x", "o" }, "t", ts_repeat_move.builtin_t)
    map({ "n", "x", "o" }, "T", ts_repeat_move.builtin_T)
end

configs.hlargs = function()
    require("hlargs").setup({
        excluded_filetypes = require("core.settings").exclude_filetypes,
    })
end

configs.nvim_lint = function()
    local lint = require('lint')
    local pattern = '[^:]+:(%d+):(%d+):(.+)'
    local groups = {'lnum', 'col', 'message'}
    lint.linters.cython_lint = {
        cmd = 'cython-lint',
        stdin = true,
        args = {
            '--max-line-length=80',
            function()
                local name = vim.api.nvim_buf_get_name(0)
                return name
            end,
        },
        ignore_exitcode = true,
        parser = require('lint.parser').from_pattern(pattern, groups, nil, {
            source = 'cython-lint'
        }),
    }
    lint.linters_by_ft = {
        pyrex = {'cython_lint'},
    }
    vim.api.nvim_create_autocmd({"BufRead", "BufWritePost"}, {
        callback = function()
            lint.try_lint()
        end,
    })
    lint.try_lint()
end

return configs
