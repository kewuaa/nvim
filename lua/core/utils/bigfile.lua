local M = {}

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

M.register = function(threshold, callback, opts)
    if opts.do_now == nil or opts.do_now then
        local bufnr = vim.api.nvim_get_current_buf()
        local size = require('core.utils').get_bufsize(bufnr)
        if size > threshold then
            callback(bufnr)
        end
    end
    bigfile_callbacks[#bigfile_callbacks+1] = {threshold, callback, opts.defer}
end

M.init = function()
    vim.api.nvim_create_autocmd('BufReadPre', {
        pattern = '*',
        callback = function()
            local bufnr = vim.api.nvim_get_current_buf()
            local size = require('core.utils').get_bufsize(bufnr)
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
