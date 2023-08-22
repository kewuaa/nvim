local M = {}
local settings = require("core.settings")
local rootmarks = settings.get_rootmarks()
vim.list_extend(rootmarks, {
    ".opam",
    "esy.json",
    "package.json",
    "dune-project",
    "dune-workspace",
})

M.ocamllsp = {
    rootmarks = rootmarks,
    filetypes = {"ocaml", "ocaml.menhir", "ocaml.interface", "ocaml.ocamllex", "reason", "dune"},
    cmd = {"ocamllsp"},
}

return M
