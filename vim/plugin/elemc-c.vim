let s:sourcename = ""
let s:filename_c = ""
let s:filename_h = ""
let s:filename_include = ""
let s:headerclassdef = ""

command! -nargs=1 ElemcCNewSource call s:c_new_source(<f-args>)
command! -nargs=1 ElemcCNewOneSource call s:c_new_one_source(<f-args>)

function! s:c_new_source (sourcename)
    let filename_part = tolower(a:sourcename)
    let s:filename_c = filename_part . ".c"
    let s:filename_include = filename_part . ".h"
    let s:filename_h = s:filename_include
    let s:headerclassdef = toupper(a:sourcename) . "_H"

    let s:sourcename = a:sourcename

    " Part 1. Create C file
    call g:Elemc_create_file ( s:filename_c )
    call s:c_c_content ()

    " Part 2. Create header file
    call g:Elemc_create_file ( s:filename_h )
    call s:c_h_content ()
endfunction

function! s:c_new_one_source (sourcename)
    let filename_part = tolower(a:sourcename)
    let s:filename_c = filename_part . ".c"

    " Part 1. Create CPP file
    call g:Elemc_create_file ( s:filename_c )
    call s:c_c_content ()
endfunction

function! s:c_append_include ( name, type )
    let include = ""
    if a:type == "system"
        let include = "#include <". a:name . ">"
    else
        let include = "#include \"". a:name . "\""
    endif

    return include
endfunction

function! s:c_header_begin ()
    let begin = ["#ifndef " . s:headerclassdef,
        \       "#define " . s:headerclassdef,
        \       ""]

    return begin
endfunction

function! s:c_header_end ()
    let end = ["",
        \       "#endif",
        \       ""]
    return end
endfunction

function s:c_header_comment (type)
    let f_str = "/* ------------------------------------ */"
    let mid_str = "/* C source ". a:type
    let mid_str = g:Elemc_correct_header_string( mid_str, len(f_str), "*/")

    let cmnt = ["// -*- C -*-",
        \       f_str,
        \       mid_str,
        \       "/* Author: ". g:elemc_author ." */",
        \       "/* ------------------------------------ */",
        \       "",
        \       "/* Name: (". s:sourcename . ")",
        \       "   Description: ",
        \       "*/"]
   return cmnt
endfunction

function! s:c_c_content ()
    call append (0, s:c_header_comment("source"))
    call append (line('$'), s:c_append_include ( s:filename_include, "local"))
    call append (line('$'), "")
endfunction

function! s:c_h_content ()
    call append (0, s:c_header_comment("header"))
    call append (line('$'), s:c_header_begin())
    call append (line('$'), "" )
    call append (line('$'), "#ifdef __cplusplus")
    call append (line('$'), "extern \"C\"{")
    call append (line('$'), "#endif")
    call append (line('$'), "" )
    call append (line('$'), "" )
    call append (line('$'), "" )
    call append (line('$'), "#ifdef __cplusplus")
    call append (line('$'), "}")
    call append (line('$'), "#endif")

    call append (line('$'), s:c_header_end())
endfunction
