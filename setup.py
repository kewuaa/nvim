import sys

from setuptools import Extension, setup
from setuptools.command.build_ext import build_ext as _build_ext


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
)
