" Vundle
set nocompatible
filetype off
set rtp+=~/.vim/bundle/Vundle.vim
call vundle#begin()

Plugin 'gmarik/Vundle.vim'
" Plugin 'Tagbar'
Plugin 'majutsushi/tagbar'
Plugin 'bufexplorer.zip'
Plugin 'cmake.vim'
Plugin 'spec.vim'
Plugin 'python.vim'
Plugin 'Python-Syntax-Folding'
Plugin 'Python-Syntax'
Plugin 'ruby.vim'
Plugin 'rails.vim'
Plugin 'EasyGrep'
Plugin 'scrooloose/nerdtree'
Plugin 'bling/vim-airline'
Plugin 'vim-airline/vim-airline-themes'
Plugin 'fatih/vim-go'
Plugin 'Shougo/neocomplete'
Plugin 'Konfekt/FastFold'
Plugin 'davidhalter/jedi-vim'
" Plugin 'mitsuhiko/vim-jinja'
Plugin 'mitsuhiko/vim-python-combined'
Plugin 'fisadev/FixedTaskList.vim'

call vundle#end()

filetype plugin indent on
" Vundle END

syntax enable
se nu
set tabstop=4
set shiftwidth=4
set expandtab
set autoindent
set nocompatible
set backspace=indent,eol,start
filetype on
filetype plugin on
set nocp

autocmd FileType javascript set omnifunc=javascriptcomplete#CompleteJS
autocmd FileType html set omnifunc=htmlcomplete#CompleteTags
autocmd FileType css set omnifunc=csscomplete#CompleteCSS
autocmd FileType xml set omnifunc=xmlcomplete#CompleteTags
autocmd FileType php set omnifunc=phpcomplete#CompletePHP
autocmd FileType c set omnifunc=ccomplete#CompleteCPP

autocmd FileType ruby,eruby let g:rubycomplete_buffer_loading = 1 
autocmd FileType ruby,eruby let g:rubycomplete_classes_in_global = 1
autocmd FileType ruby,eruby let g:rubycomplete_rails = 1

" configure tags - add additional tags here or comment out not-used ones
set tags+=~/.vim/tags/cpp
set tags+=~/.vim/tags/wt
" set tags+=~/.vim/tags/sdl
set tags+=~/.vim/tags/qt4

" build tags of your own project with Ctrl-F12
au CursorMovedI,InsertLeave * if pumvisible() == 0|silent! pclose|endif
set completeopt=menuone,menu,longest,preview

" tags update
if has ("unix")
    let s:uname = system("uname")
    if s:uname == "Darwin\n"
        map <C-F12> :!/usr/local/bin/ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
        if has ("gui_rinning")
            au BufWritePost *.c,*.cpp,*.h silent! !/usr/local/bin/ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q . &
        endif
    else
        set guioptions-=T
        set guioptions-=m
        set guitablabel=%t%m

        map <C-F12> :!ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q .<CR>
        if has ("gui_rinning")
            au BufWritePost *.c,*.cpp,*.h silent! !ctags -R --sort=yes --c++-kinds=+p --fields=+iaS --extra=+q . &
        endif

        vnoremap <m-x> "+x
        vnoremap <S-Del> "+x
        " CTRL-C and CTRL-Insert are Copy
        vnoremap <m-c> "+y
        vnoremap <C-Insert> "+y

        " CTRL-V and SHIFT-Insert are Paste
        map <m-v>		"+gP
        map <S-Insert>	"+gP

        cmap <m-v>		<C-R>+
        cmap <S-Insert>	<C-R>+

        " Pasting blockwise and linewise selections is not possible in Insert and
        " Visual mode without the +virtualedit feature.  They are pasted as if they
        " were characterwise instead.
        " Uses the paste.vim autoload script.

        exe 'inoremap <script> <m-v>' paste#paste_cmd['i']
        exe 'vnoremap <script> <m-v>' paste#paste_cmd['v']
        imap <S-Insert>	    <m-v>
        vmap <S-Insert>		<m-v>

        " my old binds
        " nmap <m-v> "+gp
        " imap <m-v> <ESC><m-v>A
        " vmap <m-c> "+y
        " vmap <m-x> "+x
    endif
endif

" keys
if has ("gui_running")
    if has ("gui_gtk2") || has("gui_gtk3")
        set guifont=Monaco\ 9
        behave mswin
    endif
    if has("gui_macvim")
        let macvim_hig_shift_movement = 1
        set guifont=Monaco:h12
    endif
    if has("gui_win32")
    else
    endif
endif

" color and theme
" colorscheme desert
colorscheme molokai
" let g:molokai_original = 1
" let g:rehash256 = 1

" set airline theme
let g:airline_theme='molokai'

" set key for TaskList
map <F2> :TaskList<CR>

" Project support
" map <silent> <c-p> <Plug>ToggleProject
map <C-p> :NERDTreeToggle<CR>

" Tagbar
nnoremap <silent> <F9> :TagbarToggle<CR>

" Folding
set foldmethod=syntax
set foldcolumn=2

" SPEC
let spec_chglog_prepend = 1
au FileType spec map <buffer> <F5> <Plug>AddChangelogEntry
let spec_chglog_packager = 'Alexei Panov <me AT elemc DOT name>'

" Some bindings
nnoremap <silent> <m-t> :tabnew<CR>
nnoremap <silent> <m-w> :tabclose<CR>
nnoremap <silent> <m-}> :tabnext<CR>
nnoremap <silent> <m-{> :tabprevious<CR>

inoremap <silent> <m-t> <ESC>:tabnew<CR>
inoremap <silent> <m-w> <ESC>:tabclose<CR>
inoremap <silent> <m-}> <ESC>:tabnext<CR>
inoremap <silent> <m-{> <ESC>:tabprevious<CR>

vnoremap <silent> <m-t> <ESC>:tabnew<CR>
vnoremap <silent> <m-w> <ESC>:tabclose<CR>
vnoremap <silent> <m-}> <ESC>:tabnext<CR>

" Python Mode
let g:pymode_syntax=1
let g:pymode_folding=1  " Enable python folding
let python_highlight_all=1

" Ruby Mode
" This is specific to rails apps, but I will not bind it to a particular
" filetype
function! TwoSpace()
    setlocal ts=2
    setlocal sw=2
endfunction
au FileType ruby call TwoSpace()
au FileType coffee call TwoSpace()
au BufNewFile,BufRead *.erb call TwoSpace()
au BufNewFile,BufRead *.rb call TwoSpace()

" Perl support
let perl_include_pod = 1
let perl_fold = 1
let perl_fold_blocks = 1

" Go support
autocmd FileType go compiler go
""" autocmd Syntax go normal zR
autocmd FileType go nmap <leader>t <Plug>(go-test)
autocmd FileType go nmap <leader>b <Plug>(go-build)
au FileType go nmap <leader>ds <Plug>(go-def-split)
au FileType go nmap <leader>dv <Plug>(go-def-vertical)
au FileType go nmap <leader>dt <Plug>(go-def-tab)
au FileType go nmap <leader>i <Plug>(go-info)
" let g:go_fmt_command = "goimports"
let g:go_fmt_command = "gofmt"
" let g:go_auto_type_info = 1
autocmd VimEnter * GoPath /home/alex/workspace/go
let g:go_fmt_experimental = 1

let g:neocomplete#enable_at_startup = 1


