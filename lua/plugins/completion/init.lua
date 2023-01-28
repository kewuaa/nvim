local configs = require("plugins.completion.configs")

return {
    -- 自动完成
    {
        'hrsh7th/nvim-cmp',
        lazy = true,
        event = {'InsertEnter', 'CmdlineEnter'},
        config = configs.nvim_cmp,
        dependencies = {
            -- ui 美化
            {'onsails/lspkind.nvim'},
            -- lua source
            {'hrsh7th/cmp-nvim-lua'},
            -- underline sort
            {'lukas-reineke/cmp-under-comparator'},
            -- buffer source
            {'hrsh7th/cmp-buffer'},
            -- buffer line source
            {'amarakon/nvim-cmp-buffer-lines'},
            -- path source
            {'hrsh7th/cmp-path'},
            -- cmdline source
            {'hrsh7th/cmp-cmdline'},
        }
    },

    -- snippets
    {
        'L3MON4D3/LuaSnip',
        lazy = true,
        event = 'InsertEnter',
        config = configs.LuaSnip,
        dependencies = {
            {"rafamadriz/friendly-snippets"},
            -- snippets source
            {'saadparwaiz1/cmp_luasnip'},
        },
    },

    -- lsp
    {
        'neovim/nvim-lspconfig',
        lazy = true,
        event = {'BufRead', 'BufNewFile'},
        config = require('lsp').setup,
        dependencies = {
            -- lsp增强
            {'glepnir/lspsaga.nvim', branch = 'main', config = configs.lspsaga},
            -- LSP source
            {'hrsh7th/cmp-nvim-lsp'},
            -- 符号提示
            {'ray-x/lsp_signature.nvim'},
        }
    },
    -- ctags
    {
        'ludovicchabant/vim-gutentags',
        lazy = true,
        event = 'BufReadPre *.pyx,*.pxd,*.pxi',
        config = configs.vim_gutentags,
        dependencies = {
            {'skywind3000/gutentags_plus'},
            -- ctags source
            {'quangnguyen30192/cmp-nvim-tags'},
        }
    },
}
