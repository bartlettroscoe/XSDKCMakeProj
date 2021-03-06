#
# Testing driver project for XSDK CMake specification
#
# See README.rst for details.
#

CMAKE_MINIMUM_REQUIRED(VERSION 2.8.11)

SET(PROJECT_NAME XSDKCMakeProj)
PROJECT(${PROJECT_NAME}  CXX)

SET(CXX_COMPILER_1  "/usr/bin/c++"  CACHE FILEPATH
  "One valid C++ compiler to test with" )
SET(CXX_COMPILER_2  "/usr/bin/g++"  CACHE FILEPATH
  "Second valid C++ compiler to test with" )
# This is the compiler that CMake finds by default
SET(CXX_DEFAUT_COMPILER  "${CMAKE_CXX_COMPILER}")

# Pull in TriBITS so we can use TRIBITS_ADD_ADVANCED_TEST() and some other
# functions (but this is *not* a TriBITS project.
SET(${PROJECT_NAME}_TRIBITS_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/cmake/tribits"
 CACHE  PATH  "Set in CMakeLists.txt" )
INCLUDE("${${PROJECT_NAME}_TRIBITS_DIR}/TriBITS.cmake")

INCLUDE(CTest)
ENABLE_TESTING()


#
# Print compilers
#

PRINT_VAR(CXX_COMPILER_1)
PRINT_VAR(CXX_COMPILER_2)
PRINT_VAR(CXX_DEFAUT_COMPILER)


#
# Check compiler vars
#

IF (CXX_COMPILER_1  STREQUAL  "")
  MESSAGE(FATAL_ERROR "ERROR: Must set CXX_COMPILER_1!")
ENDIF()

IF (CXX_COMPILER_2  STREQUAL  "")
  MESSAGE(FATAL_ERROR "ERROR: Must set CXX_COMPILER_2!")
ENDIF()

IF (CXX_DEFAUT_COMPILER  STREQUAL  "")
  MESSAGE(FATAL_ERROR "ERROR: A default compiler must be find!")
ENDIF()

IF (CXX_COMPILER_1  STREQUAL  CXX_COMPILER_2)
  MESSAGE(FATAL_ERROR "ERROR: CXX_COMPILER_1 and CXX_COMPILER_2 must be different!")
ENDIF()

IF (CXX_COMPILER_1  STREQUAL  CXX_DEFAUT_COMPILER)
  MESSAGE(FATAL_ERROR "ERROR: CXX_COMPILER_1 and CXX_DEFAUT_COMPILER must be different!")
ENDIF()

IF (CXX_COMPILER_2  STREQUAL  CXX_DEFAUT_COMPILER)
  MESSAGE(FATAL_ERROR "ERROR: CXX_COMPILER_2 and CXX_DEFAUT_COMPILER must be different!")
ENDIF()


#
# Replace regex chars with brachet chars
#
FUNCTION(REPLACE_REGEX_CHARS_WITH_BRACKET_CHARS  STR_IN  STR_OUT)

  STRING(LENGTH "${STR_IN}"  STR_IN_LEN)

  SET(IDX 0)
  SET(STR)
  WHILE(IDX  LESS  STR_IN_LEN)

    STRING(SUBSTRING "${STR_IN}" ${IDX}  1  CHAR)

    IF (CHAR  STREQUAL  ".")
      SET(STR  "${STR}[.]")
    ELSEIF (CHAR  STREQUAL  "+")
      SET(STR  "${STR}[+]")
    ELSE()
      SET(STR  "${STR}${CHAR}")
    ENDIF()

    MATH(EXPR  IDX  "${IDX} + 1")

  ENDWHILE()

  SET(${STR_OUT} ${STR} PARENT_SCOPE)

ENDFUNCTION()


#
# Define a function to do a test using TRIBITS_ADD_ADVANCED_TEST()
#

# Set some vars so we can use it!
SET(${PROJECT_NAME}_TEST_CATEGORIES BASIC)
SET(${PROJECT_NAME}_HOSTNAME dummy)

INCLUDE(TribitsAddAdvancedTest)

