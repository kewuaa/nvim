local configs = require("plugins.ui.configs")


return {
    -- 图标
    {
        'kyazdani42/nvim-web-devicons',
        opt = true,
    },

    -- 颜色主题
    {
        'catppuccin/nvim', as = 'catppuccin',
        opt = true,
        event = {'BufReadPre *', 'BufNewFile *'},
        config = configs.catppuccin,
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
        'feline-nvim/feline.nvim',
        opt = true,
        event = 'BufRead *',
        config = configs.feline,
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
        event = 'BufRead *',
        config = configs.fidget,
    },
}
