

INCLUDE(TribitsHostType)




SET(PLH_NUM_FIELDS_PER_PACKAGE 3)
SET(PLH_NUM_PACKAGE_DIR_OFFSET 1)
SET(PLH_NUM_PACKAGE_CLASSIFICATION_OFFSET 2)


MACRO(TRIBITS_SET_PACKAGE_TO_EX  PACKAGE_NAME)
  LIST(FIND ${PROJECT_NAME}_PACKAGES_AND_DIRS_AND_CLASSIFICATIONS
    ${PACKAGE_NAME} PACKAGE_NAME_IDX)
  IF (PACKAGE_NAME_IDX EQUAL -1)
    MESSAGE(
      "\n***"
      "\n*** WARNING: Package ${PACKAGE_NAME} not found in list of packages!"
      "\n***\n"
      )
  ELSE()
    MATH(EXPR PACKAGE_CLASSIFICATION_IDX
      "${PACKAGE_NAME_IDX}+${PLH_NUM_PACKAGE_CLASSIFICATION_OFFSET}")
    LIST(INSERT ${PROJECT_NAME}_PACKAGES_AND_DIRS_AND_CLASSIFICATIONS
      ${PACKAGE_CLASSIFICATION_IDX} EX )
    MATH(EXPR PACKAGE_CLASSIFICATION_IDX_PLUS_1
      "${PACKAGE_CLASSIFICATION_IDX}+1")
    LIST(REMOVE_AT ${PROJECT_NAME}_PACKAGES_AND_DIRS_AND_CLASSIFICATIONS
      ${PACKAGE_CLASSIFICATION_IDX_PLUS_1} )
  ENDIF()

ENDMACRO()


MACRO( TRIBITS_DISABLE_PACKAGE_ON_PLATFORMS  PACKAGE_NAME )
  FOREACH(HOSTTYPE ${ARGN})
    IF (${PROJECT_NAME}_HOSTTYPE STREQUAL ${HOSTTYPE})
      TRIBITS_SET_PACKAGE_TO_EX(${PACKAGE_NAME})
      IF (${PROJECT_NAME}_ENABLE_${PACKAGE_NAME})
        MESSAGE(
          "\n***"
          "\n*** WARNING: User has set ${PROJECT_NAME}_ENABLE_${PACKAGE_NAME}=ON but the"
          "\n*** package ${PACKAGE_NAME} is not supported on this platform type '${HOSTTYPE}'!"
          "\n***\n"
          )
      ENDIF()
    ENDIF()
  ENDFOREACH()
ENDMACRO()


MACRO( PACKAGE_DISABLE_ON_PLATFORMS  PACKAGE_NAME_IN_ )
  MESSAGE(WARNING "PACKAGE_DISABLE_ON_PLATFORMS() is deprecated!"
    "  Use TRIBITS_DISABLE_PACKAGE_ON_PLATFORMS() instead!")
  TRIBITS_DISABLE_PACKAGE_ON_PLATFORMS(${PACKAGE_NAME_IN_} ${ARGN})
ENDMACRO()



FUNCTION(TRIBITS_UPDATE_PS_PT_SS_ST  THING_TYPE  THING_NAME  TESTGROUP_VAR)


  SET(TESTGROUP_IN ${${TESTGROUP_VAR}})

  IF (TESTGROUP_IN STREQUAL PS)
    IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE("-- " "WARNING: ${THING_TYPE} ${THING_NAME} TESTGROUP 'PS' is depricated."
        "  Use 'PT' instead!")
    ENDIF()
    SET(TESTGROUP_OUT PT)
  ELSEIF (TESTGROUP_IN STREQUAL SS)
    IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE("-- " "WARNING: ${THING_TYPE} ${THING_NAME} TESTGROUP 'SS' is depricated."
        "  Use 'ST' instead!")
    ENDIF()
    SET(TESTGROUP_OUT ST)
  ELSEIF (TESTGROUP_IN STREQUAL TS)
    IF (${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE("-- " "WARNING: ${THING_TYPE} ${THING_NAME} TESTGROUP 'TS' is depricated."
        "  Use 'TT' instead!")
    ENDIF()
    SET(TESTGROUP_OUT TT)
  ELSE()
    SET(TESTGROUP_OUT ${TESTGROUP_IN})
  ENDIF()

  SET(${TESTGROUP_VAR} ${TESTGROUP_OUT} PARENT_SCOPE)

ENDFUNCTION()
