
INCLUDE(ParseVariableArguments)
INCLUDE(PrintNonemptyVar)


FUNCTION(FIND_PROGRAM_PLUS PROG_VAR)

  PARSE_ARGUMENTS(
    PARSE
    "NAMES;PATHS;DOC"
    ""
    ${ARGN}
    )

  PRINT_NONEMPTY_VAR(${PROG_VAR})

  IF (IS_ABSOLUTE ${PROG_VAR})
    SET(NAMES_ARGS ${PARSE_NAMES})
  ELSE()
    SET(NAMES_ARGS ${${PROG_VAR}} ${PARSE_NAMES})
    SET(${PROG_VAR} "${PROG_VAR}-NOTFOUND" CACHE FILEPATH "" FORCE)
  ENDIF()

  SET(DOC "${PARSE_DOC}  Can be full path or just exec name.")

  FIND_PROGRAM( ${PROG_VAR}
    NAMES ${NAMES_ARGS}
    PATHS ${PARSE_PATHS}
    DOC ${DOC}
    NO_DEFAULT_PATH
    )
  FIND_PROGRAM( ${PROG_VAR}
    NAMES ${NAMES_ARGS}
    DOC ${DOC}
    )
  MARK_AS_ADVANCED(${PROG_VAR})

  PRINT_NONEMPTY_VAR(${PROG_VAR})

ENDFUNCTION()
