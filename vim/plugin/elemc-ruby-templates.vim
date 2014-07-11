command! -nargs=1 ElemcRubySingle call s:ruby_single(<f-args>)
command! -nargs=* ElemcRubyClass call s:ruby_class(<f-args>)

function! s:ruby_header_comment (script_type)
    let f_str = "\# ------------------------------------ #"
    let mid_str = "\# Ruby source ". a:script_type ." (". s:basename .")"
    let mid_str = g:Elemc_correct_header_string(mid_str, len(f_str), "\#")

    let cmnt = ["\#!/usr/bin/ruby -w",
        \       "\# -*- coding: utf-8 -*-",
        \       "\# -*-      Ruby     -*-",
        \       f_str,
        \       mid_str,
        \       "\# Author: ". g:elemc_author ." #",
        \       "\# ------------------------------------ #",
        \       "\# Description: ",
        \       ""]
   return cmnt
endfunction

function! s:ruby_ident()
    let content = ""
    for i in range(1, 4)
        let content = content . " "
    endfor
    return content
endfunction

function! s:ruby_single_content ()
    let content = [ "if __FILE__ == $0",
        \           "    puts ARGV",
        \           "end"]
    return content
endfunction

function! s:ruby_class_content (classname, baseclass)
    let content = [ "class ". a:classname ." < ". a:baseclass ."",
        \           "    def initialize",
        \           "        ",
        \           "    end",
        \           "",
        \           "    def to_s",
        \           "        \"\"",
        \           "    end",
        \           "end"]
    return content
endfunction

function! s:ruby_single (sourcename)
    let s:basename = a:sourcename

    call g:Elemc_create_file ( a:sourcename )
    call append (0, s:ruby_header_comment("single"))
    call append (line('$'), s:ruby_single_content())
    call append (line('$'), "")
endfunction

function! s:ruby_class (classname, baseclass)
    let filename_part = tolower(a:classname)
    let import_name = tolower(a:baseclass)
    let s:filename_py = filename_part . ".rb"
    let s:basename = a:baseclass

    call g:Elemc_create_file ( s:filename_py )
    call append (0, s:ruby_header_comment("class"))
    call append (line('$'), s:ruby_class_content(a:classname, a:baseclass))
    call append (line('$'), "")
    
endfunction
