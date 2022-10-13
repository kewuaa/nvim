local configs = require("plugins.ui.configs")


return {

    -- 颜色主题
    {
        'sainnhe/sonokai',
        opt = true,
        event = 'BufRead *',
        config = configs.sonokai,
    },

    -- 缩进线
    {
        'lukas-reineke/indent-blankline.nvim',
        opt = true,
        after = 'nvim-treesitter',
        config = configs.indent_blankline,
    },

    -- statusline
    {
        'nvim-lualine/lualine.nvim',
        opt = true,
        after = 'sonokai',
        config = configs.lualine,
        requires = {
            {
                'kyazdani42/nvim-web-devicons',
                opt = true,
            }
        }
    },

    -- 增强vim.ui
    {
        'stevearc/dressing.nvim',
        opt = true,
        after = 'nvim-notify',
        config = configs.dressing,
    },

    -- 消息提示
    {
        'rcarriga/nvim-notify',
        opt = true,
        after = 'nvim-treesitter',
        config = configs.notify,
    },

    -- lsp progress
    {
        'j-hui/fidget.nvim',
        opt = true,
        event = 'LspAttach',
        config = configs.fidget,
    },
}
