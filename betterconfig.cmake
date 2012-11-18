
# better_find_library does a few things
# 1) it searches either the default path (system libraries) or a pre-defined path for
#    well known or own dependencies
# 2) defines some good variables like <LIB>_SONAME for the name of the shared object
#    HAVE_<LIB> for use in config.h later on.
# 3) It also adds all libraries to a list called CONFIG_LINK_LIBRARIES if the argument
#    addtolinklist is set to 1, this makes it easier to link the binary to this library later
#
#  Example usage:
#  set(external_libs sqlite3 boost_thread boost_system png tiff)
#  foreach(lib ${external_libs})
#    better_find_library(${lib} 0 0 "" 1)
#  endforeach()
#
#  target_link_libraries(MyExecutable ${CONFIG_LINK_LIBRARIES})
#

# function to find library and set the variables we need
macro(better_find_library lib framework nodefaultpath searchpath addtolinklist)
  string(TOUPPER ${lib} LIBN)

  # find the library, just searching in our paths
  if(${nodefaultpath})
      find_library(CONFIG_LIBRARY_${LIBN} ${lib} PATHS ${searchpath} ${searchpath}64 NO_DEFAULT_PATH)
  else()
	    find_library(CONFIG_LIBRARY_${LIBN} ${lib} ${searchpath})
  endif()

  if(CONFIG_LIBRARY_${LIBN} MATCHES "NOTFOUND")
      message("** Could not detect ${LIBN}")
  else()
      # get the actual value
      get_property(l VARIABLE PROPERTY CONFIG_LIBRARY_${LIBN})
      
      # resolve any symlinks
      get_filename_component(REALNAME ${l} REALPATH)

      # split out the library name
      get_filename_component(FNAME ${REALNAME} NAME)
      
      # set the SONAME variable, needed for DllPaths_generated.h
      set(${LIBN}_SONAME ${FNAME} CACHE string "the soname for the current library")
      
      # set the HAVE_LIBX variable
      set(HAVE_LIB${LIBN} 1 CACHE string "the HAVE_LIBX variable")
      
      # if this is a framework we need to mark it as advanced
      if(${framework})
        mark_as_advanced(CONFIG_LIBRARY_${LIBN})
      endif()
      
      if(${addtolinklist})
        list(APPEND CONFIG_LINK_LIBRARIES ${l})
      else()
        list(APPEND CONFIG_INSTALL_LIBRARIES ${REALNAME})
      endif()
  endif()
endmacro()
