local M = {}
local zoom_wind = nil
local api, fn = vim.api, vim.fn

local zoom = function()
    if zoom_wind and vim.api.nvim_win_is_valid(zoom_wind) then
        api.nvim_win_close(zoom_wind, true)
        zoom_wind = nil
        return
    end
    local bufnr = api.nvim_get_current_buf()
    local term = api.nvim_list_uis()[1]
    local width, height = term.width, term.height
    local float_width = math.floor(width * 0.9)
    local float_height = math.floor(height * 0.9)
    local row = math.floor((height - float_height) / 2)
    local col = math.floor((width - float_width) / 2)
    zoom_wind = api.nvim_open_win(bufnr, true, {
        relative = "editor",
        row = row,
        col = col,
        width = float_width,
        height = float_height,
        border = "single"
    })
    api.nvim_command("normal! zz")
end

M.get_cwd = function ()
    local activate_clients = vim.lsp.get_clients({
        bufnr = 0
    })
    local num = #activate_clients
    local root = nil
    if num > 0 then
        root = activate_clients[num].config.root_dir
    end
    if not root then
        local startpath = fn.expand('%:p:h')
        root = vim.fs.root(startpath, ".git") or vim.fn.expand("%:p:h")
    end
    return root
end

M.get_bufsize = function(bufnr)
    local ok, stats = pcall(vim.loop.fs_stat, vim.api.nvim_buf_get_name(bufnr))
    if ok and stats then
        return stats.size / 1024
    end
    return 0
end

M.init = function()
    vim.keymap.set("n", "<C-w>z", zoom, {silent = true, noremap = true})

    require('core.utils.bigfile').init()
    require('core.utils.im').init()
    require('core.utils.lsp').init()
end

return M
