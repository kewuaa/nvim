local keymap = require("user.keymaps")
local mini_diff = require("mini.diff")

mini_diff.setup({
    view = {
        style = 'sign',
        -- Signs used for hunks with 'sign' view
        signs = { add = '┃', change = '┃', delete = '' },
    },
    mappings = {
        textobject = "ih"
    }
})

keymap.set("n", "ghp", function() mini_diff.toggle_overlay() end, opts)
