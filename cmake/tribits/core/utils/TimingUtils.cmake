

INCLUDE(Split)

FUNCTION(TIMER_GET_RAW_SECONDS   SECONDS_DEC_OUT)
  EXECUTE_PROCESS(COMMAND date "+%s.%N" OUTPUT_STRIP_TRAILING_WHITESPACE
    OUTPUT_VARIABLE SECONDS_DEC)
  SET(${SECONDS_DEC_OUT} ${SECONDS_DEC} PARENT_SCOPE)
ENDFUNCTION()


FUNCTION(TIMER_GET_REL_SECONDS  ABS_SECONDS_DEC_START
  ABS_SECONDS_DEC_END  SECONDS_REL_OUT
  )
  SET(DECIMAL_PLACES 3)
  TIMER_GET_TRUNCATED_COMBINED_INT_FROM_DECIMAL_NUM(
    ${ABS_SECONDS_DEC_START}  ${DECIMAL_PLACES}  SECONDS_START_INT)
  TIMER_GET_TRUNCATED_COMBINED_INT_FROM_DECIMAL_NUM(
    ${ABS_SECONDS_DEC_END}  ${DECIMAL_PLACES}  SECONDS_END_INT)

  MATH(EXPR SECONDS_REL_INT "${SECONDS_END_INT} - ${SECONDS_START_INT}")

  TIMER_GET_DECIMAL_NUM_FRUM_TRUNCATED_COMBINED_INT(
    ${SECONDS_REL_INT}    ${DECIMAL_PLACES}  SECONDS_REL )

  SET(${SECONDS_REL_OUT} "${SECONDS_REL}" PARENT_SCOPE)

ENDFUNCTION()


FUNCTION(TIMER_PRINT_REL_TIME  ABS_SECONDS_DEC_START   ABS_SECONDS_DEC_END  MESSAGE_STR )

  TIMER_GET_REL_SECONDS(${ABS_SECONDS_DEC_START}  ${ABS_SECONDS_DEC_END}  SECONDS_REL)

  SPLIT(${SECONDS_REL}  "[.]"   SECONDS_REL_ARRAY)
  LIST(GET  SECONDS_REL_ARRAY  0  SECONDS_REL_S)
  LIST(GET  SECONDS_REL_ARRAY  1  SECONDS_REL_NS)

  MATH(EXPR  MINUTES_REL  "${SECONDS_REL_S}/60")
  MATH(EXPR  SECONDS_REL_REMAINING  "${SECONDS_REL_S} - 60*${MINUTES_REL}")
  MESSAGE("${MESSAGE_STR}: ${MINUTES_REL}m${SECONDS_REL_REMAINING}.${SECONDS_REL_NS}s")
ENDFUNCTION()




FUNCTION(TIMER_GET_TRUNCATED_COMBINED_INT_FROM_DECIMAL_NUM
  ABS_SECONDS_DEC_IN  DECIMAL_PLACES  SECONDS_NS_INT_OUT
  )

  SPLIT(${ABS_SECONDS_DEC_IN} "[.]"  ABS_SECONDS_DEC_IN_ARRAY)
  LIST(GET  ABS_SECONDS_DEC_IN_ARRAY  0  ABS_SECONDS_DEC_IN_S)
  LIST(GET  ABS_SECONDS_DEC_IN_ARRAY  1  ABS_SECONDS_DEC_IN_NS)

  STRING(SUBSTRING ${ABS_SECONDS_DEC_IN_S} ${DECIMAL_PLACES} -1  SECONDS_S_TRUNCATED)
  STRING(SUBSTRING ${ABS_SECONDS_DEC_IN_NS} 0 ${DECIMAL_PLACES}  SECONDS_NS_TRUNCATED)

  SET(${SECONDS_NS_INT_OUT} "${SECONDS_S_TRUNCATED}${SECONDS_NS_TRUNCATED}"
    PARENT_SCOPE)

ENDFUNCTION()


FUNCTION(TIMER_GET_DECIMAL_NUM_FRUM_TRUNCATED_COMBINED_INT
  SECONDS_NS_INT_IN  DECIMAL_PLACES
  SECONDS_DEC_IN_OUT
  )

  STRING(LENGTH ${SECONDS_NS_INT_IN}  COMBINED_INT_LEN)
  MATH(EXPR SEC_DIGITS "${COMBINED_INT_LEN}-${DECIMAL_PLACES}")

  IF (SEC_DIGITS GREATER 0)
    STRING(SUBSTRING ${SECONDS_NS_INT_IN} 0 ${SEC_DIGITS}  SECONDS_S_TRUNCATED)
    STRING(SUBSTRING ${SECONDS_NS_INT_IN} ${SEC_DIGITS} -1  SECONDS_NS_TRUNCATED)
  ELSE()
     SET(SECONDS_S_TRUNCATED 0)

     MATH(EXPR NUM_ZEROS "${DECIMAL_PLACES}-${COMBINED_INT_LEN}")
     SET(SECONDS_NS_TRUNCATED ${SECONDS_NS_INT_IN})
     SET(LOOP_IDX 0)
     WHILE (LOOP_IDX LESS ${NUM_ZEROS})
       SET(SECONDS_NS_TRUNCATED "0${SECONDS_NS_TRUNCATED}")
       MATH(EXPR LOOP_IDX "${LOOP_IDX}+1")
     ENDWHILE()
  ENDIF()


  SET(${SECONDS_DEC_IN_OUT} "${SECONDS_S_TRUNCATED}.${SECONDS_NS_TRUNCATED}"
    PARENT_SCOPE)

ENDFUNCTION()

