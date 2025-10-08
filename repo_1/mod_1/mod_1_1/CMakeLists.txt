file(GLOB SOURCE_FILES CONFIGURE_DEPENDS src/*.cc)

add_library(mod_1_1 STATIC
  ${SOURCE_FILES}
)

add_custom_target(mod_1_1_gen)
