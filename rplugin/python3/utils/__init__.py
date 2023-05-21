from re import compile

import pynvim


@pynvim.plugin
class Utils:
    def __init__(self, nvim: pynvim.api.nvim.Nvim) -> None:
        self._nvim = nvim
        self.__blank_pattern = compile(r'\s*')

    def _add_quota(self, s: str) -> str:
        def repl(m):
            return m.group(0) + "'"
        return self.__blank_pattern.sub(repl, s, count=1)

    @pynvim.command('FormatDict', nargs='*', range='')
    def format_dict(self, args, range) -> None:
        nvim = self._nvim
        buffer = nvim.current.buffer
        start, end = range
        start -= 1
        lines = buffer[start: end]
        for i, line in enumerate(lines):
            item = line.split(':', 1)
            if len(item) > 1:
                k, v = item
                buffer[i + start] = \
                    f"{self._add_quota(k)}': '{v.lstrip().rstrip(',')}',"

    @pynvim.autocmd('BufNewFile', '*.pyx')
    def add_pyxfilehead(self) -> None:
        nvim = self._nvim
        buffer = nvim.current.buffer
        lines = (
            '# cython: language_level=3',
            '# cython: boundscheck=False',
            '# cython: wraparound=False',
            '# cython: cdivision=True',
            '# distutils: language=c++'
        )
        buffer.append(lines)
        del buffer[0]
