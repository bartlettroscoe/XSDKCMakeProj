
INCLUDE(ConcatStrings)

FUNCTION(APPEND_STRING_VAR_WITH_SEP  STRING_VAR  SEP_STR)
  IF (${STRING_VAR})
    CONCAT_STRINGS( TMP_STRING "${${STRING_VAR}}${SEP_STR}" ${ARGN} )
  ELSE()
    CONCAT_STRINGS( TMP_STRING ${ARGN} )
  ENDIF()
  SET(${STRING_VAR} "${TMP_STRING}" PARENT_SCOPE)
ENDFUNCTION()
