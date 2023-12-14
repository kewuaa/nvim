import sys
from distutils.unixccompiler import UnixCCompiler

from setuptools import Extension, setup
from setuptools.command.build_ext import build_ext as _build_ext


class build_ext(_build_ext):
    def build_extensions(self) -> None:
        if isinstance(self.compiler, UnixCCompiler):
            if "zig" in self.compiler.cc:
                self.compiler.dll_libraries.clear()
                self.compiler.set_executable(
                    "compiler_so",
                    f"{self.compiler.cc} -Wall -O3 -lc++",
                )
                for ext in self.extensions:
                    ext.undef_macros.append("_DEBUG")
                #endfor
            #endif
        #endif
        return super().build_extensions()
    #enddef
#endclass


use_cython = False
if "--cycompile" in sys.argv:
    use_cython = True
    sys.argv.remove("--cycompile")
#endif
suffix = "pyx" if use_cython else "cpp"
exts = [
    Extension(
        name="imtoggle",
        sources=[
            "./rplugin/python3/utils/imtoggle." + suffix,
            "./rplugin/python3/utils/imtoggle/imtoggle.cpp"
        ],
        include_dirs=[
            "./rplugin/python3/utils/imtoggle/",
        ],
        libraries=["imm32"],
    )
]
if use_cython:
    from Cython.Build import cythonize
    exts = cythonize(exts)
#endif
setup(
    ext_modules=exts,
    cmdclass={"build_ext": build_ext}
)
