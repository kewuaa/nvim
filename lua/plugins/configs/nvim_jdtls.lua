local mini_misc = require("mini.misc")

mini_misc.safely("event:filetype", function()
    vim.cmd.packadd("nvim-jdtls")
end)
