local configs = require("plugins.completion.configs")

return {
        -- lsp增强
        {
            'glepnir/lspsaga.nvim',
            opt = true,
            ft = {'python'},
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
                    setup = function()
                        require("lsp.hook").add(
                            function(client, bufnr)
                                require("lsp_signature").on_attach({
                                    bind = true,
                                    handler_opts = {
                                        border = "single",
                                    },
                                }, bufnr)
                            end
                        )
                    end,
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
                -- 括号补全
                {
                    'windwp/nvim-autopairs',
                    opt = true,
                    config = configs.nvim_autopairs,
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
        },
}
