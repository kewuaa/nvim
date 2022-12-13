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
local lsp_path = settings:getpy('default')
efm.settings = {
    rootMarkers = rootmarks,
    languages = {
        python = {
            {
                lintCommand = lsp_path .. "/../flake8 --extend-ignore F403,F405 --stdin-display-name ${INPUT} -",
                lintStdin = true,
                lintFormats = {"%f:%l:%c: %t%n%n%n %m"},
            },
            -- {
            --     lintCommand = lsp_path .. '/../mypy --show-column-numbers',
            --     lintFormats = {
            --         "%f:%l:%c: %trror: %m",
            --         "%f:%l:%c: %tarning: %m",
            --         "%f:%l:%c: %tote: %m",
            --     }
            -- },
            -- {
            --     formatCommand = lsp_path .. '/../black --quiet -',
            --     formatStdin = true,
            -- },
            -- {
            --     formatCommand = lsp_path .. '/../isort --quiet -',
            --     formatStdin = true,
            -- }
        }
    }
}

return efm
