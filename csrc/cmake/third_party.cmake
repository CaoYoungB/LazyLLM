include(FetchContent)
# Apply to all FetchContent_* dependencies in this configure run:
# disable remote update checks to keep builds reproducible.
set(FETCHCONTENT_UPDATES_DISCONNECTED ON)

find_package(Python3 COMPONENTS Interpreter Development.Module REQUIRED)
find_package(pybind11 CONFIG REQUIRED)

find_package(xxHash QUIET)
if (NOT TARGET xxhash AND NOT TARGET xxHash::xxHash)
    FetchContent_Declare(
        xxhash
        GIT_REPOSITORY https://github.com/Cyan4973/xxHash.git
        GIT_TAG v0.8.3
        SOURCE_SUBDIR cmake_unofficial
    )
    FetchContent_MakeAvailable(xxhash)
endif()

find_package(cpp_tiktoken QUIET)
if (NOT TARGET cpp_tiktoken)
    # We only need cpp_tiktoken for in-tree usage; avoid exporting/installing it.
    set(CPP_TIKTOKEN_INSTALL OFF CACHE BOOL "" FORCE)
    set(CPP_TIKTOKEN_TESTING OFF CACHE BOOL "" FORCE)
    # Windows: tiktoken does not export symbols, shared build yields no import .lib.
    # macOS: static avoids delocate-wheel failures from transitive pcre2 dylibs.
    if (WIN32 OR APPLE)
        set(_LAZYLLM_SAVED_BUILD_SHARED_LIBS ${BUILD_SHARED_LIBS})
        set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
    endif()
    FetchContent_Declare(
        cpp_tiktoken
        GIT_REPOSITORY https://github.com/gh-markt/cpp-tiktoken.git
        GIT_TAG 9323db528d52e48900c75ce197c3251085b18480
    )
    FetchContent_MakeAvailable(cpp_tiktoken)
    if ((WIN32 OR APPLE) AND DEFINED _LAZYLLM_SAVED_BUILD_SHARED_LIBS)
        set(BUILD_SHARED_LIBS ${_LAZYLLM_SAVED_BUILD_SHARED_LIBS} CACHE BOOL "" FORCE)
    endif()
endif()

find_package(utf8proc QUIET)
if (NOT TARGET utf8proc)
    # We only need utf8proc for in-tree usage; avoid exporting/installing it.
    set(UTF8PROC_INSTALL OFF CACHE BOOL "" FORCE)
    # Windows: keep utf8proc static for gtest_discover_tests without DLL paths.
    # macOS: keep utf8proc static for delocate-wheel compatibility.
    if (WIN32 OR APPLE)
        set(_LAZYLLM_SAVED_BUILD_SHARED_LIBS_UTF8 ${BUILD_SHARED_LIBS})
        set(BUILD_SHARED_LIBS OFF CACHE BOOL "" FORCE)
    endif()
    FetchContent_Declare(
        utf8proc
        GIT_REPOSITORY https://github.com/JuliaStrings/utf8proc.git
        GIT_TAG v2.9.0
    )
    FetchContent_MakeAvailable(utf8proc)
    if ((WIN32 OR APPLE) AND DEFINED _LAZYLLM_SAVED_BUILD_SHARED_LIBS_UTF8)
        set(BUILD_SHARED_LIBS ${_LAZYLLM_SAVED_BUILD_SHARED_LIBS_UTF8} CACHE BOOL "" FORCE)
    endif()
endif()
