local utils = require("utils")

vim.g["suda#prompt"] = "Enter administrator password: "

utils.on_command({ "SudaWrite", "SudaRead" }, function()
    vim.cmd.packadd("vim-suda")
end)
