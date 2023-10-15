# cython: language_level=3
# cython: boundscheck=False
# cython: wraparound=False
# cython: cdivision=True
# distutils: language=c++
cdef extern from "imtoggle.hpp" namespace "kewuaa" nogil:
    cdef cppclass IMToggler:
        IMToggler() except +
        void toggle()
        void switch_to_en()
        void switch_to_zh()
    #endcppclass
#endextern

cdef IMToggler _imtoggler = IMToggler()


def toggle() -> None:
    _imtoggler.toggle()
#enddef


def switch_to_en() -> None:
    _imtoggler.switch_to_en()
#enddef


def switch_to_zh() -> None:
    _imtoggler.switch_to_zh()
#enddef
