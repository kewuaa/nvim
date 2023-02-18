vim.cmd [[
py3 << EOF
try:
    import rtoml as toml
except ImportError:
    import tomli as toml


def read_toml(file: str):
    with open(file) as f:
        content = toml.load(f)
    return content
EOF
]]
local M = {}
local fn = vim.fn
local bigfile_callbacks = {
    {
        1024,
        function(_)
            -- disable vimopts
            vim.opt_local.swapfile = false
            vim.opt_local.foldmethod = "manual"
            vim.opt_local.undolevels = -1
            vim.opt_local.undoreload = 0
            vim.opt_local.list = false
            -- disable syntax
            vim.cmd "syntax clear"
            vim.opt_local.syntax = "OFF"
            -- disable filetypes
            vim.opt_local.filetype = ""
        end,
        true,
    }
}


M.read_toml = function(file)
    if file then
        file = vim.fn.fnamemodify(file, ':p')
    else
        file = vim.fn.expand('%:p')
    end
    return vim.fn.py3eval(string.format('read_toml("%s")', file))
end


M.get_cwd = function ()
    local activate_clients = vim.lsp.get_active_clients({
        bufnr = 0
    })
    local num = #activate_clients
    local root = nil
    if num > 0 then
        root = activate_clients[num].config.root_dir
    end
    if not root then
        root = fn.expand('%:p:h')
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

M.bigfile_callback_register = function(threshold, callback, opts)
    if opts.do_now == nil or opts.do_now then
        local bufnr = vim.api.nvim_get_current_buf()
        local size = M.get_bufsize(bufnr)
        if size > threshold then
            callback(bufnr)
        end
    end
    bigfile_callbacks[#bigfile_callbacks+1] = {threshold, callback, opts.defer}
end

M.init_bigfile_cmd = function()
    vim.api.nvim_create_autocmd('BufReadPre', {
        pattern = '*',
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local size = M.get_bufsize(bufnr)
            local defer_callbacks = {}
            for _, item in ipairs(bigfile_callbacks) do
                local threshold, callback = item[1], item[2]
                local defer = item[3]
                if size > threshold then
                    if defer then
                        defer_callbacks[#defer_callbacks+1] = callback
                    else
                        callback(bufnr)
                    end
                end
            end
            if #defer_callbacks > 0 then
                vim.api.nvim_create_autocmd('BufRead', {
                    buffer = bufnr,
                    callback = function()
                        for _, cb in ipairs(defer_callbacks) do
                            cb(bufnr)
                        end
                    end
                })
            end
        end
    })
end


return M
