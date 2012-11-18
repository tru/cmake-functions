# CMake module that adds a pre-compiled header macro.
# Currently only supports MSVC, but could be used to add at least clang support
#
# Copyright 2012 Tobias Hieta <tobias@plexapp.com>
#

MACRO(ADD_MSVC_PRECOMPILED_HEADER PrecompiledHeader PrecompiledSource SourcesVar)
  IF(MSVC)
    GET_FILENAME_COMPONENT(PrecompiledBasename ${PrecompiledHeader} NAME_WE)
    SET(PrecompiledBinary "${PrecompiledBasename}.pch")
    SET(Sources ${${SourcesVar}})

    SET_SOURCE_FILES_PROPERTIES(${PrecompiledSource}
                                PROPERTIES COMPILE_FLAGS "/Yc\"${PrecompiledHeader}\" /Fp\"${PrecompiledBinary}\""
                                           OBJECT_OUTPUTS "${PrecompiledBinary}")

    # Collect all CPP sources
    foreach(src ${Sources})
      get_filename_component(SRCEXT ${src} EXT)
      if(${SRCEXT} STREQUAL ".cpp")
        list(APPEND CXX_SRCS ${src})
      endif()
    endforeach()

    SET_SOURCE_FILES_PROPERTIES(${CXX_SRCS}
                                PROPERTIES COMPILE_FLAGS "/Yu\"${PrecompiledHeader}\" /FI\"${PrecompiledHeader}\" /Fp\"${PrecompiledBinary}\""
                                           OBJECT_DEPENDS "${PrecompiledBinary}")  
    # Add precompiled header to SourcesVar
    LIST(APPEND ${SourcesVar} ${PrecompiledSource})
  ENDIF(MSVC)
ENDMACRO(ADD_MSVC_PRECOMPILED_HEADER)
