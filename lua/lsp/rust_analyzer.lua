local M = {}

M.rust_analyzer = {
    settings = {
        ['rust-analyzer'] = {
            imports = {
                granularity = {
                    group = 'module',
                },
                prefix = 'self',
            },
            cargo = {
                buildScripts = {
                    enable = true,
                },
            },
            procMacro = {
                enable = true,
            },
            inlayHints = {
                bindingModeHints = {
                    enable = false,
                },
                chainingHints = {
                    enable = true,
                },
                closingBraceHints = {
                    enable = true,
                    minLines = 25,
                },
                closureReturnTypeHints = {
                    enable = "never",
                },
                lifetimeElisionHints = {
                    enable = "never",
                    useParameterNames = false,
                },
                maxLength = 25,
                parameterHints = {
                    enable = true,
                },
                reborrowHints = {
                    enable = "never",
                },
                renderColons = true,
                typeHints = {
                    enable = true,
                    hideClosureInitialization = false,
                    hideNamedConstructor = false,
                },
            },
        },
    },
}

return M
