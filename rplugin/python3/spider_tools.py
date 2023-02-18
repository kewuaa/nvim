from re import compile

import pynvim


@pynvim.plugin
class SpiderTools:
    def __init__(self, nvim: pynvim.api.nvim.Nvim) -> None:
        self.__blank_pattern = compile(r'\s*')
        self.__nvim = nvim

    def __add_quota(self, s: str) -> str:
        def repl(m):
            return m.group(0) + "'"
        return self.__blank_pattern.sub(repl, s, count=1)

    @pynvim.command('FormatDict', nargs='*', range='')
    def format_dict(self, args, range) -> None:
        nvim = self.__nvim
        buffer = nvim.current.buffer
        start, end = range
        start -= 1
        lines = buffer[start: end]
        for i, line in enumerate(lines):
            item = line.split(':', 1)
            if len(item) > 1:
                k, v = item
                buffer[i + start] = \
                    f"{self.__add_quota(k)}': '{v.lstrip().rstrip(',')}',"
