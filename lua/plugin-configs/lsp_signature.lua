local M = {}

function M.setup()
    require("lsp.hook").add(
        function(client, bufnr)
            require('lsp_signature').on_attach({
                bind = true, -- This is mandatory, otherwise border config won't get registered.
                handler_opts = {
                    border = "single"
                },
            }, bufnr)
        end
    )
end

return M

