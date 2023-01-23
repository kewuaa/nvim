local configs = require("plugins.completion.configs")

return {
    -- lsp增强
    {
        'glepnir/lspsaga.nvim',
        branch = 'main',
        opt = true,
        after = 'nvim-cmp',
        config = configs.lspsaga,
        requires = {
            -- LSP
            {
                'neovim/nvim-lspconfig',
                opt = true,
                after = 'cmp-nvim-lsp',
                config = configs.nvim_lspconfig,
            },
            -- 符号提示
            {
                'ray-x/lsp_signature.nvim',
                opt = true,
                after =  'nvim-lspconfig',
            },
            -- LSP source
            {
                'hrsh7th/cmp-nvim-lsp',
                opt = true,
            },

        },
    },

    -- ctags
    -- {
    --     'ludovicchabant/vim-gutentags',
    --     opt = true,
    --     setup = function()
    --         -- configs.vim_gutentags()
    --         require("plugins.completion.configs").vim_gutentags()
    --         require("plugins").delay_load(
    --             'BufRead',
    --             '*.pyx,*.pxd,*.pxi,*.c,*.h',
    --             1500,
    --             'vim-gutentags'
    --         )
    --     end,
    --     requires = {
    --         {
    --             'skywind3000/gutentags_plus',
    --             opt = true,
    --             setup = configs.gutentags_plus,
    --         }
    --     }
    -- },

    -- snippets
    {
        'rafamadriz/friendly-snippets',
        opt = false,
    },
    {
        'L3MON4D3/LuaSnip',
        opt = true,
        config = configs.LuaSnip,
    },

    -- 括号补全
    {
        'windwp/nvim-autopairs',
        opt = true,
        event = 'InsertEnter *',
        config = configs.nvim_autopairs,
    },

    -- 自动完成
    {
        'hrsh7th/nvim-cmp',
        opt = true,
        after = 'nvim-treesitter',
        config = configs.nvim_cmp, -- will delay load LuaSnip and cmp-cmdline
        requires = {
            -- ui 美化
            {
                'onsails/lspkind.nvim',
                opt = true,
                config = configs.lspkind,
            },
            -- ctags source
            -- {
            --     'quangnguyen30192/cmp-nvim-tags',
            --     opt = true,
            --     after = 'vim-gutentags',
            -- },
            -- underline sort
            {
                'lukas-reineke/cmp-under-comparator',
                opt = true,
                after = 'cmp-nvim-lsp',
                config = configs.cmp_under_comparator,
            },
            -- snippets source
            {
                'saadparwaiz1/cmp_luasnip',
                opt = true,
                after = 'LuaSnip',
                config = configs.cmp_luasnip,
            },
            -- buffer source
            {
                'hrsh7th/cmp-buffer',
                opt = true,
                after = 'cmp_luasnip',
            },
            -- path source
            {
                'hrsh7th/cmp-path',
                opt = true,
                after = 'cmp-buffer',
            },
        }
    },

    -- lua source
    {
        'hrsh7th/cmp-nvim-lua',
        opt = true,
    },

    -- cmdline source
    {
        'hrsh7th/cmp-cmdline',
        opt = true,
        config = configs.cmp_cmdline,
    },
}
