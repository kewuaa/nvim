local M = {}
local map = vim.keymap.set
local opt = {noremap = true, silent = true}

function M.setup()
    map('n', '<leader>ff', '<cmd>Telescope find_files<cr>', opt)
    map('n', '<leader>fg', '<cmd>Telescope live_grep<cr>', opt)
    map('n', '<leader>fb', '<cmd>Telescope buffers<cr>', opt)
    map('n', '<leader>fh', '<cmd>Telescope help_tags<cr>', opt)
end

function M.config()
    require('telescope').setup({
        defaults = {
            prompt_prefix = '🔭 ',
            selection_caret = ' ',
            layout_config = {
                horizontal = { prompt_position = 'top', results_width = 0.6 },
                vertical = { mirror = false },
            },
            sorting_strategy = 'ascending',
            file_previewer = require('telescope.previewers').vim_buffer_cat.new,
            grep_previewer = require('telescope.previewers').vim_buffer_vimgrep.new,
            qflist_previewer = require('telescope.previewers').vim_buffer_qflist.new,
        },
        extensions = {
            fzf = {
                fuzzy = true,                    -- false will only do exact matching
                override_generic_sorter = true,  -- override the generic sorter
                override_file_sorter = true,     -- override the file sorter
                case_mode = "smart_case",        -- or "ignore_case" or "respect_case"
                -- the default case_mode is "smart_case"
            }
        }
    })
    -- To get fzf loaded and working with telescope, you need to call
    -- load_extension, somewhere after setup function:
    require('telescope').load_extension('fzf')
end

return M

