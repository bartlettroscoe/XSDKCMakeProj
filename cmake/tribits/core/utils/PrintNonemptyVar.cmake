
INCLUDE(AssertDefined)
INCLUDE(PrintVar)


FUNCTION(PRINT_NONEMPTY_VAR VARIBLE_NAME)
  ASSERT_DEFINED(VARIBLE_NAME)
  IF (NOT "${${VARIBLE_NAME}}" STREQUAL "")
    PRINT_VAR(${VARIBLE_NAME})
  ENDIF()
ENDFUNCTION()
