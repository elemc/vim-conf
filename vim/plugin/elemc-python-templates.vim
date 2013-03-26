command! -nargs=1 ElemcPythonSingle call s:python_single(<f-args>)
command! -nargs=* ElemcPythonClass call s:python_class(<f-args>)

function! s:python_header_comment (type)
    let f_str = "# ------------------------------------ #"
    let mid_str = "# Python source ". a:type ." (". s:basename .")"
    let mid_str = g:elemc_correct_header_string(mid_str, len(f_str), "#")

    let cmnt = ["#!/usr/bin/env python",
        \       "# -*- Python -*-",
        \       "# -*- coding: utf-8 -*-",
        \       f_str,
        \       mid_str,
        \       "# Author: ". g:elemc_author ." #",
        \       "# ------------------------------------ #",
        \       "# Description: ",
        \       ""]
   return cmnt
endfunction

function! s:python_single_import()
    let content = [ "import sys, os",
        \           ""]
    return content
endfunction

function! s:python_class_import(import_name, baseclass)
    let content = [ "from ". a:import_name ." import ". a:baseclass,
        \           ""]
    return content
endfunction

function! s:python_ident()
    let content = ""
    for i in range(1, 4)
        let content = content . " "
    endfor
    return content
endfunction

function! s:python_single_content ()
    let content = [ "if __name__ == '__main__':",
        \           "    print(sys.argv)",
        \           ""]
    return content
endfunction

function! s:python_class_content (classname, baseclass)
    let content = [ "class ". a:classname ." (". a:baseclass ."):",
        \           "    def __init__ (self):",
        \           "        ". a:baseclass .".__init__(self)",
        \           "        pass",
        \           "",
        \           "    def __del__ (self):",
        \           "        pass",
        \           "",
        \           "    def __str__ (self):",
        \           "        return str()",
        \           "",
        \           ""]
    return content
endfunction

function! s:python_single (sourcename)
    let s:basename = a:sourcename

    call g:elemc_create_file ( a:sourcename )
    call append (0, s:python_header_comment("single"))
    call append (line('$'), s:python_single_import())
    call append (line('$'), s:python_single_content())
    call append (line('$'), "")
endfunction

function! s:python_class (classname, baseclass)
    let filename_part = tolower(a:classname)
    let import_name = tolower(a:baseclass)
    let s:filename_py = filename_part . ".py"
    let s:basename = a:baseclass

    call g:elemc_create_file ( s:filename_py )
    call append (0, s:python_header_comment("class"))
    call append (line('$'), s:python_class_import(import_name, a:baseclass))
    call append (line('$'), s:python_class_content(a:classname, a:baseclass))
    call append (line('$'), "")
    
endfunction
