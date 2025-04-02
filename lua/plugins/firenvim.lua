local deps = require("deps")


if vim.g.started_by_firenvim ~= true then
    return
end

deps.add({
    source = "glacambre/firenvim",
    hooks = {
        post_install = function()
            vim.cmd[[packadd firenvim | call firenvim#install(0)]]
        end
    }
})

vim.o.laststatus = 0
vim.g.firenvim_config = {
    globalSettings = {
        alt = "all",
        cmdlineTimeout = 3000
    },
    localSettings = {
        [".*"] = {
            cmdline  = "firenvim",
            content  = "text",
            priority = 0,
            selector = "textarea",
            takeover = "never",
            filename = "/tmp/{hostname}_{pathname%10}.{extension}"
        }
    }
}

local firenvim_group = vim.api.nvim_create_augroup("firenvim", { clear = true })
vim.api.nvim_create_autocmd({'BufEnter'}, {
    group = firenvim_group,
    pattern = "github.com_*.txt",
    command = "set filetype=markdown"
})
