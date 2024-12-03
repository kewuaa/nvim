local deps = require("deps")
local configs = require("plugins.completion.configs")

---------------------------------------------------------------------------------------------------
---auto completion
---------------------------------------------------------------------------------------------------
local blink_build = function(params)
    vim.notify('Building blink.cmp', vim.log.levels.INFO)
    local obj = vim.system({ 'cargo', 'build', '--release' }, { cwd = params.path }):wait()
    if obj.code == 0 then
        vim.notify('Building blink.cmp done', vim.log.levels.INFO)
    else
        vim.notify('Building blink.cmp failed', vim.log.levels.ERROR)
    end
end
local blink_spec = {
    source = "saghen/blink.cmp",
    lazy_opts = {
        events = {"InsertEnter"},
    },
    hooks = {
        post_install = blink_build,
        post_checkout = blink_build
    },
    config = configs.blink_cmp,
}
if not require("utils").has_cargo then
    blink_spec.hooks = nil
    blink_spec.checkout = "v0.7.1"
end
deps.add(blink_spec)

---------------------------------------------------------------------------------------------------
---lsp support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "neovim/nvim-lspconfig",
    lazy_opts = {
        events = {"BufRead", "BufNewFile"},
        delay = 100,
    },
    config = function()
        configs.nvim_lspconfig()
    end,
    depends = {
        {
            source = "williamboman/mason.nvim",
            config = require("plugins.tools.configs").mason
        },
    }
})

---------------------------------------------------------------------------------------------------
---Cargo.toml support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "saecki/crates.nvim",
    lazy_opts = {
        delay_install = true,
        events = {"BufRead Cargo.toml"}
    },
    config = configs.crates,
})

---------------------------------------------------------------------------------------------------
---ai support
---------------------------------------------------------------------------------------------------
deps.add({
    source = "zbirenbaum/copilot.lua",
    hooks = {
        post_checkout = function()
            vim.cmd("Copilot auth")
        end,
        post_install = function()
            vim.schedule(function()
                vim.cmd("Copilot auth")
            end)
        end
    },
    lazy_opts = {
        cmds = {"Copilot"},
        delay_install = true,
    },
    config = configs.copilot,
})
deps.add({
    source = "luozhiya/fittencode.nvim",
    lazy_opts = {
        cmds = {"Fitten"},
        delay_install = true,
    },
    config = configs.fittencode
})
