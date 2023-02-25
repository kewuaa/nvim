local configs = require("plugins.completion.configs")

return {
    -- 自动完成
    {
        'hrsh7th/nvim-cmp',
        lazy = true,
        event = 'InsertEnter',
        config = configs.nvim_cmp,
        dependencies = {
            -- ui 美化
            {'onsails/lspkind.nvim'},
            -- snippets
            {
                'L3MON4D3/LuaSnip',
                config = configs.LuaSnip,
                dependencies = {"rafamadriz/friendly-snippets"},
            },
            -- LSP source
            {'hrsh7th/cmp-nvim-lsp'},
            -- ctags source
            {'quangnguyen30192/cmp-nvim-tags'},
            -- snippets source
            {'saadparwaiz1/cmp_luasnip'},
            -- underline sort
            {'lukas-reineke/cmp-under-comparator'},
            -- buffer source
            {'hrsh7th/cmp-buffer'},
            -- path source
            {'hrsh7th/cmp-path'},
        }
    },

    -- lsp
    {
        'neovim/nvim-lspconfig',
        lazy = true,
        init = function()
            local api = vim.api
            local init_group = api.nvim_create_augroup('init_lsp', {
                clear = true,
            })
            api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
                group = init_group,
                pattern = [[*\(.pyx\|.pxd\|.pxi\)\@<!]],
                callback = function()
                    vim.fn.timer_start(600, function()
                        api.nvim_command [[Lazy load nvim-lspconfig]]
                    end)
                    api.nvim_del_augroup_by_name('init_lsp')
                end
            })
        end,
        -- event = {'BufRead', 'BufNewFile'},
        config = configs.nvim_lspconfig,
        dependencies = {
            -- lsp增强
            {'glepnir/lspsaga.nvim', branch = 'main', config = configs.lspsaga},
            -- lua增强
            {'folke/neodev.nvim', config = configs.neodev},
            -- 符号提示
            {'ray-x/lsp_signature.nvim'},
        }
    },


    -- ctags
    {
        'ludovicchabant/vim-gutentags',
        lazy = true,
        init = function()
            vim.api.nvim_create_autocmd('FileType', {
                pattern = 'pyrex',
                once = true,
                callback = function()
                    vim.fn.timer_start(
                        600,
                        function()
                            configs.vim_gutentags()
                            vim.api.nvim_command [[Lazy load vim-gutentags]]
                        end
                    )
                end
            })
        end,
        dependencies = {
            {'skywind3000/gutentags_plus'},
        }
    },
}
