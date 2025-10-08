project(repo_1 VERSION 1.0)
set(INSTALL_USE_RPATH ON)
set(EXPORT_LIB_LIST
  mod_1_1
  mod_1_2
)
set(EXPORT_BIN_LIST
  mod_1
)
set(CODEGEN_LIST
  mod_1_1_gen
)

devops_basic_setup()
add_subdirectory(mod_1)
devops_post_setup()
