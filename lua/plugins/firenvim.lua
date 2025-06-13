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
            priority = 1,
            selector = "textarea",
            takeover = "never",
            filename = "/tmp/{hostname}_{pathname%10}.{extension}"
        },
        ["leetcode.cn"] = {
            filename = "/tmp/{hostname}_{pathname%10}.cpp"
        },
    }
}

local firenvim_group = vim.api.nvim_create_augroup("firenvim", { clear = true })
vim.api.nvim_create_autocmd('BufRead', {
    group = firenvim_group,
    pattern = "github.com_*.txt",
    callback = function(arg)
        local buf_name = arg.file
        if buf_name:match("github.com_*.txt") then
            vim.bo.filetype = "markdown"
        end
    end
})
