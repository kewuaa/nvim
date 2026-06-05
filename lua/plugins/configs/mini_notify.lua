local mini_notify = require("mini.notify")

mini_notify.setup()

vim.api.nvim_create_user_command(
    "MiniNotifyHistory",
    mini_notify.show_history,
    {desc = "show history of mini_notify"}
)
