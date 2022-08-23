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
        use 'nathom/filetype.nvim'

        -- 启动时间
        use {
            'dstein64/vim-startuptime',
            opt = true,
            cmd = {'StartupTime'},
        }

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
            'neovim/nvim-lspconfig',
            opt = true,
            ft = {'python'},
            config = function()
                -- 加载依赖
                vim.cmd [[
                    exe 'PackerLoad cmp-nvim-lsp lsp_signature.nvim'
                ]]
                require('lsp.setup') 
            end,
        }

        -- 符号提示
        use {
            'ray-x/lsp_signature.nvim',
            opt = true,
        }

        -- snippets
        use {
            'L3MON4D3/LuaSnip',
            opt = true,
            config = function()
                require("luasnip").config.set_config({ history = true, updateevents = "TextChanged,TextChangedI" })
                require("luasnip.loaders.from_vscode").lazy_load()
            end,
            requires = {
                {'rafamadriz/friendly-snippets', opt = true}
            }
        }

        -- 自动完成
        use {
            'hrsh7th/nvim-cmp',
            opt = true,
            event = 'InsertEnter *',
            config = function()
                -- 加载依赖
                vim.cmd [[
                    exe 'PackerLoad LuaSnip'
                ]]
                require('plugin-configs.nvim-cmp').config()

                if vim.api.nvim_eval('&ft') == 'lua' then
                    vim.cmd [[exe 'PackerLoad cmp-nvim-lua']]
                else
                    vim.cmd [[
                        au packer_load_aucmds FileType lua ++once lua require("packer.load")({'cmp-nvim-lua'}, { ft = "lua" }, _G.packer_plugins)
                    ]]
                end
            end,
            requires = {
                -- 括号补全
                {
                    'windwp/nvim-autopairs',
                    opt = true,
                    config = function()
                        require('plugin-configs.nvim-autopairs').config()
                    end,
                },
                -- snippets source
                {
                    'saadparwaiz1/cmp_luasnip',
                    opt = true,
                    after = 'LuaSnip',
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
        }

        -- LSP source
        use {
            'hrsh7th/cmp-nvim-lsp',
            opt = true,
        }

        -- lua source
        use {
            'hrsh7th/cmp-nvim-lua',
            opt = true,
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
             event = 'BufRead *',
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
            event = 'BufRead *',
            config = function()
                require('plugin-configs.indent-blankline').config()
            end,
        }

        -- 颜色主题
        use {
            'tomasr/molokai',
            opt = true,
            event = {'BufNewFile *', 'BufReadPre *'},
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
