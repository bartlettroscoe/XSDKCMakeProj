
INCLUDE(ParseVariableArguments)
INCLUDE(MultilineSet)
INCLUDE(ConcatStrings)


FUNCTION(COMBINED_OPTION  COMBINED_OPTION_NAME)

  PARSE_ARGUMENTS(
    PARSE
    "DEP_OPTIONS_NAMES;DOCSTR"
    ""
    ${ARGN}
    )


  SET(DEFAULT_VAL ON)
  FOREACH( DEP_OPTION_NAME ${PARSE_DEP_OPTIONS_NAMES})
    IF (NOT ${DEP_OPTION_NAME})
      SET(DEFAULT_VAL OFF)
    ENDIF()
  ENDFOREACH()

  CONCAT_STRINGS(DOCSTR ${PARSE_DOCSTR})

  OPTION(${COMBINED_OPTION_NAME} "${DOCSTR}"
    ${DEFAULT_VAL} )


  SET(ALL_ENABLED TRUE)
  IF (${COMBINED_OPTION_NAME})
    FOREACH( DEP_OPTION_NAME ${PARSE_DEP_OPTIONS_NAMES})
      IF (NOT ${DEP_OPTION_NAME})
        SET(ALL_ENABLED FALSE)
        BREAK()
      ENDIF()
    ENDFOREACH()
  ENDIF()

  IF (NOT ALL_ENABLED)

    SET(OPTION_NAMES "")
    SET(OPTION_NAMES_AND_VALUES "")
    FOREACH( DEP_OPTION_NAME ${PARSE_DEP_OPTIONS_NAMES})
      IF (NOT OPTION_NAMES)
        SET(OPTION_NAMES "${DEP_OPTION_NAME}")
      ELSE()
        SET(OPTION_NAMES "${OPTION_NAMES}, ${DEP_OPTION_NAME}")
      ENDIF()
      SET(OPTION_NAMES_AND_VALUES
        "${OPTION_NAMES_AND_VALUES}  ${DEP_OPTION_NAME}='${${DEP_OPTION_NAME}}'\n")
    ENDFOREACH()

    MESSAGE(FATAL_ERROR
      "Error: you can not enable the option ${COMBINED_OPTION_NAME} unless"
      " you also enable the options ${OPTION_NAMES}.  The current option"
      "values are:\n${OPTION_NAMES_AND_VALUES}" )

  ENDIF()

ENDFUNCTION()
