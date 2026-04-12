require("mini.surround").setup({
    mappings = {
        add = "<leader>as",
        delete = "<leader>ds",
        find = "<leader>fs",
        find_left = "<leader>Fs",
        replace = "<leader>cs",
        highlight = "<leader>sh",
        update_n_lines = "",
        suffix_last = '', -- Suffix to search with "prev" method
        suffix_next = '',
    },
    n_lines = 500
})
