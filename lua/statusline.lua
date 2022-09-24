local M = {}


function M.file_or_lsp_status()
    -- Neovim keeps the messages send from the language server in a buffer and
    -- get_progress_messages polls the messages
    local messages = vim.lsp.util.get_progress_messages()
    local mode = vim.api.nvim_get_mode().mode

    -- If neovim isn't in normal mode, or if there are no messages from the
    -- language server display the file name
    -- I'll show format_uri later on
    if mode ~= 'n' or vim.tbl_isempty(messages) then
        return M.format_uri(vim.uri_from_bufnr(vim.api.nvim_get_current_buf()))
    end

    local percentage
    local result = {}
    -- Messages can have a `title`, `message` and `percentage` property
    -- The logic here renders all messages into a stringle string
    for _, msg in pairs(messages) do
        if msg.message then
            table.insert(result, msg.title .. ': ' .. msg.message)
        else
            table.insert(result, msg.title)
        end
        if msg.percentage then
            percentage = math.max(percentage or 0, msg.percentage)
        end
    end
    if percentage then
        return string.format('%03d: %s', percentage, table.concat(result, ', '))
    else
        return table.concat(result, ', ')
    end
end

function M.format_uri(uri)
    return vim.fn.fnamemodify(vim.uri_to_fname(uri), ':.')
end

function M.diagnostic_status()
    -- count the number of diagnostics with severity warning
    local num_errors = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.ERROR })
    -- If there are any errors only show the error count, don't include the number of warnings
    if num_errors > 0 then
        return '  ' .. num_errors .. ' '
    end
    -- Otherwise show amount of warnings, or nothing if there aren't any.
    local num_warnings = #vim.diagnostic.get(0, { severity = vim.diagnostic.severity.WARN })
    if num_warnings > 0 then
        return '  ' .. num_warnings .. ' '
    end
    return ''
end

function M.get_lsp_info()
    local active_clients = vim.lsp.buf_get_clients()
    local msg = {}
    for _, client in pairs(active_clients) do
        msg[#msg+1] = client.name
    end
    if #msg > 0 then
        return string.format('[%s]', table.concat(msg, ', '))
    else
        return ''
    end
end

function M.setup()
    -- vim.cmd [[
    --     hi warningmsg guifg=red
    -- ]]
    local parts = {
        [[%<» %{luaeval("require'statusline'.file_or_lsp_status()")}]],

        [[ %{luaeval("require('statusline').get_lsp_info()")}]],

        " %y%m%r%h%w",

        " %{get(b:,'gitsigns_status','')} ",

        "%=",

        -- %# starts a highlight group; Another # indicates the end of the highlight group name
        -- This causes the next content to display in colors (depending on the color scheme)
        -- "%#warningmsg#",

        [[%{luaeval("require'statusline'.diagnostic_status()")}]],

        -- Resets the highlight group
        -- "%*",

        -- vimL expressions can be placed into `%{ ... }` blocks
        -- The expression uses a conditional (ternary) operator: <condition> ? <truthy> : <falsy>
        -- If the current file format is not 'unix', display it surrounded by [], otherwise show nothing
        "%{&ff!='dos'?'['.&ff.'] ':''}",

        -- Same as before with the file format, except for the file encoding and checking for `utf-8`
        "%{(&fenc!='utf-8'&&&fenc!='')?'['.&fenc.'] ':''}",
    }
    return table.concat(parts, '')
end

return M

