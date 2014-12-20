

FUNCTION( GET_LAST_DIR_NAME  INPUT_DIR  OUTPUT_DIR_VAR )
  FILE(TO_CMAKE_PATH "${INPUT_DIR}" STANDARD_INPUT_DIR)
  STRING(REGEX REPLACE "/.+/(.+)" "\\1" LOCAL_OUTPUT_DIR "${STANDARD_INPUT_DIR}")
  SET(${OUTPUT_DIR_VAR} "${LOCAL_OUTPUT_DIR}" PARENT_SCOPE)
ENDFUNCTION()
