include(CMakeParseArguments)

function(def_executable exec)

  string(TOUPPER ${exec} EXEC)

  set(EXEC_OPTIONS)
  set(EXEC_SINGLE_ARGS)
  set(EXEC_MULTI_ARGS SOURCES DEPENDS CONDITIONS LINK_LIBS)
  cmake_parse_arguments(exec
    "${EXEC_OPTIONS}"
    "${EXEC_SINGLE_ARGS}"
    "${EXEC_MULTI_ARGS}"
    "${ARGN}"
    )

  if(NOT exec_SOURCES)
    message(FATAL_ERROR "def_executable for ${EXEC} has an empty source list.")
  endif()

  set(cache_var BUILD_${EXEC})
  set(${cache_var} ON CACHE BOOL "Enable ${EXEC} compilation.")

  set(build_type_cache_var EXEC${EXEC}_BUILD_TYPE)
  set(${build_type_cache_var} "" CACHE STRING
    "Target specific build configuration for exec${exec}")

  string(TOUPPER "${${build_type_cache_var}}" EXEC_BUILD_TYPE)
  set(exec_flags "${CMAKE_CXX_FLAGS} ${CMAKE_C_FLAGS} ${CMAKE_CXX_FLAGS_${EXEC_BUILD_TYPE}} ${CMAKE_C_FLAGS_${EXEC_BUILD_TYPE}}")

  if(exec_CONDITIONS)
    foreach(cond ${exec_CONDITIONS})
      if(NOT ${cond})
	set(${cache_var} OFF)
	message("${cache_var} is false because ${cond} is false.")
	return()
      endif()
    endforeach()
  endif()

  if(exec_DEPENDS)
    foreach(dep ${exec_DEPENDS})
      string(TOUPPER ${dep} DEP)
      if(NOT TARGET ${dep})
	set(${cache_var} OFF)
	message("${cache_var} is false because ${dep} is not being built.")
	return()
      endif()
    endforeach()
  endif()

  if(${cache_var})
    add_executable(${exec} ${exec_SOURCES})
    set_target_properties(${exec} PROPERTIES COMPILE_FLAGS ${exec_flags})

    if(exec_DEPENDS)
      target_link_execraries(${exec} ${exec_DEPENDS})
    endif()

    if(exec_LINK_LIBS)
      target_link_execraries(${exec} ${exec_LINK_LIBS})
    endif()
  endif()
endfunction()