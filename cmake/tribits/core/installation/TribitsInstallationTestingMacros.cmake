


FUNCTION(TRIBITS_FIND_PROJECT_INSTALL)

  IF(${PROJECT_NAME}_ENABLE_INSTALLATION_TESTING)
    IF(${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE("Searching for ${PROJECT_NAME} installation at ${${PROJECT_NAME}_INSTALLATION_DIR}/include")
    ENDIF()
    FIND_PACKAGE(${PROJECT_NAME} REQUIRED HINTS ${${PROJECT_NAME}_INSTALLATION_DIR})

    IF(${PROJECT_NAME}_VERBOSE_CONFIGURE)
      MESSAGE("Found ${PROJECT_NAME} installation version ${${PROJECT_NAME}_VERSION} at ${${PROJECT_NAME}_DIR}")
    ENDIF()

    SET(${PROJECT_NAME}_INSTALLATION_VERSION           ${${PROJECT_NAME}_VERSION}           PARENT_SCOPE)
    SET(${PROJECT_NAME}_INSTALLATION_INCLUDE_DIRS      ${${PROJECT_NAME}_INCLUDE_DIRS}      PARENT_SCOPE)
    SET(${PROJECT_NAME}_INSTALLATION_LIBRARY_DIRS      ${${PROJECT_NAME}_LIBRARY_DIRS}      PARENT_SCOPE)
    SET(${PROJECT_NAME}_INSTALLATION_LIBRARIES         ${${PROJECT_NAME}_LIBRARIES}         PARENT_SCOPE)
    SET(${PROJECT_NAME}_INSTALLATION_PACKAGE_LIST      ${${PROJECT_NAME}_PACKAGE_LIST}      PARENT_SCOPE)
    SET(${PROJECT_NAME}_INSTALLATION_BUILD_SHARED_LIBS ${${PROJECT_NAME}_BUILD_SHARED_LIBS} PARENT_SCOPE)
    SET(${PROJECT_NAME}_INSTALLATION_TPL_INCLUDE_DIRS  ${${PROJECT_NAME}_TPL_INCLUDE_DIRS}  PARENT_SCOPE)
    SET(${PROJECT_NAME}_INSTALLATION_TPL_LIBRARY_DIRS  ${${PROJECT_NAME}_TPL_LIBRARY_DIRS}  PARENT_SCOPE)
    SET(${PROJECT_NAME}_INSTALLATION_TPL_LIBRARIES     ${${PROJECT_NAME}_TPL_LIBRARIES}     PARENT_SCOPE)

    FOREACH(TRIBITS_PACKAGE ${${PROJECT_NAME}_PACKAGE_LIST})
      SET(${TRIBITS_PACKAGE}_INSTALLATION_INCLUDE_DIRS     ${${TRIBITS_PACKAGE}_INCLUDE_DIRS}     PARENT_SCOPE)
      SET(${TRIBITS_PACKAGE}_INSTALLATION_LIBRARY_DIRS     ${${TRIBITS_PACKAGE}_LIBRARY_DIRS}     PARENT_SCOPE)
      SET(${TRIBITS_PACKAGE}_INSTALLATION_LIBRARIES        ${${TRIBITS_PACKAGE}_LIBRARIES}        PARENT_SCOPE)
      SET(${TRIBITS_PACKAGE}_INSTALLATION_TPL_INCLUDE_DIRS ${${TRIBITS_PACKAGE}_TPL_INCLUDE_DIRS} PARENT_SCOPE)
      SET(${TRIBITS_PACKAGE}_INSTALLATION_TPL_LIBRARY_DIRS ${${TRIBITS_PACKAGE}_TPL_LIBRARY_DIRS} PARENT_SCOPE)
      SET(${TRIBITS_PACKAGE}_INSTALLATION_TPL_LIBRARIES    ${${TRIBITS_PACKAGE}_TPL_LIBRARIES}    PARENT_SCOPE)
    ENDFOREACH()

  ENDIF()
ENDFUNCTION()
