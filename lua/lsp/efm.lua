local efm = {}
local settings = require("core.settings")
local path = settings.efm_path .. 'efm-langserver/'
local rootmarks = settings.rootmarks
rootmarks[#rootmarks+1] = '.root'


efm.rootmarks = rootmarks
efm.filetypes = {'python'}
efm.cmd = {path .. 'efm-langserver.exe'}
efm.init_options = {
    documentFormatting = true,
    -- hover = true,
    -- documentSymbol = true,
    codeAction = true,
    -- completion = true
}
efm.settings = {
    rootMarkers = rootmarks,
    languages = {
        python = {
            {
                lintCommand = settings:getpy('lsp') .. "/../flake8 --extend-ignore F403,F405 --stdin-display-name ${INPUT} -",
                lintStdin = true,
                lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
            }
        }
    }
}

return efm
