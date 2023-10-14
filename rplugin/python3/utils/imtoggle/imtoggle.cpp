#include <iostream>
#include <Windows.h>

#include "imtoggle.hpp"

namespace kewuaa {
    bool IMToggler::_is_en_mode() {
        int state = SendMessage(
            _ime,
            0x283, // WM_IME_CONTROL
            0x001, // IMC_GETCONVERSIONMODE
            0
        );
        return state == 0;
    }


    IMToggler::IMToggler() {
        HWND current_window = GetForegroundWindow();
        if (!current_window) {
            throw std::runtime_error("get foreground window failed");
        }
        _ime = ImmGetDefaultIMEWnd(current_window);
        if (!_ime) {
            throw std::runtime_error("got nil ime");
        }
    }


    void IMToggler::toggle() {
        SendMessage(
            _ime,
            0x283, // WM_IME_CONTROL
            0x002, // IMC_SETCONVERSIONMODE
            _is_en_mode() ? 1025 : 0
        );
    }

    void IMToggler::switch_to_en() {
        SendMessage(_ime, 0x283, 0x002, 0);
    }

    void IMToggler::switch_to_zh() {
        SendMessage(_ime, 0x283, 0x002, 1025);
    }
}
