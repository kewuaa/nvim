local M = {}

local group = vim.api.nvim_create_augroup("tinymist_pin_main", {clear = true})
vim.api.nvim_create_autocmd("LspAttach", {
    group = group,
    callback = function(args)
        local client = vim.lsp.get_client_by_id(args.data.client_id)
        assert(client)
        if
            client.name ~= "tinymist"
            or not client.root_dir
        then
            return
        end
        local entry = vim.fs.joinpath(client.root_dir, "main.typ")
        local ok, _ = vim.uv.fs_stat(entry)
        if ok then
            client:exec_cmd(
                {
                    title = "pin_main",
                    command = "tinymist.pinMain",
                    arguments = {entry},
                }
            )
        end
    end
})

M.tinymist = {
    rootmarks = {"typst.toml", ".git"},
    single_file_support = true
}

return M
