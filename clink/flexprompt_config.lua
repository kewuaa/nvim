-- WARNING:  This file gets overwritten by the 'flexprompt configure' wizard!
--
-- If you want to make changes, consider copying the file to
-- 'flexprompt_config.lua' and editing that file instead.

flexprompt = flexprompt or {}
flexprompt.settings = flexprompt.settings or {}
flexprompt.settings.charset = "unicode"
flexprompt.settings.connection = "solid"
flexprompt.settings.flow = "concise"
flexprompt.settings.frame_color =
{
    "brightblack",
    "brightblack",
    "darkwhite",
    "darkblack",
}
flexprompt.settings.heads = "pointed"
flexprompt.settings.lean_separators = "vertical"
flexprompt.settings.left_frame = "none"
flexprompt.settings.left_prompt = "{python:always}{battery}{histlabel}{cwd}{git}"
flexprompt.settings.lines = "two"
flexprompt.settings.nerdfonts_version = 3
flexprompt.settings.nerdfonts_width = 2
flexprompt.settings.powerline_font = true
flexprompt.settings.right_frame = "none"
flexprompt.settings.right_prompt = "{exit}{duration}{time:format=%a %I:%M %p}"
flexprompt.settings.spacing = "normal"
flexprompt.settings.style = "lean"
flexprompt.settings.symbols =
{
    prompt = "❯",
}
flexprompt.settings.use_8bit_color = false
flexprompt.settings.use_icons = true
