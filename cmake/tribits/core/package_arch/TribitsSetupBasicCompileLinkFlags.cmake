
INCLUDE(TribitsDefineStandardCompileVars)
INCLUDE(DualScopePrependCmndlineArgs)


MACRO(TRIBITS_SET_LANGUAGE_BUILDTYPE_FLAGS LANG BUILDTYPE)


  SET(CMAKE_${LANG}_FLAGS_${BUILDTYPE} "")

  IF (GENERAL_${BUILDTYPE}_FLAGS)
    DUAL_SCOPE_PREPEND_CMNDLINE_ARGS(CMAKE_${LANG}_FLAGS_${BUILDTYPE}
      "${GENERAL_${BUILDTYPE}_FLAGS}")
  ENDIF()
  IF(${PROJECT_NAME}_VERBOSE_CONFIGURE)
    MESSAGE(STATUS "Adding ${LANG} ${BUILDTYPE} flags"
      " \"${GENERAL_${BUILDTYPE}_FLAGS}\"")
    PRINT_VAR(CMAKE_${LANG}_FLAGS_${BUILDTYPE})
  ENDIF()

ENDMACRO()


MACRO(TRIBITS_SET_LANGUAGE_BUILDTYPE_FLAGS_OVERRIDE LANG BUILDTYPE)

  SET(CMAKE_${LANG}_FLAGS_${BUILDTYPE}_OVERRIDE  ""
    CACHE  STRING
    "If set to non-empty, will override CMAKE_${LANG}_FLAGS_${BUILDTYPE}")

  IF (CMAKE_${LANG}_FLAGS_${BUILDTYPE}_OVERRIDE)
    IF(${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE(
        "-- Overriding CMAKE_${LANG}_FLAGS_${BUILDTYPE}:\n"
        "--  from\n"
        "--    ${CMAKE_${LANG}_FLAGS_${BUILDTYPE}}")
    ENDIF()
    DUAL_SCOPE_SET(CMAKE_${LANG}_FLAGS_${BUILDTYPE}
      ${CMAKE_${LANG}_FLAGS_${BUILDTYPE}_OVERRIDE})
    IF(${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE(
        "--  to\n"
        "--    ${CMAKE_${LANG}_FLAGS_${BUILDTYPE}}")
    ENDIF()
  ENDIF()


ENDMACRO()


MACRO(TRIBITS_SET_LANGUAGE_ALL_BUILDTYPES_FLAGS_OVERRIDE LANG)

  FOREACH(BUILDTYPE ${CMAKE_BUILD_TYPES_LIST})
    TRIBITS_SET_LANGUAGE_BUILDTYPE_FLAGS_OVERRIDE(${LANG} ${BUILDTYPE})
  ENDFOREACH()

ENDMACRO()


MACRO(TRIBITS_SET_LANGUAGE_GENERAL_FLAGS LANG)

  DUAL_SCOPE_PREPEND_CMNDLINE_ARGS(CMAKE_${LANG}_FLAGS "${GENERAL_BUILD_FLAGS}")
  IF(${PROJECT_NAME}_VERBOSE_CONFIGURE)
    MESSAGE(STATUS "Adding general ${LANG} flags \"${${GENERAL_BUILD_FLAGS}}\"")
    PRINT_VAR(CMAKE_${LANG}_FLAGS)
  ENDIF()

ENDMACRO()


MACRO(TRIBITS_SET_LANGUAGE_COVERAGE_FLAGS LANG)

  DUAL_SCOPE_PREPEND_CMNDLINE_ARGS(CMAKE_${LANG}_FLAGS
   "${COVERAGE_OPTIONS}")
  IF(COVERAGE_OPTIONS AND ${PROJECT_NAME}_VERBOSE_CONFIGURE)
    MESSAGE(STATUS "Adding coverage ${LANG} flags \"${COVERAGE_OPTIONS}\"")
    PRINT_VAR(CMAKE_${LANG}_FLAGS)
  ENDIF()

ENDMACRO()



FUNCTION(TRIBITS_SETUP_BASIC_COMPILE_LINK_FLAGS)


  TRIBITS_DEFINE_STANDARD_COMPILE_FLAGS_VARS(FALSE)


  IF (${PROJECT_NAME}_ENABLE_COVERAGE_TESTING)
    SET(COVERAGE_OPTIONS "-fprofile-arcs -ftest-coverage")
  ELSE()
    SET(COVERAGE_OPTIONS "")
  ENDIF()


  ASSERT_DEFINED(${PROJECT_NAME}_ENABLE_C CMAKE_C_COMPILER_ID)
  IF (${PROJECT_NAME}_ENABLE_C AND CMAKE_C_COMPILER_ID STREQUAL "GNU")
    TRIBITS_SET_LANGUAGE_BUILDTYPE_FLAGS(C DEBUG)
    TRIBITS_SET_LANGUAGE_BUILDTYPE_FLAGS(C RELEASE)
    TRIBITS_SET_LANGUAGE_GENERAL_FLAGS(C)
    TRIBITS_SET_LANGUAGE_COVERAGE_FLAGS(C)
  ENDIF()
  TRIBITS_SET_LANGUAGE_ALL_BUILDTYPES_FLAGS_OVERRIDE(C)


  ASSERT_DEFINED(${PROJECT_NAME}_ENABLE_CXX CMAKE_CXX_COMPILER_ID)
  IF (${PROJECT_NAME}_ENABLE_CXX AND CMAKE_CXX_COMPILER_ID STREQUAL "GNU")
    TRIBITS_SET_LANGUAGE_BUILDTYPE_FLAGS(CXX DEBUG)
    TRIBITS_SET_LANGUAGE_BUILDTYPE_FLAGS(CXX RELEASE)
    TRIBITS_SET_LANGUAGE_GENERAL_FLAGS(CXX)
    TRIBITS_SET_LANGUAGE_COVERAGE_FLAGS(CXX)
  ENDIF()
  TRIBITS_SET_LANGUAGE_ALL_BUILDTYPES_FLAGS_OVERRIDE(CXX)


  ASSERT_DEFINED(${PROJECT_NAME}_ENABLE_Fortran)
  IF (${PROJECT_NAME}_ENABLE_Fortran AND CMAKE_Fortran_COMPILER_ID STREQUAL "GNU")
    TRIBITS_SET_LANGUAGE_GENERAL_FLAGS(Fortran)
    TRIBITS_SET_LANGUAGE_COVERAGE_FLAGS(Fortran)
  ENDIF()
  TRIBITS_SET_LANGUAGE_ALL_BUILDTYPES_FLAGS_OVERRIDE(Fortran)


  ASSERT_DEFINED(${PROJECT_NAME}_ENABLE_COVERAGE_TESTING COVERAGE_OPTIONS)
  IF (${PROJECT_NAME}_ENABLE_COVERAGE_TESTING AND COVERAGE_OPTIONS)
    DUAL_SCOPE_PREPEND_CMNDLINE_ARGS(CMAKE_EXE_LINKER_FLAGS
     "${COVERAGE_OPTIONS} ${CMAKE_EXE_LINKER_FLAGS}")
    IF(${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE(STATUS "Adding coverage linker flags flags \"${COVERAGE_OPTIONS}\"")
      PRINT_VAR(CMAKE_EXE_LINKER_FLAGS)
    ENDIF()
  ENDIF()

ENDFUNCTION()
