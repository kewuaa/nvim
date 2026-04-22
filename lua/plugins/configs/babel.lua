local utils = require("utils")

utils.on_keys({
    {
        mode = "n",
        lhs = "<leader>tr",
        rhs = function()
            vim.go.operatorfunc = "v:lua.require'plugins.configs.babel'"
            return "g@"
        end,
        opts = { expr = true }
    },
    -- { lhs = "<leader>tr", mode = "v" },
    { mode = "n", lhs = "<leader>tw" },
}, function()
    vim.cmd.packadd("babel.nvim")

    require("babel").setup({
        target = "zh",
        float = {
            border = "single",
            mode = "cursor"
        },
        keymaps = {
            translate = "<leader>tr",
            translate_word = "<leader>tw",
            lang = "<leader>tl",
            swap = "<leader>ts",
        },
    })
end)

return function(type)
    -- type 会是 'char', 'line', 或 'block'
    local start_pos = vim.api.nvim_buf_get_mark(0, "[")
    local end_pos = vim.api.nvim_buf_get_mark(0, "]")

    -- 获取选中的文本行
    local lines
    if type == "char" then
        lines = vim.api.nvim_buf_get_text(
            0,
            start_pos[1] - 1, start_pos[2],
            end_pos[1] - 1, end_pos[2] + 1,
            {}
        )
    elseif type == "line" then
        lines = vim.api.nvim_buf_get_lines(
            0,
            start_pos[1] - 1,
            end_pos[1],
            false
        )
    elseif type == "block" then
        vim.notify("block")
        lines = {}
        local raw_lines = vim.api.nvim_buf_get_lines(0, start_pos[1] - 1, end_pos[1], false)
        for _, line in ipairs(raw_lines) do
            table.insert(
                lines,
                string.sub(
                    line,
                    start_pos[2] + 1,
                    end_pos[2] + 1
                )
            )
        end
    else
        return
    end

    require("babel").translate(vim.fn.join(lines, "\n"))
end
