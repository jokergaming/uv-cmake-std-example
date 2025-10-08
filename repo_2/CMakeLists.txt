project(repo_2 VERSION 1.0)
set(INSTALL_USE_RPATH ON)
set(EXPORT_LIB_LIST
  mod_2
)

devops_basic_setup()
add_subdirectory(mod_2)
devops_post_setup()
