local M = {}
local keymap = require("user.keymaps")
local github = "https://github.com/"

local disable_distribution_plugins = function()
    -- disable menu loading
    vim.g.did_install_default_menus = 1
    vim.g.did_install_syntax_menu = 1

    -- Uncomment this if you define your own filetypes in `after/ftplugin`
    -- vim.g.did_load_filetypes = 1

    -- Do not load native syntax completion
    vim.g.loaded_syntax_completion = 1

    -- Do not load spell files
    vim.g.loaded_spellfile_plugin = 1

    -- Whether to load netrw by default
    vim.g.loaded_netrw = 1
    vim.g.loaded_netrwFileHandlers = 1
    vim.g.loaded_netrwPlugin = 1
    vim.g.loaded_netrwSettings = 1
    -- newtrw liststyle: https://medium.com/usevim/the-netrw-style-options-3ebe91d42456
    vim.g.netrw_liststyle = 3

    -- Do not load tohtml.vim
    vim.g.loaded_2html_plugin = 1

    -- Do not load zipPlugin.vim, gzip.vim and tarPlugin.vim (all these plugins are
    -- related to checking files inside compressed files)
    vim.g.loaded_gzip = 1
    vim.g.loaded_tar = 1
    vim.g.loaded_tarPlugin = 1
    vim.g.loaded_vimball = 1
    vim.g.loaded_vimballPlugin = 1
    vim.g.loaded_zip = 1
    vim.g.loaded_zipPlugin = 1

    -- Do not use builtin matchit.vim and matchparen.vim since the use of vim-matchup
    vim.g.loaded_matchit = 1
    vim.g.loaded_matchparen = 1

    -- Disable sql omni completion.
    vim.g.loaded_sql_completion = 1

    -- Disable remote plugins
    -- NOTE: Disabling rplugin.vim will show error for `wilder.nvim` in :checkhealth,
    -- NOTE:  but since it's config doesn't require python rtp, it's fine to ignore.
    -- vim.g.loaded_remote_plugins = 1

    vim.g.loaded_clipboard_provider = 1
    vim.g.loaded_remote_plugins = 1
end

local function load_clipboard()
    vim.api.nvim_del_var('loaded_clipboard_provider')
    vim.cmd(('source %s/autoload/provider/clipboard.vim'):format(vim.env.VIMRUNTIME))
end

local function load_rplugin()
    vim.api.nvim_del_var('loaded_remote_plugins')
    vim.cmd(('source %s/plugin/rplugin.vim'):format(vim.env.VIMRUNTIME))
end

local setup_filetype = function()
    vim.filetype.add({
        extension = {
            pyx = "cython", pxd = "cython",
            pxi = "cython",
            pyxdep = "python",
            pyxbld = "python",
        },
        filename = {
            ["vifmrc"] = "vim",
        },
        pattern = {
            ["%.env%.[%w_.-]+"] = "sh",
        }
    })
end

local selective_load = function(plug_data)
    if (plug_data.spec.data or {}).skip_load then
        return
    end
    vim.cmd.packadd(plug_data.spec.name)
end

local setup_mini_misc = function()
    local mini_misc = require("mini.misc")

    mini_misc.setup({
        make_global = { "put", "put_text" }
    })
    mini_misc.setup_restore_cursor()
    mini_misc.setup_termbg_sync()
    mini_misc.setup_auto_root(
        { ".git", ".root" },
        function()
            local clients = vim.lsp.get_clients()
            for _, client in ipairs(clients) do
                if client.config.root_dir then
                    return client.config.root_dir
                end
            end
        end
    )
    keymap.set("n", "<C-w>z", mini_misc.zoom)
    keymap.set("n", "<C-w><C-z>", mini_misc.zoom)
end

---@type vim.pack.Spec[]
local specs = {
    -- completion
    { src = github.."nvim-mini/mini.fuzzy" },
    { src = github.."nvim-mini/mini.snippets" },
    { src = github.."nvim-mini/mini.completion" },
    { src = github.."nvim-mini/mini.cmdline" },
    { src = github.."saecki/crates.nvim", data = { skip_load = true } },

    -- editor
    { src = github.."nvim-mini/mini.extra" },
    { src = github.."nvim-mini/mini.ai" },
    { src = github.."nvim-mini/mini.align" },
    { src = github.."nvim-mini/mini.bufremove" },
    { src = github.."nvim-mini/mini.cursorword" },
    { src = github.."nvim-mini/mini.surround" },
    { src = github.."nvim-mini/mini.pairs" },
    { src = github.."nvim-mini/mini.splitjoin" },
    { src = github.."utilyre/sentiment.nvim" },

    -- tools
    { src = github.."nvim-mini/mini-git" },
    { src = github.."nvim-mini/mini.diff" },
    { src = github.."nvim-mini/mini.pick" },
    { src = github.."nvim-mini/mini.files" },
    { src = github.."nvim-mini/mini.misc" },
    { src = github.."acidsugarx/babel.nvim", data = { skip_load = true } },
    { src = github.."mason-org/mason.nvim", data = { skip_load = true } },
    { src = github.."kevinhwang91/nvim-bqf", data = { skip_load = true } },
    { src = github.."lambdalisue/vim-suda", data = { skip_load = true } },

    -- ui
    { src = github.."folke/tokyonight.nvim" },
    { src = github.."nvim-mini/mini.icons" },
    { src = github.."nvim-mini/mini.statusline" },
    { src = github.."nvim-mini/mini.indentscope" },
    { src = github.."nvim-mini/mini.notify" },
    { src = github.."kewuaa/nvim-tabline", data = { skip_load = true } },
}

M.init = function()
    setup_filetype()
    disable_distribution_plugins()

    vim.api.nvim_create_autocmd(
        'PackChanged',
        {
            callback = function(ev)
                local name, kind = ev.data.spec.name, ev.data.kind
                vim.notify(name, kind)
                if name == "mason.nvim" and kind == "update" then
                    if not ev.data.active then
                        vim.cmd.packadd("mason.nvim")
                    end
                    vim.cmd("MasonUpdate")
                end
            end
        }
    )
    vim.pack.add(specs, { load = selective_load })

    setup_mini_misc()
    require("mini.misc").safely(
        "later",
        function()
            load_rplugin()
            load_clipboard()
            for name, type in vim.fs.dir(vim.fn.stdpath("config").."/lua/plugins/configs") do
                if type == "file" then
                    require("plugins.configs."..vim.fn.fnamemodify(name, ":t:r"))
                end
            end
        end
    )
end

return M
