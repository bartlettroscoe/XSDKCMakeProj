
INCLUDE(ParseVariableArguments)


MACRO(TRIBITS_INCLUDE_DIRECTORIES)
  PARSE_ARGUMENTS(
    PARSE #prefix
    "" # Lists
    "REQUIRED_DURING_INSTALLATION_TESTING" #Options
    ${ARGN}
    )
  IF(NOT ${PROJECT_NAME}_ENABLE_INSTALLATION_TESTING OR PARSE_REQUIRED_DURING_INSTALLATION_TESTING)
    _INCLUDE_DIRECTORIES(${PARSE_DEFAULT_ARGS})
  ENDIF()
ENDMACRO()


MACRO(INCLUDE_DIRECTORIES)
  PARSE_ARGUMENTS(
    PARSE #prefix
    "" # Lists
    "REQUIRED_DURING_INSTALLATION_TESTING" #Options
    ${ARGN}
    )
  IF(NOT ${PROJECT_NAME}_ENABLE_INSTALLATION_TESTING
    OR PARSE_REQUIRED_DURING_INSTALLATION_TESTING
    )
    _INCLUDE_DIRECTORIES(${PARSE_DEFAULT_ARGS})
  ENDIF()
ENDMACRO()
