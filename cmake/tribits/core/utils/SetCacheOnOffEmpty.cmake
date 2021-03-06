

FUNCTION(SET_CACHE_ON_OFF_EMPTY VAR INITIAL_VALUE DOCSTR)
  SET(FORCE_ARG)
  FOREACH(ARG ${ARGN})
    IF (ARG STREQUAL FORCE)
      SET(FORCE_ARG FORCE)
    ELSE()
      MESSAGE(FATAL_ERROR "SET_CACHE_ON_OFF_EMPTY(...): Error, last arg '${ARG}' is"
        "invalid!  Must be 'FORCE' or nothing." )
    ENDIF()
  ENDFOREACH()
  SET( ${VAR} "${INITIAL_VALUE}" CACHE STRING "${DOCSTR}" ${FORCE_ARG})
  SET_PROPERTY(CACHE ${VAR} PROPERTY STRINGS "" "ON" "OFF")
ENDFUNCTION()
