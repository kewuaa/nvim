local utils = require("utils")
local mini_input = require("mini.input")

utils.on_keys({
    {
        mode = "n",
        lhs = "<leader>dd",
        rhs = function()
            vim.cmd.DiffviewOpen()
        end
    },
    {
        mode = "n",
        lhs = "<leader>pr",
        rhs = function()
            local branch = mini_input.get({
                prompt = "base branch",
                scope = "editor",
                init_keys = { "master" },
            })
            if branch == nil or #branch == 0 then
                return
            end
            vim.cmd.DiffviewOpen({ args = { branch.."..HEAD", "--merge-base" } })
        end
    },
    {
        mode = "n",
        lhs = "<leader>dc",
        rhs = function()
            vim.cmd.DiffviewClose()
        end
    }
} , function()
    vim.cmd.packadd("diffview-plus.nvim")
    require("diffview").setup({
        enhanced_diff_hl = true,
        use_icons = true,
        view = {
            default = { layout = "diff2_horizontal" },
            merge_tool = { layout = "diff3_horizontal" },
        },
        file_panel = {
            listing_style = "tree",
            win_config = { position = "left", width = 35 }, -- Use "auto" to fit content
        },
        hooks = {},   -- See :h diffview-config-hooks
        keymaps = {}, -- See :h diffview-config-keymaps
    })
end)
