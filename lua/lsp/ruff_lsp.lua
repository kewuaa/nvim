local ruff_lsp = {}
local settings = require('core.settings')
local jdls = require('lsp.jedi_language_server')
local script_path = vim.fn.fnamemodify(settings:getpy('default'), ':h')


ruff_lsp.rootmarks = jdls.rootmarks
ruff_lsp.filetypes = jdls.filetypes
ruff_lsp.cmd = {
    script_path .. '/ruff-lsp.exe'
}
ruff_lsp.on_attach = function() end
ruff_lsp.init_options = {
}


return ruff_lsp
