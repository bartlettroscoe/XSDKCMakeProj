
FUNCTION(PREPEND_CMNDLINE_ARGS  CMNDLINE_VAR_NAME  EXTRAARGS)
  IF (${CMNDLINE_VAR_NAME})
    SET(${CMNDLINE_VAR_NAME} "${EXTRAARGS} ${${CMNDLINE_VAR_NAME}}" PARENT_SCOPE)
  ELSE()
    SET(${CMNDLINE_VAR_NAME} "${EXTRAARGS}" PARENT_SCOPE)
  ENDIF()
ENDFUNCTION()