FUNCTION( ADD_XSDK_TEST_CASE  TEST_NAME
  USE_XSDK_DEFAULTS  XSDK_USE_COMPILER_ENV_VARS
  ENV_CXX_TO_USE  ENV_CXX_FLAGS_TO_USE
  CMAKE_CXX_TO_USE  CMAKE_CXX_FLAGS_TO_USE
  )
 
  SET(EXAMPLE_DRIVER_PROJ_DIR  "${CMAKE_CURRENT_SOURCE_DIR}/example_driver")

  SET(PASS_REGEX_STR_ARRAY)  
  FOREACH(PASS_REGEX_STR  ${ARGN})
    REPLACE_REGEX_CHARS_WITH_BRACKET_CHARS("${PASS_REGEX_STR}"
      PASS_REGEX_STRING)
    LIST(APPEND PASS_REGEX_STR_ARRAY "${PASS_REGEX_STRING}")
  ENDFOREACH()

  SET(CMND_ARGS)
  IF (USE_XSDK_DEFAULTS)
    LIST(APPEND  CMND_ARGS  -DUSE_XSDK_DEFAULTS=${USE_XSDK_DEFAULTS})
  ENDIF()
  IF (XSDK_USE_COMPILER_ENV_VARS)
    LIST(APPEND  CMND_ARGS  -DXSDK_USE_COMPILER_ENV_VARS=${XSDK_USE_COMPILER_ENV_VARS})
  ENDIF()
  IF (CMAKE_CXX_TO_USE)
    LIST(APPEND  CMND_ARGS  -DCMAKE_CXX_COMPILER=${CMAKE_CXX_TO_USE})
  ENDIF()
  IF (CMAKE_CXX_FLAGS_TO_USE)
    LIST(APPEND  CMND_ARGS  -DCMAKE_CXX_FLAGS=${CMAKE_CXX_FLAGS_TO_USE})
  ENDIF()

  TRIBITS_ADD_ADVANCED_TEST(${TEST_NAME}
    OVERALL_WORKING_DIRECTORY  TEST_NAME
    TEST_0
      CMND  ${CMAKE_COMMAND}
      ARGS  ${CMND_ARGS}
        ${EXAMPLE_DRIVER_PROJ_DIR}
      PASS_REGULAR_EXPRESSION_ALL
        ${PASS_REGEX_STR_ARRAY}
    ENVIRONMENT CXX=${ENV_CXX_TO_USE}  CXXFLAGS=${ENV_CXX_FLAGS_TO_USE}
    )

ENDFUNCTION()


#
# Test cases NoUseXsdkDefaults_NoUseCompilerEnvVars
# 

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_none_none
  FALSE  FALSE
  ""  ""
  ""  ""
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "Before XSDK: BUILD_SHARED_LIBS = ''"
  "Before XSDK: CMAKE_BUILD_TYPE = ''"
  "USE_XSDK_DEFAULTS = 'FALSE'"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before EL: CMAKE_CXX_FLAGS = ''"
  "Before EL: BUILD_SHARED_LIBS = ''"
  "Before EL: CMAKE_BUILD_TYPE = ''"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  "After EL: CMAKE_CXX_FLAGS = ''"
  "After EL: BUILD_SHARED_LIBS = ''"
  "After EL: CMAKE_BUILD_TYPE = ''"
  )

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_cxx1_none
  FALSE  FALSE
  "${CXX_COMPILER_1}"  "-Wall"
  ""  ""
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "Before EL: CMAKE_CXX_COMPILER = ''"
  "Before EL: CMAKE_CXX_FLAGS = ''"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_1}'"
  "After EL: CMAKE_CXX_FLAGS = '-Wall '"
  )

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_none_cxx2
  FALSE  FALSE
  ""  ""
  "${CXX_COMPILER_2}"  "-Wlong-long"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  )

ADD_XSDK_TEST_CASE( NoUseXsdkDefaults_cxx1_cxx2
  FALSE  FALSE
  "${CXX_COMPILER_1}"  "-Wall"
  "${CXX_COMPILER_2}"  "-Wlong-long"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  )


#
# Test cases UseXsdkDefaults_NoUseCompilerEnvVars
# 

