local M = {}

local meson_matcher = function(_, path)
    local pattern = 'meson.build'
    local f = vim.fn.glob(table.concat({ path, pattern }, '/'))
    if f == '' then
        return false
    end
    for line in io.lines(f) do
        -- skip meson comments
        if not line:match '^%s*#.*' then
            local str = line:gsub('%s+', '')
            if str ~= '' then
                if str:match '^project%(' then
                    return true
                else
                    break
                end
            end
        end
    end
    return false
end

---@type vim.lsp.Config
M.mesonlsp = {
    cmd = { 'mesonlsp', '--lsp' },
    filetypes = { 'meson' },
    root_dir = function(bufnr, on_dir)
        on_dir(vim.fs.root(bufnr, meson_matcher) or vim.fs.root(bufnr, '.git'))
    end,
}

return M
