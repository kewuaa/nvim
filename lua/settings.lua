local settings = {}
local program_files_path = 'D:/Softwares/Program_Files/'

settings.py3_path = program_files_path .. 'Python/'
settings.nvim_py3 = settings.py3_path .. 'nvim/Scripts/python.exe'
settings.lua_path = program_files_path .. 'Lua/'
settings.py3_rootmarks = {'.git', '.venv'}
settings.lua_rootmarks = {'.git'}

return settings

