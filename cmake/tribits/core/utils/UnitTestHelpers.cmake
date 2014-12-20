
INCLUDE(ParseVariableArguments)
INCLUDE(GlobalSet)


FUNCTION(UNITTEST_COMPARE_CONST VAR_NAME CONST_VAL)

  MATH( EXPR NUMRUN ${UNITTEST_OVERALL_NUMRUN}+1 )
  GLOBAL_SET(UNITTEST_OVERALL_NUMRUN ${NUMRUN})

  MESSAGE(
    "\nCheck:\n"
    "    ${VAR_NAME} =\n"
    "    [${${VAR_NAME}}]\n"
    "  EQUALS:\n"
    "    [${CONST_VAL}]"
    )

  IF ("${${VAR_NAME}}" STREQUAL "${CONST_VAL}")
    MESSAGE("  [PASSED]\n")
    MATH( EXPR NUMPASSED ${UNITTEST_OVERALL_NUMPASSED}+1 )
    GLOBAL_SET(UNITTEST_OVERALL_NUMPASSED ${NUMPASSED})
  ELSE()
    MESSAGE("  [FAILED]\n")
    GLOBAL_SET(UNITTEST_OVERALL_PASS FALSE)
    MESSAGE(WARNING "Stack trace for failed unit test")
  ENDIF()

ENDFUNCTION()


FUNCTION(UNITTEST_STRING_REGEX INPUT_STRING)

  PARSE_ARGUMENTS(
     PARSE
     "REGEX_STRINGS"
     ""
     ${ARGN}
     )

  FOREACH(REGEX ${PARSE_REGEX_STRINGS})

    MATH( EXPR NUMRUN ${UNITTEST_OVERALL_NUMRUN}+1 )
    GLOBAL_SET(UNITTEST_OVERALL_NUMRUN ${NUMRUN})

    STRING(REGEX MATCH "${REGEX}" REGEX_MATCH_RESULT "${INPUT_STRING}")

    IF (REGEX_MATCH_RESULT)
      MESSAGE("  Searching for REGEX {${REGEX}}:  [PASSED]\n")
      MATH( EXPR NUMPASSED ${UNITTEST_OVERALL_NUMPASSED}+1 )
      GLOBAL_SET(UNITTEST_OVERALL_NUMPASSED ${NUMPASSED})
    ELSE()
      MESSAGE("  Searching for REGEX {${REGEX}}:  [FAILED]\n")
      GLOBAL_SET(UNITTEST_OVERALL_PASS FALSE)
      MESSAGE(WARNING "Stack trace for failed unit test")
    ENDIF()

  ENDFOREACH()

ENDFUNCTION()


FUNCTION(UNITTEST_HAS_SUBSTR_CONST VAR_NAME SUBSTR_VAL)

  MATH( EXPR NUMRUN ${UNITTEST_OVERALL_NUMRUN}+1 )
  GLOBAL_SET(UNITTEST_OVERALL_NUMRUN ${NUMRUN})

  MESSAGE(
    "\nCheck:\n"
    "    ${VAR_NAME} =\n"
    "    [${${VAR_NAME}}]\n"
    "  Contains:\n"
    "    [${SUBSTR_VAL}]"
    )

  STRING(FIND "${${VAR_NAME}}" "${SUBSTR_VAL}" SUBSTR_START_IDX)

  IF (${SUBSTR_START_IDX} GREATER -1)
    MESSAGE("  [PASSED]\n")
    MATH( EXPR NUMPASSED ${UNITTEST_OVERALL_NUMPASSED}+1 )
    GLOBAL_SET(UNITTEST_OVERALL_NUMPASSED ${NUMPASSED})
  ELSE()
    MESSAGE("  [FAILED]\n")
    GLOBAL_SET(UNITTEST_OVERALL_PASS FALSE)
    MESSAGE(WARNING "Stack trace for failed unit test")
  ENDIF()

ENDFUNCTION()


FUNCTION(UNITTEST_FILE_REGEX  INPUT_FILE)
  MESSAGE("\nRegexing for strings in the file '${INPUT_FILE}':\n")
  FILE(READ "${INPUT_FILE}" INPUT_FILE_STRING)
  UNITTEST_STRING_REGEX("${INPUT_FILE_STRING}" ${ARGN})
ENDFUNCTION()


FUNCTION(UNITTEST_FINAL_RESULT  EXPECTED_NUMPASSED)
   MESSAGE("\nFinal UnitTests Result: num_run = ${UNITTEST_OVERALL_NUMRUN}\n")
  IF (UNITTEST_OVERALL_PASS)
    IF (UNITTEST_OVERALL_NUMPASSED EQUAL ${EXPECTED_NUMPASSED})
      MESSAGE("Final UnitTests Result: PASSED"
        " (num_passed = ${UNITTEST_OVERALL_NUMPASSED})")
    ELSE()
      MESSAGE("\nError: num_passed = ${UNITTEST_OVERALL_NUMPASSED}"
        " != num_expected = ${EXPECTED_NUMPASSED}")
      MESSAGE("\nFinal UnitTests Result: FAILED\n")
      MESSAGE(SEND_ERROR "FAIL")
    ENDIF()
  ELSE()
    MESSAGE("\nFinal UnitTests Result: FAILED\n")
  ENDIF()
ENDFUNCTION()

