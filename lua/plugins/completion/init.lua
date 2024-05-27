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
            -- LSP source
            {'hrsh7th/cmp-nvim-lsp'},
            -- underline sort
            {'lukas-reineke/cmp-under-comparator'},
            -- buffer source
            {'hrsh7th/cmp-buffer'},
            -- cmdline source
            {'hrsh7th/cmp-cmdline'},
            -- path source
            {'hrsh7th/cmp-path'},
        }
    },
    -- snippets
    {
        'garymjr/nvim-snippets',
        lazy = true,
        event = "InsertEnter",
        config = configs.snippets,
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
            -- lua 增强
            {'folke/neodev.nvim', config = configs.neodev},
        }
    },

    -- Cargo.toml 支持
    {
        'saecki/crates.nvim',
        lazy = true,
        event = "BufRead Cargo.toml",
        config = configs.crates,
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
