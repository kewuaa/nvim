local utils = require("utils")

utils.on_keys({
    {
        mode = "n",
        lhs = "<leader>sr",
        rhs = function()
            require("grug-far").open()
        end
    },
    {
        mode = { "v", "x" },
        lhs = "<leader>sr",
        rhs = function()
            require("grug-far").with_visual_selection()
        end
    }
}, function()
    vim.cmd.packadd("grug-far.nvim")

    require("grug-far").setup()

    vim.api.nvim_create_autocmd('FileType', {
        group = vim.api.nvim_create_augroup('grug-far-keybindings', { clear = true }),
        pattern = { 'grug-far' },
        callback = function()
            vim.keymap.set('n', '<C-enter>', function()
                local inst = require('grug-far').get_instance(0)
                inst:open_location()
                inst:close()
            end, { buffer = true })
        end,
    })
end)
