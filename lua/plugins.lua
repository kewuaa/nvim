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

        -- snippets
        use 'rafamadriz/friendly-snippets'

        -- 异步依赖
        use {
            'nvim-lua/plenary.nvim',
            opt = true,
        }

        -- 启动时间
        use {
            'dstein64/vim-startuptime',
            opt = true,
            cmd = 'StartupTime',
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

        -- 缩进线
        use {
            'lukas-reineke/indent-blankline.nvim',
            opt = true,
            event = 'BufRead *',
            config = function()
                require('plugin-configs.indent-blankline').config()
            end,
        }

        -- LSP
        use {
            'neovim/nvim-lspconfig',
            opt = true,
            ft = {'python'},
            config = function()
                -- -- 加载依赖
                vim.cmd [[exe 'PackerLoad cmp-nvim-lsp lsp_signature.nvim']]
                require('lsp').setup()
            end,
            requires = {
                {
                    'glepnir/lspsaga.nvim',
                    opt = true,
                    config = function()
                        require("lsp.ui").setup()
                    end,
                },
            }
        }

        -- 符号提示
        use {
            'ray-x/lsp_signature.nvim',
            opt = true,
            setup = function()
                require("plugin-configs.lsp_signature").setup()
            end,
        }

        -- 显示代码错误
        use {
            'folke/trouble.nvim',
            opt = true,
            cmd = 'Trouble',
            setup = function()
                require("plugin-configs.trouble").setup()
            end,
            config = function()
                require("plugin-configs.trouble").config()
            end,
            requires = {
                {'kyazdani42/nvim-web-devicons', opt = true},
            }
        }

        -- symbols tree
        use {
            'simrat39/symbols-outline.nvim',
            opt = true,
            cmd = 'SymbolsOutline',
            setup = function()
                require('plugin-configs.symbols-outline').setup()
            end,
            config = function()
                require('plugin-configs.symbols-outline').config()
            end,
        }

        -- 查找
        use {
            'nvim-telescope/telescope.nvim',
            tag = '0.1.0',
            opt = true,
            cmd = 'Telescope',
            setup = function()
                require('plugin-configs.telescope').setup()
            end,
            config = function()
                vim.cmd [[exe 'PackerLoad plenary.nvim telescope-fzf-native.nvim']]
                require('plugin-configs.telescope').config()
            end,
            requires = {
                {'kyazdani42/nvim-web-devicons', opt = true},
            }
        }
        -- fzf支持
        use {
            'nvim-telescope/telescope-fzf-native.nvim',
            run = 'make',
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
        }

        -- 自动完成
        use {
            'hrsh7th/nvim-cmp',
            opt = true,
            event = 'InsertEnter *',
            config = function()
                -- 加载依赖
                vim.cmd [[exe 'PackerLoad LuaSnip']]
                require('plugin-configs.nvim-cmp').config()
                if vim.o.ft == 'lua' then
                    vim.cmd [[exe 'PackerLoad cmp-nvim-lua']]
                else
                    vim.api.nvim_create_autocmd('FileType', {
                        group = 'packer_load_aucmds',
                        pattern = 'lua',
                        once = true,
                        command = [[lua require('packer.load')({'cmp-nvim-lua'}, { ft = "lua" }, _G.packer_plugins)]],
                    })
                end
            end,
            requires = {
                -- ui 美化
                {
                    'onsails/lspkind.nvim',
                    opt = true,
                    config = function()
                        require('plugin-configs.lspkind').config()
                    end,
                },
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
        -- git显示
        use {
             'lewis6991/gitsigns.nvim',
             opt = true,
             event = 'BufRead *',
             config = function()
                 require('plugin-configs.gitsigns').config()
             end,
        }
        -- git命令
        use {
            'tpope/vim-fugitive',
            opt = true,
            cmd = {'Git', 'G'},
        }

        -- 文件树
        use {
            'kyazdani42/nvim-tree.lua',
            opt = true,
            cmd = 'NvimTreeToggle',
            setup = function()
                require('plugin-configs.nvim-tree').setup()
            end,
            config = function()
                require('plugin-configs.nvim-tree').config()
            end,
            requires = {
                {'kyazdani42/nvim-web-devicons', opt = true}
            },
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
            keys = {
                {'n', '<c-d>'},
                {'x', '<c-d>'},
                {'n', '<C-Up>'},
                {'n', '<C-Down>'}
            },
            setup = function()
                require('plugin-configs.vim-visual-multi').setup()
            end,
            config = function()
                require('plugin-configs.vim-visual-multi').config()
            end,
        }

        -- 快速移动
        use {
            'phaazon/hop.nvim',
            opt = true,
            branch = 'v2',
            cmd = {
                'HopWord',
                'HopChar1',
                'HopChar2',
                'HopLine',
                'HopPattern',
            },
            setup = function()
                require('plugin-configs.hop').setup()
            end,
            config = function()
                require('plugin-configs.hop').config()
            end,
        }

        -- 注释
        use {
            'terrortylor/nvim-comment',
            opt = true,
            keys = {
                {'n', 'gcc'},
                {'n', 'gc'},
                {'v', 'gc'},
            },
            config = function()
                require('plugin-configs.nvim-comment').config()
            end,
        }

        -- 扩展区域
        use {
            'terryma/vim-expand-region',
            opt = true,
            keys = {{'n', '+'}, {'v', '+'}, {'v', '-'}},
        }

        -- 高亮相同单词
        use {
            'RRethy/vim-illuminate',
            opt = true,
            cmd = 'IlluminateResumeBuf',
            setup = function()
                require('plugin-configs.vim-illuminate').setup()
            end,
            config = function()
                require('plugin-configs.vim-illuminate').config()
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

        -- jk增强
        use {
            'rainbowhxch/accelerated-jk.nvim',
            opt = true,
            keys = {{'n', 'j'}, {'n', 'k'}},
            config = function()
                require('plugin-configs.accelerated-jk').config()
            end,
        }

        -- f/F, t/T增强
        use {
            'hrsh7th/vim-eft',
            opt = true,
            keys = {
                {'n', ';'},
                {'x', ';'},
                {'o', ';'},
                {'n', 'f'},
                {'x', 'f'},
                {'o', 'f'},
                {'n', 'F'},
                {'x', 'F'},
                {'o', 'F'},
                {'n', 't'},
                {'x', 't'},
                {'o', 't'},
                {'n', 'T'},
                {'x', 'T'},
                {'o', 'T'},
            },
            setup = function()
                require('plugin-configs.vim-eft').setup()
            end,
            config = function()
                require('plugin-configs.vim-eft').config()
            end,
        }

        -- 搜索后自动关闭高亮
        use {
            'romainl/vim-cool',
            opt = true,
            event = 'CmdLineEnter /',
            keys = {
                {'n', 'n'},
                {'n', 'N'},
            },
            setup = 'vim.g.CoolTotalMatches = 1',
            requires = {
                -- 光标移动时突出显示
                {
                    'edluffy/specs.nvim',
                    opt = true,
                    keys = {
                        {'n', '<C-F>'},
                        {'n', '<C-B>'},
                        {'n', '<C-W>'},
                    },
                    config = function()
                        require("plugin-configs.specs").config()
                    end,
                },
            }
        }

        -- 缓冲区关闭时保留原有布局
        use {
            'famiu/bufdelete.nvim',
            opt = true,
            cmd = 'Bdelete',
            setup = 'vim.api.nvim_set_keymap("n", "<leader>bd", ":Bdelete<CR>", {noremap = true, silent = true})',
        }

        -- 缓冲区管理
        use {
            'matbme/JABS.nvim',
            opt = true,
            cmd = 'JABSOpen',
            setup = function()
                require('plugin-configs.JABS').setup()
            end,
            config = function()
                require('plugin-configs.JABS').config()
            end,
            requires = {
                {'kyazdani42/nvim-web-devicons', opt = true},
            }
        }

        -- 颜色主题
        use {
            'rafamadriz/neon',
            opt = true,
            event = {'BufNewFile *', 'BufReadPre *'},
            setup = function()
                require('plugin-configs.neon').setup()
            end,
            config = 'vim.cmd [[colorscheme neon]]',
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
