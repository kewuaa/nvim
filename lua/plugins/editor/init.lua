local configs = require("plugins.editor.configs")


return {
    -- 选中编辑
    {
        'echasnovski/mini.surround',
        version = false,
        lazy = true,
        keys = {
            {'<leader>as', mode = {'n', 'x'}},
            {'<leader>ds', mode = 'n'},
            {'<leader>cs', mode = 'n'},
            {'<leader>fs', mode = {'n', 'o'}},
            {'<leader>Fs', mode = {'n', 'o'}},
            {'<leader>sh', mode = 'n'},
        },
        config = configs.mini_surround,
    },

    -- enhance textobject
    {
        'echasnovski/mini.ai',
        version = false,
        lazy = true,
        event = "VeryLazy",
        config = configs.mini_ai,
        dependencies = {
            {
                'nvim-treesitter/nvim-treesitter-textobjects',
                init = function()
                    -- disable rtp plugin, as we only need its queries for mini.ai
                    -- In case other textobject modules are enabled, we will load them
                    -- once nvim-treesitter is loaded
                    require("lazy.core.loader").disable_rtp_plugin("nvim-treesitter-textobjects")
                    load_textobjects = true
                end
            },
        }
    },

    -- 高亮相同单词
    {
        'RRethy/vim-illuminate',
        lazy = true,
        event = 'CursorHold',
        config = configs.vim_illuminate,
    },

    -- 括号补全
    {
        'm4xshen/autoclose.nvim',
        lazy = true,
        event = 'InsertEnter',
        config = configs.autoclose,
    },

    -- 注释
    {
        'echasnovski/mini.comment',
        lazy = true,
        keys = {
            {'gcc', mode = 'n'},
            {'gc', mode = {'n', 'x'}},
        },
        config = configs.mini_comment,
        dependencies = {
            {
                'JoosepAlviste/nvim-ts-context-commentstring',
                opts = {enable_autocmd = false}
            }
        }
    },

    -- TODO 注释
    {
        'folke/todo-comments.nvim',
        lazy = true,
        init = require('core.keymaps'):load('todo_comments'),
        cmd = {
            'TodoQuickFix',
            'TodoLocList',
            'TodoTrouble',
            'TodoTelescope',
        },
        config = true,
        dependencies = {
            {'nvim-lua/plenary.nvim'},
        }
    },

    -- 与J相反的操作
    {
        'Wansmer/treesj',
        lazy = true,
        keys = {
            {'<leader>j', mode = 'n'}
        },
        config = configs.treesj,
    },
    {
        'echasnovski/mini.splitjoin',
        version = false,
        lazy = true,
        config = configs.mini_splitjoin,
    },

    -- 交换函数参数, 列表元素等
    {
        'mizlan/iswap.nvim',
        lazy = true,
        keys = {
            {'<leader>sp', '<cmd>ISwapWith<CR>', mode = 'n'}
        },
        config = configs.iswap,
    },

    -- jk增强
    {
        'rainbowhxch/accelerated-jk.nvim',
        lazy = true,
        keys = {
            {'j', mode = 'n'},
            {'k', mode = 'n'},
        },
        config = configs.accelerated_jk,
    },

    -- f, F, t, T 增强
    {
        'jinh0/eyeliner.nvim',
        lazy = true,
        keys = {
            {'f', mode = {'n', 'x', 'o'}},
            {'F', mode = {'n', 'x', 'o'}},
            {'t', mode = {'n', 'x', 'o'}},
            {'T', mode = {'n', 'x', 'o'}},
        },
        config = configs.eyeliner,
    },

    -- match enhance
    {
        'utilyre/sentiment.nvim',
        version = '*',
        lazy = true,
        event = 'CursorHold',
        config = configs.sentiment,
    },

    -- 搜索后自动关闭高亮
    {
        'romainl/vim-cool',
        lazy = true,
        event = 'CursorMoved',
    },

    --  peeks lines of the buffer in non-obtrusive way
    {
        'nacro90/numb.nvim',
        lazy = true,
        event = 'CmdLineEnter :',
        config = configs.numb,
    },

    -- 缓冲区关闭时保留原有布局
    {
        'echasnovski/mini.bufremove',
        lazy = true,
        keys = {
            { "<leader>bd", function() require("mini.bufremove").delete(0, false) end, desc = "Delete Buffer" },
            { "<leader>bD", function() require("mini.bufremove").delete(0, true) end, desc = "Delete Buffer (Force)" },
        },
    },
}
