local M = {}
local zoom_wind = nil

M.zoom = function()
    if zoom_wind and vim.api.nvim_win_is_valid(zoom_wind) then
        vim.api.nvim_win_close(zoom_wind, true)
        zoom_wind = nil
        return
    end
    local bufnr = vim.api.nvim_get_current_buf()
    local term = vim.api.nvim_list_uis()[1]
    local width, height = term.width, term.height
    local float_width = math.floor(width * 0.9)
    local float_height = math.floor(height * 0.9)
    local row = math.floor((height - float_height) / 2)
    local col = math.floor((width - float_width) / 2)
    zoom_wind = vim.api.nvim_open_win(bufnr, true, {
        relative = "editor",
        row = row,
        col = col,
        zindex = 10,
        width = float_width,
        height = float_height,
        border = "single"
    })
    vim.cmd("normal! zz")
end

return M
