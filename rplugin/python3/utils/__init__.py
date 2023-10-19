from re import compile

import pynvim

from . import imtoggle  # pyright: ignore


@pynvim.plugin
class Utils:
    def __init__(self, nvim: pynvim.Nvim) -> None:
        self._nvim = nvim
        self.__blank_pattern = compile(r'\s*')
    #enddef

    def _add_quota(self, s: str) -> str:
        def repl(m):
            return m.group(0) + '"'
        #enddef
        return self.__blank_pattern.sub(repl, s, count=1)
    #enddef

    @pynvim.command('FormatDict', nargs='*', range='') # pyright: ignore
    def format_dict(self, args, range) -> None:
        nvim = self._nvim
        buffer = nvim.current.buffer
        ft = nvim.eval("&filetype")
        start, end = range
        start -= 1
        lines = buffer[start: end]
        if ft == "cs":
            format_str = 'new KeyValuePair<string, string>({k}", "{v}"),'
        elif ft == "python":
            format_str = '{k}": "{v}",'
        else:
            nvim.command(f'echom "FormatDict command not support filetype \\"{ft}\\""')
            return
        #endif
        for i, line in enumerate(lines):
            item = line.split(':', 1)
            if len(item) > 1:
                k, v = item
                buffer[i + start] = format_str.format(k=self._add_quota(k), v=v.lstrip().rstrip(","))
            #endif
        #endfor
    #enddef

    def _add_pyxfilehead(self) -> None:
        nvim = self._nvim
        buffer = nvim.current.buffer
        lines = (
            '# cython: language_level=3',
            '# cython: boundscheck=False',
            '# cython: wraparound=False',
            '# cython: cdivision=True',
            '# distutils: language=c++'
        )
        buffer.append(lines, index=0)
    #enddef

    @pynvim.autocmd('BufNewFile', '*.pyx')
    def pyxfilehead_autocmd(self) -> None:
        self._add_pyxfilehead()
    #enddef

    @pynvim.command('AddPYXFileHead', nargs='*') # pyright: ignore
    def pyxfilehead_command(self, *args) -> None:
        self._add_pyxfilehead()
    #enddef

    @pynvim.function("IMToggle", sync=True)
    def toggle_ime(self, args) -> None:
        imtoggle.toggle() # pyright: ignore
    #enddef

    @pynvim.function("IMSwitchToEN", sync=True)
    def imswitch_to_zh(self, args) -> None:
        imtoggle.switch_to_en() # pyright: ignore
    #enddef

    @pynvim.function("IMSwitchToZH", sync=True)
    def imswitch_to_en(self, args) -> None:
        imtoggle.switch_to_zh() # pyright: ignore
    #enddef
