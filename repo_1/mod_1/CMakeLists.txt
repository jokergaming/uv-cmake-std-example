add_subdirectory(mod_1_1)
add_subdirectory(mod_1_2)

file(GLOB SOURCE_FILES CONFIGURE_DEPENDS src/*.cc)
add_executable(mod_1 ${SOURCE_FILES})

target_link_libraries(mod_1
    PRIVATE
        mod_1_1
        mod_1_2
        ${DEPENDED_LIB_MOD_2}
)
