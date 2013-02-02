include(CMakeParseArguments)

function(def_library lib)

  string(TOUPPER ${lib} LIB)

  set(LIB_OPTIONS)
  set(LIB_SINGLE_ARGS)
  set(LIB_MULTI_ARGS SOURCES DEPENDS CONDITIONS LINK_LIBS)
  cmake_parse_arguments(lib
    "${LIB_OPTIONS}"
    "${LIB_SINGLE_ARGS}"
    "${LIB_MULTI_ARGS}"
    "${ARGN}"
    )

  if(NOT lib_SOURCES)
    message(FATAL_ERROR "def_library for ${LIB} has an empty source list.")
  endif()

  set(cache_var BUILD_${LIB})
  set(${cache_var} ON CACHE BOOL "Enable ${LIB} compilation.")

  if(lib_CONDITIONS)
    foreach(cond ${lib_CONDITIONS})
      if(NOT ${cond})
	set(${cache_var} OFF)
	message("${cache_var} is false because ${cond} is false.")
	return()
      endif()
    endforeach()
  endif()

  if(lib_DEPENDS)
    foreach(dep ${lib_DEPENDS})
      string(TOUPPER ${dep} DEP)
      if(NOT TARGET ${dep})
	set(${cache_var} OFF)
	message("${cache_var} is false because ${dep} is not being built.")
	return()
      endif()
    endforeach()
  endif()

  if(${cache_var})
    add_library(${lib} ${lib_SOURCES})
    target_link_libraries(${lib} "${lib_DEPENDS}" "${lib_LINK_LIBS}")
  endif()
endfunction()