
INCLUDE(TribitsPackageMacros)


MACRO(TRIBITS_SUBPACKAGE SUBPACKAGE_NAME_IN)

  IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
    MESSAGE("\nSUBPACKAGE: ${SUBPACKAGE_NAME_IN}")
  ENDIF()

  IF (NOT ${SUBPACKAGE_NAME_IN} STREQUAL ${SUBPACKAGE_NAME})
    MESSAGE(FATAL_ERROR "Error, the package-defined subpackage name"
      " '${SUBPACKAGE_NAME_IN}' is not the same as the subpackage name"
      " '${SUBPACKAGE_NAME}' defined in the parent packages's"
      " Dependencies.cmake file")
  ENDIF()

  SET(PACKAGE_NAME ${SUBPACKAGE_FULLNAME})

  SET(PARENT_PACKAGE_SOURCE_DIR "${PACKAGE_SOURCE_DIR}")
  SET(PARENT_PACKAGE_BINARY_DIR "${PACKAGE_BINARY_DIR}")

  TRIBITS_SET_COMMON_VARS(${SUBPACKAGE_FULLNAME})
  TRIBITS_DEFINE_LINKAGE_VARS(${SUBPACKAGE_FULLNAME})

ENDMACRO()


MACRO(TRIBITS_SUBPACKAGE_POSTPROCESS)
  TRIBITS_PACKAGE_POSTPROCESS_COMMON()
ENDMACRO()
