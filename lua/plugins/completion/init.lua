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
            -- snippets
            {
                'L3MON4D3/LuaSnip',
                config = configs.LuaSnip,
            },
            -- LSP source
            {'hrsh7th/cmp-nvim-lsp'},
            -- snippets source
            {'saadparwaiz1/cmp_luasnip'},
            -- underline sort
            {'lukas-reineke/cmp-under-comparator'},
            -- buffer source
            {'hrsh7th/cmp-buffer'},
            -- cmdline source
            {'hrsh7th/cmp-cmdline'},
            -- latex symbol source
            {'kdheepak/cmp-latex-symbols'},
            -- bibliography cite source
            -- {'jc-doyle/cmp-pandoc-references'},
            {
                'aspeddro/cmp-pandoc.nvim',
                config = configs.cmp_pandoc,
                dependencies = {
                    {'nvim-lua/plenary.nvim'},
                },
            },
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
                -- pattern = [[*\(.pyx\|.pxd\|.pxi\)\@<!]],
                callback = function()
                    vim.fn.timer_start(100, function()
                        require("lazy").load({plugins = {"nvim-lspconfig"}})
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
            {'williamboman/mason-lspconfig.nvim', config = configs.mason_lspconfig},
            -- csharp extended
            -- {"Decodetalkers/csharpls-extended-lsp.nvim"},
            {"Hoffs/omnisharp-extended-lsp.nvim"},
        }
    },

    -- copilot support
    {
        'zbirenbaum/copilot.lua',
        cmd = "Copilot",
        build = ":Copilot auth",
        event = "InsertEnter",
        config = configs.copilot,
    }
}
