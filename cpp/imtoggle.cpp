#include <stdio.h>
#include <cstdlib>
#include <windows.h>
#ifdef DEBUG
    #define LOG(info) printf("%s\n", info)
#else
    #define LOG(info)
#endif // DEBUG


int main(int argc, char** argv)
{
    constexpr LPARAM IMC_GETOPENSTATUS = 5;
    constexpr LPARAM IMC_SETOPENSTATUS = 6;
    HWND hwnd = GetForegroundWindow();
    if (!hwnd) {
        LOG("hwnd nil");
        return 0;
    }
    HWND ime = ImmGetDefaultIMEWnd(hwnd);
    if (!ime) {
        LOG("ime nil");
        return 0;
    }
    LPARAM stat;
    if (argc < 2) {
        LOG("argc < 2");
        stat = SendMessage(ime, WM_IME_CONTROL, IMC_GETOPENSTATUS, 0);
        SendMessage(ime, WM_IME_CONTROL, IMC_SETOPENSTATUS, stat ? 0: 1025);
    } else {
        LOG("argc > 1");
        stat = std::atoi(argv[1]);
        SendMessage(ime, WM_IME_CONTROL, IMC_SETOPENSTATUS, stat);
    }
}
