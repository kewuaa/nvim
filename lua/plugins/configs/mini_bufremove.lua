local keymap = require("user.keymaps")
local mini_bufremove = require("mini.bufremove")

mini_bufremove.setup()

keymap.set("n", "<leader>bd", function() mini_bufremove.delete(0, false) end)
keymap.set("n", "<leader>bD", function() mini_bufremove.delete(0, true) end)
