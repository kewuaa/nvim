local fn = vim.fn
local install_path = fn.stdpath('data')..'/site/pack/packer/start/packer.nvim'
if fn.empty(fn.glob(install_path)) > 0 then
  packer_bootstrap = fn.system({'git', 'clone', '--depth', '1', 'https://github.com/wbthomason/packer.nvim', install_path})
  vim.cmd [[packadd packer.nvim]]
end

vim.cmd [[
    augroup packer_user_config
        autocmd!
        autocmd BufWritePost plugins.lua source <afile> | PackerSync
    augroup end
]]

return require('packer').startup({
    function()
        -- Packer can manage itself
        use 'wbthomason/packer.nvim'

        -- filetype
        use "nathom/filetype.nvim"

        -- 语法高亮
        use {
            'nvim-treesitter/nvim-treesitter',
            opt = true,
            run = ':TSUpdate',
            event = {'BufNewFile *', 'BufReadPre *'},
            cmd = {'TSInstall', 'TSInstallInfo', 'TsEnable'},
            config = function()
                require('plugin-configs.nvim-treesitter').config()
            end,
            requires = {
                {'p00f/nvim-ts-rainbow', opt = true},
            },
        }

        -- LSP
        use {
            "neovim/nvim-lspconfig",
            opt = true,
            ft = {'python'},
            config = function()
                require('lsp.setup') 
            end,
        }

        -- 自动完成
        use {
            'hrsh7th/nvim-cmp',
            opt = true,
            event = {'InsertEnter *'},
            config = function()
                require('plugin-configs.nvim-cmp').config()
            end,
        }

        -- cmp ui improve
        use {
            'onsails/lspkind-nvim',
            opt = true,
        }

        -- LSP source
        use {
            'hrsh7th/cmp-nvim-lsp',
            opt = true,
        }

        -- buffer source
        use {
            'hrsh7th/cmp-buffer',
            opt = true,
            event = {'InsertCharPre *'},
        }

        -- path source
        use {
            'hrsh7th/cmp-path',
            opt = true,
            event = {'InsertCharPre *'},
        }

        -- 异步任务系统
        use {
            'skywind3000/asynctasks.vim',
            opt = true,
            cmd = {'AsyncTask', 'AsyncTaskEdit', 'AsyncTaskList', 'AsyncTaskMacro'},
            setup = function()
                require('plugin-configs.asynctasks').setup()
            end,
            -- 异步运行
            requires = {
                {'skywind3000/asyncrun.vim', opt = true},
            },
        }

        -- git集成
        use {
             'lewis6991/gitsigns.nvim',
             opt = true,
             event = {'BufEnter *'},
             config = function()
                 require('plugin-configs.gitsigns').config()
             end,
        }

        -- 选中编辑
        use {
            'machakann/vim-sandwich',
            opt = true,
            keys = {{'n', '<c-s>a'}, {'x', '<c-s>a'}, {'o', '<c-s>a'},
                    {'n', '<c-s>d'}, {'x', '<c-s>d'}, {'n', '<c-s>db'},
                    {'n', '<c-s>r'}, {'x', '<c-s>r'}, {'n', '<c-s>rb'}},
            setup = function()
                require('plugin-configs.vim-sandwich').setup()
            end,
            config = function()
                require('plugin-configs.vim-sandwich').config()
            end,
        }

        -- 多光标
        use {
            'mg979/vim-visual-multi',
            opt = true,
            keys = {{'n', '<c-d>'}, {'x', '<c-d>'}, {'n', '<C-Up>'}, {'n', '<C-Down>'}},
            setup = function()
                require('plugin-configs.vim-visual-multi').setup()
            end,
            config = function()
                require('plugin-configs.vim-visual-multi').config()
            end,
        }

        -- 扩展区域
        use {
            'terryma/vim-expand-region',
            opt = true,
            keys = {{'n', '+'}, {'v', '+'}, {'v', '-'}},
        }

        -- 括号补全
        use {
            'windwp/nvim-autopairs',
            opt = true,
            event = {'InsertEnter *'},
            config = function()
                require('plugin-configs.nvim-autopairs').config()
            end,
        }

        -- terminal help
        use {
            'skywind3000/vim-terminal-help',
            opt = true,
            keys = {{'n', '<M-=>'}},
            setup = function()
                require('plugin-configs.vim-terminal-help').setup()
            end,
        }

        -- 缩进线
        use {
            'lukas-reineke/indent-blankline.nvim',
            opt = true,
            event = {'BufEnter *'},
            config = function()
                require('plugin-configs.indent-blankline').config()
            end,
        }

        -- 颜色主题
        use {
            'tomasr/molokai',
            config = 'vim.cmd [[colorscheme molokai]]',
        }
    end,

    config = {
        display = {
            open_fn = function()
                return require('packer.util').float({ border = 'single' })
            end
        }
    }
})
