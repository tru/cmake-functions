# Replacement for aux_source_directory that also adds all headers
# Is useful because you probably want your headers to show up in your IDE
macro(find_all_sources DIRECTORY VARIABLE)
  aux_source_directory(${DIRECTORY} ${VARIABLE})
  file(GLOB headers ${DIRECTORY}/*h)
  list(APPEND ${VARIABLE} ${headers})
endmacro()

# function to collect all the sources from sub-directories
# into a single list
function(add_sources)
  get_property(is_defined GLOBAL PROPERTY SRCS_LIST DEFINED)
  if(NOT is_defined)
    define_property(GLOBAL PROPERTY SRCS_LIST
      BRIEF_DOCS "List of source files"
      FULL_DOCS "List of source files to be compiled in one library")
  endif()
  
  # make absolute paths
  set(SRCS)
  foreach(s IN LISTS ARGN)
    if(NOT IS_ABSOLUTE "${s}")
      get_filename_component(s "${s}" ABSOLUTE)
    endif()
    list(APPEND SRCS "${s}")
  endforeach()

# Code similar to this below can be used to create a static library
# of this collection of sources, or set some fancy names in the 
# IDE

#  string(REPLACE ${CMAKE_SOURCE_DIR} "" SUBDIR ${CMAKE_CURRENT_SOURCE_DIR})
#  string(TOLOWER ${SUBDIR} SUBDIR)
#  string(REPLACE "/" "\\" LIBNAME ${SUBDIR})
#  source_group(${LIBNAME} FILES ${SRCS})

  # add it to the global list.
  set_property(GLOBAL APPEND PROPERTY SRCS_LIST ${SRCS})
endfunction(add_sources)
