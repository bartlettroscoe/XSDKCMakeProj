

INCLUDE(TribitsConstants)
INCLUDE(TribitsListHelpers)

INCLUDE(PrintVar)
INCLUDE(Split)

MACRO(TRIBITS_REPOSITORY_DEFINE_TPLS)
  ASSERT_DEFINED(REPOSITORY_NAME)
  SET(${REPOSITORY_NAME}_TPLS_FINDMODS_CLASSIFICATIONS "${ARGN}")
ENDMACRO()



MACRO(TRIBITS_PROCESS_TPLS_LISTS  REPOSITORY_NAME  REPOSITORY_DIR)

  IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
    MESSAGE("TRIBITS_PROCESS_TPLS_LISTS:  '${REPOSITORY_NAME}'  '${REPOSITORY_DIR}'")
  ENDIF()

  SET(TRIBITS_PROCESS_TPLS_LISTS_DEBUG OFF)

  SET(TPL_NAME_OFFSET 0)
  SET(TPL_FINDMOD_OFFSET 1)
  SET(TPL_CLASSIFICATION_OFFSET 2)
  SET(TPL_NUM_COLUMNS 3)

  LIST(LENGTH ${REPOSITORY_NAME}_TPLS_FINDMODS_CLASSIFICATIONS
    ${REPOSITORY_NAME}_CURR_NUM_TPLS_FULL)
  MATH(EXPR ${REPOSITORY_NAME}_CURR_NUM_TPLS
    "${${REPOSITORY_NAME}_CURR_NUM_TPLS_FULL}/${TPL_NUM_COLUMNS}")

  IF (${REPOSITORY_NAME}_CURR_NUM_TPLS GREATER 0)

    MATH(EXPR ${REPOSITORY_NAME}_LAST_TPL_IDX
      "${${REPOSITORY_NAME}_CURR_NUM_TPLS}-1")

    FOREACH(TPL_IDX RANGE ${${REPOSITORY_NAME}_LAST_TPL_IDX})

      IF (TRIBITS_PROCESS_TPLS_LISTS_DEBUG)
        PRINT_VAR(TPL_IDX)
      ENDIF()


      MATH(EXPR TPL_NAME_IDX
        "${TPL_IDX}*${TPL_NUM_COLUMNS}+${TPL_NAME_OFFSET}")
      LIST(GET ${REPOSITORY_NAME}_TPLS_FINDMODS_CLASSIFICATIONS ${TPL_NAME_IDX}
        TPL_NAME)
      IF (TRIBITS_PROCESS_TPLS_LISTS_DEBUG)
        PRINT_VAR(TPL_NAME)
      ENDIF()

      MATH(EXPR TPL_FINDMOD_IDX
        "${TPL_IDX}*${TPL_NUM_COLUMNS}+${TPL_FINDMOD_OFFSET}")
      LIST(GET ${REPOSITORY_NAME}_TPLS_FINDMODS_CLASSIFICATIONS ${TPL_FINDMOD_IDX}
        TPL_FINDMOD)
      IF (TRIBITS_PROCESS_TPLS_LISTS_DEBUG)
        PRINT_VAR(TPL_FINDMOD)
      ENDIF()

      MATH(EXPR TPL_CLASSIFICATION_IDX
        "${TPL_IDX}*${TPL_NUM_COLUMNS}+${TPL_CLASSIFICATION_OFFSET}")
      LIST(GET ${REPOSITORY_NAME}_TPLS_FINDMODS_CLASSIFICATIONS ${TPL_CLASSIFICATION_IDX}
        TPL_CLASSIFICATION)
      IF (TRIBITS_PROCESS_TPLS_LISTS_DEBUG)
        PRINT_VAR(TPL_CLASSIFICATION)
      ENDIF()

      SET(TPL_TESTGROUP ${TPL_CLASSIFICATION})

      TRIBITS_UPDATE_PS_PT_SS_ST(TPL  ${TPL_NAME}  TPL_TESTGROUP)


      IF (${TPL_NAME}_FINDMOD)
        IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
          MESSAGE("-- " "NOTE: The TPL ${TPL_NAME} has already been defined so leaving it"
            " in the same location and not adding it again!")
        ENDIF()
      ELSE()
        LIST(APPEND ${PROJECT_NAME}_TPLS ${TPL_NAME})
      ENDIF()


      IF (TPL_TESTGROUP STREQUAL PT
        OR TPL_TESTGROUP STREQUAL ST
        OR TPL_TESTGROUP STREQUAL TT
        OR TPL_TESTGROUP STREQUAL EX
        )
      ELSE()
        MESSAGE(FATAL_ERROR "Error the TPL classification '${TPL_TESTGROUP}'"
          " for the TPL ${TPL_NAME} is not a valid classification." )
      ENDIF()

      IF (NOT ${TPL_NAME}_TESTGROUP) # Allow for testing override
        SET(${TPL_NAME}_TESTGROUP ${TPL_TESTGROUP})
      ENDIF()



      IF ("${REPOSITORY_DIR}" STREQUAL "." OR IS_ABSOLUTE ${TPL_FINDMOD})
        SET(REPOSITORY_DIR_AND_SEP "")
      ELSE()
        SET(REPOSITORY_DIR_AND_SEP "${REPOSITORY_DIR}/")
      ENDIF()

      SET(TPL_FINDMOD "${REPOSITORY_DIR_AND_SEP}${TPL_FINDMOD}")

      SET(TPL_FINDMOD_STD_NAME "FindTPL${TPL_NAME}.cmake")

      IF (TPL_FINDMOD)
        STRING(REGEX MATCH ".+/$" FINDMOD_IS_DIR "${TPL_FINDMOD}")
        IF (FINDMOD_IS_DIR)
          SET(${TPL_NAME}_FINDMOD "${TPL_FINDMOD}${TPL_FINDMOD_STD_NAME}")
        ELSE()
          SET(${TPL_NAME}_FINDMOD ${TPL_FINDMOD})
        ENDIF()
      ELSE()
        SET(${TPL_NAME}_FINDMOD ${TPL_FINDMOD_STD_NAME})
      ENDIF()

      ASSERT_DEFINED(${REPOSITORY_NAME}_TPLS_FILE)
      SET(${TPL_NAME}_TPLS_LIST_FILE ${${REPOSITORY_NAME}_TPLS_FILE})

      IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
        PRINT_VAR(${TPL_NAME}_FINDMOD)
        PRINT_VAR(${TPL_NAME}_TESTGROUP)
        PRINT_VAR(${TPL_NAME}_TPLS_LIST_FILE)
      ENDIF()


      MULTILINE_SET(DOCSTR
        "Enable support for the TPL ${TPL_NAME} in all supported ${PROJECT_NAME} packages."
        "  This can be set to 'ON', 'OFF', or left empty ''."
        )
      SET_CACHE_ON_OFF_EMPTY( TPL_ENABLE_${TPL_NAME} "" ${DOCSTR} )


    ENDFOREACH()

  ENDIF()

  IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
    PRINT_VAR(${PROJECT_NAME}_TPLS)
  ENDIF()


  LIST(LENGTH ${PROJECT_NAME}_TPLS ${PROJECT_NAME}_NUM_TPLS)
  PRINT_VAR(${PROJECT_NAME}_NUM_TPLS)


  IF (${PROJECT_NAME}_TPLS)
    SET(${PROJECT_NAME}_REVERSE_TPLS ${${PROJECT_NAME}_TPLS})
    LIST(REVERSE ${PROJECT_NAME}_REVERSE_TPLS)
  ELSE()
    SET(${PROJECT_NAME}_REVERSE_TPLS)
  ENDIF()

ENDMACRO()
