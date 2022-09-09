local configs = require("plugins.completion.configs")

return {
        -- lsp增强
        {
            'glepnir/lspsaga.nvim',
            opt = true,
            ft = {
                'python',
                'lua',
                "c",
                "cpp",
                "objc",
                "objcpp",
                "cuda",
                "proto"
            },
            config = configs.lspsaga,
            requires = {
                -- LSP
                {
                    'neovim/nvim-lspconfig',
                    opt = true,
                    after = {'lspsaga.nvim', 'cmp-nvim-lsp', 'lsp_signature.nvim'},
                    config = configs.nvim_lspconfig,
                },
                -- 符号提示
                {
                    'ray-x/lsp_signature.nvim',
                    opt = true,
                },
                -- LSP source
                {
                    'hrsh7th/cmp-nvim-lsp',
                    opt = true,
                },

            },
        },

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
            event = {'BufReadPre *', 'BufNewFile *'},
            config = configs.nvim_cmp,
            requires = {
                -- ui 美化
                {
                    'onsails/lspkind.nvim',
                    opt = true,
                    config = configs.lspkind,
                },
                -- underline sort
                {
                    'lukas-reineke/cmp-under-comparator',
                    opt = true,
                    after = 'nvim-lspconfig',
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
