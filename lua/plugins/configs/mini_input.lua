local mini_input = require("mini.input")


mini_input.setup({
    handlers = {
        key = function(state, key)
            if state.opts.prompt:find("[Pp]assword") ~= nil then
                state.opts.hide = true
            end

            if key == vim.keycode('<C-b>') then
                state.caret = math.max(1, state.caret - 1)
            elseif key == vim.keycode('<C-f>') then
                state.caret = math.min(#state.input + 1, state.caret + 1)
            else
                return mini_input.default_key(state, key)
            end
        end,
    }
})
