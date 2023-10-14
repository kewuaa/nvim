#include <iostream>
#include <Windows.h>

namespace kewuaa {
    class IMToggler {
        private:
            HWND _ime;
            bool _is_en_mode();
        public:
            IMToggler();
            void toggle();
            void switch_to_en();
            void switch_to_zh();
    };
}
