#include "nanobind/nanobind.h"

#include "imtoggle/imtoggle.hpp"
namespace nb = nanobind;


NB_MODULE(imtoggle, m) {
    nb::class_<kewuaa::IMToggler>(m, "IMToggler")
        .def(nb::init<>())
        .def("toggle", &kewuaa::IMToggler::toggle)
        .def("switch_to_en", &kewuaa::IMToggler::switch_to_en)
        .def("switch_to_zh", &kewuaa::IMToggler::switch_to_zh);
}
