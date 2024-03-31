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
            api.nvim_create_autocmd({'BufNewFile', 'BufRead'}, {
                -- pattern = [[*\(.pyx\|.pxd\|.pxi\)\@<!]],
                desc = "delay load nvim-lspconfig",
                once = true,
                callback = function()
                    vim.fn.timer_start(100, function()
                        require("lazy").load({plugins = {"nvim-lspconfig"}})
                    end)
                end
            })
        end,
        -- event = {'BufRead', 'BufNewFile'},
        config = configs.nvim_lspconfig,
        dependencies = {
            -- lsp 增强
            {'glepnir/lspsaga.nvim', branch = 'main', config = configs.lspsaga},
            -- lua 增强
            {'folke/neodev.nvim', config = configs.neodev},
            -- Cargo.toml 支持
            { 'saecki/crates.nvim', config = configs.crates },
            -- 符号提示
            {'ray-x/lsp_signature.nvim'},
        }
    },

    -- copilot support
    {
        'zbirenbaum/copilot.lua',
        lazy = true,
        cmd = "Copilot",
        build = ":Copilot auth",
        -- event = "InsertEnter",
        config = configs.copilot,
    }
}
