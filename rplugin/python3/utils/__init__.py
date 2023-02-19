from pathlib import Path
from re import compile

import pynvim
try:
    import rtoml as toml
except ImportError:
    import tomli as toml


def _read_toml(file: str) -> dict:
    file = Path(file)
    if file.exists():
        raise RuntimeError('file not exists')
    with open(file) as f:
        content = toml.load(f)
    return content


@pynvim.plugin
class Utils:
    def __init__(self, nvim: pynvim.api.nvim.Nvim) -> None:
        self._nvim = nvim
        self.__blank_pattern = compile(r'\s*')

    def __add_quota(self, s: str) -> str:
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
                    f"{self.__add_quota(k)}': '{v.lstrip().rstrip(',')}',"
