local mini_notify = require("mini.notify")

mini_notify.setup()

vim.notify = mini_notify.make_notify({ ERROR = { duration = 10000 } })

vim.api.nvim_create_user_command(
    "MiniNotifyHistory",
    mini_notify.show_history,
    {desc = "show history of mini_notify"}
)
