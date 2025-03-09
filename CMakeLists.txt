CMAKE_MINIMUM_REQUIRED(VERSION 3.15)

PROJECT(
    pyutils
    LANGUAGES CXX
)

if (NOT WIN32)
    MESSAGE(FATAL_ERROR "not support current platform: ${CMAKE_SYSTEM_NAME}")
endif()

SET(CMAKE_CXX_STANDARD 17)
SET(CMAKE_EXPORT_COMPILE_COMMANDS on)

FIND_PACKAGE(Python REQUIRED COMPONENTS Development.Module)

if (NOT CMAKE_BUILD_TYPE AND NOT CMAKE_CONFIGURATION_TYPES)
  set(CMAKE_BUILD_TYPE Release CACHE STRING "Choose the type of build." FORCE)
  set_property(CACHE CMAKE_BUILD_TYPE PROPERTY STRINGS "Debug" "Release" "MinSizeRel" "RelWithDebInfo")
endif()

INCLUDE(FetchContent)
FetchContent_Declare(
    nanobind
    GIT_REPOSITORY "https://github.com/wjakob/nanobind.git"
)
FetchContent_MakeAvailable(nanobind)

nanobind_add_module(${PROJECT_NAME})
TARGET_SOURCES(
    ${PROJECT_NAME}
    PRIVATE
        rplugin/python3/utils/imtoggle_wrap.cpp
        rplugin/python3/utils/imtoggle/imtoggle.cpp
)
TARGET_LINK_LIBRARIES(${PROJECT_NAME} PRIVATE "imm32")

INSTALL(
    TARGETS ${PROJECT_NAME}
    LIBRARY DESTINATION utils
)
