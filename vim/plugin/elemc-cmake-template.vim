
command! -nargs=1 ElemcCMakeApplication call s:cmake_app(<f-args>)
command! -nargs=1 ElemcCMakeLibrary call s:cmake_lib(<f-args>)

function! s:cmake_header(type, basename)
    let f_str =   "# ------------------------------------ #"
    let mid_str = "# CMake ". a:type .""
    let mid2_str= "# Project ". a:basename .""
    
    let mid_str = g:elemc_correct_header_string(mid_str, len(f_str), "#")
    let mid2_str = g:elemc_correct_header_string(mid2_str, len(f_str), "#")

    let cmnt = ["# -*- CMake -*-",
        \       f_str,
        \       mid_str,
        \       mid2_str,
        \       "# Author: ". g:elemc_author ." #",
        \       "# ------------------------------------ #",
        \       "",
        \       "cmake_minimum_required (VERSION 2.8.0)",
        \       ""]
   return cmnt
endfunction

function! s:cmake_debug_section()
    let content = [
        \       "if (NOT DEBUG)",
        \       "    if ( CMAKE_BUILD_TYPE STREQUAL Debug )",
        \       "        set (DEBUG 1)",
        \       "    else ( CMAKE_BUILD_TYPE STREQUAL Debug )",
        \       "        set (DEBUG 0)",
        \       "    endif ( CMAKE_BUILD_TYPE STREQUAL Debug )",
        \       "endif (NOT DEBUG)",
        \       ""]
    return content
endfunction

function! s:cmake_variables_section( project_name )
    let content = [
        \       "set (PROJECT_NAME ". a:project_name .")",
        \       "set (PROJECT_VERSION 0.0.1)",
        \       "set (HEADERS",
        \       ")",
        \       "set (SOURCES",
        \       "    main.c)",
        \       "project (${PROJECT_NAME})",
        \       "set (BUILD_PROJECT_LIBRARIES)",
        \       "",
        \       "configure_file (",
        \       "    \"${PROJECT_SOURCE_DIR}/config.h.in\"",
        \       "    \"${PROJECT_BINARY_DIR}/config.h\"",
        \       ")",
        \       "include_directories (${CMAKE_CURRENT_BINARY_DIR} src)",
        \       "",
        \       "source_group (\"Header Files\" FILES ${HEADERS})",
        \       "source_group (\"Source Files\" FILES ${SOURCES})",
        \       "",
        \       "\# compile type",
        \       "if (WIN32)",
        \       "    set (GUI_TYPE WIN32)",
        \       "    set (RC_FILE ${PROJECT_SOURCE_DIR}/${PROJECT_NAME}.rc)",
        \       "    ADD_CUSTOM_COMMAND( OUTPUT ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.o",
        \       "        COMMAND windres.exe -I${CMAKE_CURRENT_SOURCE_DIR} -i${CMAKE_CURRENT_SOURCE_DIR}/${PROJECT_NAME}.rc",
        \       "        -o ${CMAKE_CURRENT_BINARY_DIR}/${PROJECT_NAME}.o )",
        \       "elseif ( APPLE )",
        \       "    set ( GUI_TYPE MACOSX_BUNDLE )",
        \       "endif (WIN32)",
        \       "",
        \       "add_executable (${PROJECT_NAME} ${GUI_TYPE} ${HEADERS} ${SOURCES})",
        \       "target_link_libraries (${PROJECT_NAME} ${BUILD_PROJECT_LIBRARIES})",
        \       "",
        \       "\# Installation UNIX",
        \       "if (UNIX AND NOT APPLE)",
        \       "    install (TARGETS ${PROJECT_NAME} DESTINATION bin)",
        \       "endif (UNIX AND NOT APPLE)",
        \       ""]
    return content
endfunction

function! s:cmake_app(project_name)
   call g:elemc_create_file( "CMakeLists.txt" )
   call append (0, s:cmake_header("application", a:project_name))
   call append (line('$'), s:cmake_debug_section())
   call append (line('$'), s:cmake_variables_section( a:project_name ))
   call g:elemc_create_file( "config.h.in" )
endfunction


