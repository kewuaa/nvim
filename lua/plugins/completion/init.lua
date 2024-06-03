local configs = require("plugins.completion.configs")

return {
    -- 自动完成
    {
        'hrsh7th/nvim-cmp',
        lazy = true,
        event = {'InsertEnter', 'CmdlineEnter'},
        config = configs.nvim_cmp,
        dependencies = {
            -- LSP source
            {'hrsh7th/cmp-nvim-lsp'},
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
        -- event = {'BufRead', 'BufNewFile'},
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
        config = configs.nvim_lspconfig,
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
        build = ":Copilot auth",
        lazy = true,
        cmd = "Copilot",
        -- event = "InsertEnter",
        config = configs.copilot,
    }
}
