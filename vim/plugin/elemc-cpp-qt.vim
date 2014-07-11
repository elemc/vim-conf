let s:classname = ""
let s:baseclass = ""
let s:filename_cpp = ""
let s:filename_h = ""
let s:filename_include = ""
let s:headerclassdef = ""

command! -nargs=* ElemcQtNewClass call s:qt_new_class(<f-args>)

function! s:qt_new_class (classname, baseclass)
    let filename_part = tolower(a:classname)
    let s:filename_cpp = "src/" . filename_part . ".cpp"
    let s:filename_include = filename_part . ".h"
    let s:filename_h = "src/" . s:filename_include
    let s:headerclassdef = toupper(a:classname) . "_H"

    let s:classname = a:classname
    let s:baseclass = a:baseclass

    " Part 1. Create CPP file
    call g:Elemc_create_file ( s:filename_cpp )
    call s:qt_cpp_content ()

    " Part 2. Create header file
    call g:Elemc_create_file ( s:filename_h )
    call s:qt_h_content ()
endfunction

function! s:qt_append_include ( name, type )
    let include = ""
    if a:type == "system"
        let include = "#include <". a:name . ">"
    else
        let include = "#include \"". a:name . "\""
    endif

    return include
endfunction

function! s:qt_cpp_constructor ()
    let constr = ["" . s:classname . "::" . s:classname . "(" . s:baseclass . " *parent) : ",
        \       "\t" . s:baseclass . "(parent)",
        \       "{",
        \       "}"]
    return constr
endfunction

function! s:qt_cpp_destructor ()
    let destr = [s:classname . "::~" . s:classname . " () ",
        \       "{",
        \       "}"]
    return destr
endfunction

function! s:qt_header_begin ()
    let begin = ["#ifndef " . s:headerclassdef,
        \       "#define " . s:headerclassdef,
        \       ""]

    return begin
endfunction

function! s:qt_header_end ()
    let end = ["",
        \       "#endif",
        \       ""]
    return end
endfunction

function! s:qt_minimal_class ()
    let class = ["class " . s:classname . " : public " . s:baseclass,
        \       "{",
        \       "Q_OBJECT",
        \       "public:",
        \       "    " . s:classname . " ( " . s:baseclass . " *parent = 0 );",
        \       "    ~" . s:classname . " ();",
        \       "",
        \       "private:",
        \       "",
        \       "};"]
    return class
endfunction

function s:qt_header_comment (type)
    let f_str = "/* ------------------------------------ */"
    let mid_str = "/* C++ class ". a:type ." (" . s:baseclass . ")"
    let mid_str = g:Elemc_correct_header_string( mid_str, len(f_str), "*/")

    let cmnt = ["// -*- C++ -*-",
        \       f_str,
        \       mid_str,
        \       "/* Author: ". g:elemc_author ." */",
        \       "/* ------------------------------------ */",
        \       "",
        \       "/* Name: (". s:classname . ")",
        \       "   Description: ",
        \       "*/"]
   return cmnt
endfunction

function! s:qt_cpp_content ()
    call append (0, s:qt_header_comment("source"))
    call append (line('$'), s:qt_append_include ( s:filename_include, "local"))
    call append (line('$'), "")
    call append (line('$'), s:qt_cpp_constructor())
    call append (line('$'), s:qt_cpp_destructor())
    call append (line('$'), "")
endfunction

function! s:qt_h_content ()
    call append (0, s:qt_header_comment("header"))
    call append (line('$'), s:qt_header_begin())
    call append (line('$'), s:qt_append_include ( s:baseclass, "system"))
    call append (line('$'), "" )
    call append (line('$'), s:qt_minimal_class ())
    call append (line('$'), s:qt_header_end())
    call append (line('$'), "")
endfunction
