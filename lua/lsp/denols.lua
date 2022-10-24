local denols = {}
local settings = require("core.settings")
local path = settings.deno_path
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = 'deno.json'
rootmarks[#rootmarks+1] = 'deno.jsonc'


denols.cmd = {
    path .. 'deno.exe',
    'lsp',
}
denols.filetypes = {
    "javascript",
    "javascriptreact",
    "javascript.jsx",
    "typescript",
    "typescriptreact",
    "typescript.tsx",
}
denols.init_options = {
    enable = true,
    unstable = false,
}

return denols