ADD_XSDK_TEST_CASE( UseXsdkDefaults_NoUseCompilerEnvVars_none_none
  TRUE  FALSE
  ""  ""
  ""  ""
  "USE_XSDK_DEFAULTS = 'TRUE'"
  "XSDK_USE_COMPILER_ENV_VARS = 'FALSE'"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "Before XSDK: BUILD_SHARED_LIBS = ''"
  "Before XSDK: CMAKE_BUILD_TYPE = ''"
  "Setting default for BUILD_SHARED_LIBS to TRUE!"
  "Setting default for CMAKE_BUILD_TYPE to DEBUG!"
  "Before EL: CMAKE_CXX_COMPILER = ''"
  "Before EL: BUILD_SHARED_LIBS = 'TRUE'"
  "Before EL: CMAKE_BUILD_TYPE = 'DEBUG'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_NoUseCompilerEnvVars_cxx1_none
  TRUE  FALSE
  "${CXX_COMPILER_1}"  "-Wall"
  ""  ""
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "NOT setting CMAKE_CXX_COMPILER from env var CXX='${CXX_COMPILER_1}'!"
  "NOT setting CMAKE_CXX_FLAGS from env var CXXFLAGS='-Wall'!"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  "Before EL: CMAKE_CXX_FLAGS = ''"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  "After EL: CMAKE_CXX_FLAGS = ''"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_NoUseCompilerEnvVars_none_cxx2
  TRUE  FALSE
  ""  ""
  "${CXX_COMPILER_2}"  "-Wlong-long"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_NoUseCompilerEnvVars_cxx1_cxx2
  TRUE  FALSE
  "${CXX_COMPILER_1}"  "-Wall"
  "${CXX_COMPILER_2}"  "-Wlong-long"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  )


#
# Test cases UseXsdkDefaults_UseCompilerEnvVars
# 

ADD_XSDK_TEST_CASE( UseXsdkDefaults_UseCompilerEnvVars_none_none
  TRUE  TRUE
  ""  ""
  ""  ""
  "USE_XSDK_DEFAULTS = 'TRUE'"
  "XSDK_USE_COMPILER_ENV_VARS = 'TRUE'"
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "Before XSDK: BUILD_SHARED_LIBS = ''"
  "Before XSDK: CMAKE_BUILD_TYPE = ''"
  "XSDK: Setting default for BUILD_SHARED_LIBS to TRUE!"
  "XSDK: Setting default for CMAKE_BUILD_TYPE to DEBUG!"
  "Before EL: CMAKE_CXX_COMPILER = ''"
  "Before EL: BUILD_SHARED_LIBS = 'TRUE'"
  "Before EL: CMAKE_BUILD_TYPE = 'DEBUG'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_DEFAUT_COMPILER}'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_UseCompilerEnvVars_cxx1_none
  TRUE  TRUE
  "${CXX_COMPILER_1}"  "-Wall"
  ""  ""
  "Before XSDK: CMAKE_CXX_COMPILER = ''"
  "Before XSDK: CMAKE_CXX_FLAGS = ''"
  "XSDK: Setting CMAKE_CXX_COMPILER from env var CXX='/usr/bin/c++'!"
  "XSDK: Setting CMAKE_CXX_FLAGS from env var CXXFLAGS='-Wall'!"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_1}'"
  "Before EL: CMAKE_CXX_FLAGS = '-Wall '"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_1}'"
  "After EL: CMAKE_CXX_FLAGS = '-Wall '"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_UseCompilerEnvVars_none_cxx2
  TRUE  TRUE
  ""  ""
  "${CXX_COMPILER_2}"  "-Wlong-long"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  )

ADD_XSDK_TEST_CASE( UseXsdkDefaults_UseCompilerEnvVars_cxx1_cxx2
  TRUE  TRUE
  "${CXX_COMPILER_1}"  "-Wall"
  "${CXX_COMPILER_2}"  "-Wlong-long"
  "Before XSDK: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before XSDK: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "Before EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "Before EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  "After EL: CMAKE_CXX_COMPILER = '${CXX_COMPILER_2}'"
  "After EL: CMAKE_CXX_FLAGS = '-Wlong-long'"
  )
