local M = {}

function M.setup()
    vim.keymap.set('n', '<leader>tt', ':NvimTreeToggle<CR>', {
        noremap = true,
        silent = true,
    })
end

function M.config()
    require("nvim-tree").setup({
      sort_by = "case_sensitive",
      view = {
        adaptive_size = true,
        mappings = {
          list = {
            { key = "u", action = "dir_up" },
          },
        },
      },
      renderer = {
        group_empty = true,
      },
      filters = {
        dotfiles = true,
      },
    })
end

return M

