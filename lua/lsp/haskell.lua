local M = {}

M.hls = {
    filetypes = {"haskell", "lhaskell", "cabal"},
    cmd = {"haskell-language-server-wrapper", "--lsp"},
}

return M
