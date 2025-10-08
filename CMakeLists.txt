cmake_minimum_required(VERSION 3.26)
project(Example VERSION 1.0 LANGUAGES C CXX ASM)

set(CMAKE_CXX_STANDARD 17)
set(CMAKE_CXX_STANDARD_REQUIRED ON)
set(CMAKE_CXX_EXTENSIONS ON)

include(CMakePrintHelpers)
include(utils)

set(CODEGEN_TARGET codegen)
add_custom_target(${CODEGEN_TARGET})

set(COMP_DEPS
    repo_2
    repo_1
)

separate_arguments(COMP_LIST)
foreach(_COMP ${COMP_DEPS})
    if(COMP_LIST STREQUAL ALL OR _COMP IN_LIST COMP_LIST)
        # source
        if(EXISTS ${_COMP})
            config_comp(${_COMP} FALSE)
            add_subdirectory(${_COMP})
        else()
            message(FATAL_ERROR "${_COMP} does NOT exist")
        endif()
    else()
        # ref
        config_comp(${_COMP} TRUE)
        export_deps(${_COMP})
    endif()
endforeach()
