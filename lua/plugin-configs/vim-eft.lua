local M = {}
local map = vim.keymap.set
local opt = {noremap = true, silent = true}

function M.setup()
    -- Custom highlight
    vim.g.eft_highlight = {
        ['1'] = {
            highlight = 'EftChar',
            allow_space = true,
            allow_operator = true,
        },
        ['2'] = {
            highlight = 'EftSubChar',
            allow_space = false,
            allow_operator = false,
        },
        ['n'] = {
            highlight = 'EftSubChar',
            allow_space = false,
            allow_operator = false,
        }
    }

    -- You can use the below function like native `f`
    vim.g.eft_index_function = {
        all = function() return true end,
    }
end

function M.config()
    -- You can pick your favorite strategies.
    vim.g.eft_index_function = {
        head = vim.fn['eft#index#head'],
        tail = vim.fn['eft#index#tail'],
        space = vim.fn['eft#index#space'],
        camel = vim.fn['eft#index#camel'],
        symbol = vim.fn['eft#index#symbol'],
    }
    map('n', ';', '<Plug>(eft-repeat)', opt)
    map('x', ';', '<Plug>(eft-repeat)', opt)
    map('o', ';', '<Plug>(eft-repeat)', opt)

    map('n', 'f', '<Plug>(eft-f)', opt)
    map('x', 'f', '<Plug>(eft-f)', opt)
    map('o', 'f', '<Plug>(eft-f)', opt)
    map('n', 'F', '<Plug>(eft-F)', opt)
    map('x', 'F', '<Plug>(eft-F)', opt)
    map('o', 'F', '<Plug>(eft-F)', opt)

    map('n', 't', '<Plug>(eft-t)', opt)
    map('x', 't', '<Plug>(eft-t)', opt)
    map('o', 't', '<Plug>(eft-t)', opt)
    map('n', 'T', '<Plug>(eft-T)', opt)
    map('x', 'T', '<Plug>(eft-T)', opt)
    map('o', 'T', '<Plug>(eft-T)', opt)
end

return M

