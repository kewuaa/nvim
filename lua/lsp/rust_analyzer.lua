local rust_analyzer = {}
local settings = require("settings")
local rootmarks = {}


for k, v in pairs(settings.rootmarks) do
    rootmarks[k] = v
end
rootmarks[#rootmarks+1] = "Cargo.toml"
rootmarks[#rootmarks+1] = "rust-project.json"


rust_analyzer.rootmarks = rootmarks
rust_analyzer.filetypes = {'rust'}
rust_analyzer.single_file_support = false
rust_analyzer.cmd = {settings.rust_path .. 'rust_analyzer/rust-analyzer.exe'}
rust_analyzer.settings = {
    ['rust-analyzer'] = {
        imports = {
            granularity = {
                group = "module",
            },
            prefix = "self",
        },
        cargo = {
            buildScripts = {
                enable = true,
            },
        },
        procMacro = {
            enable = true
        },
    }
}


return rust_analyzer
