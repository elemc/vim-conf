if exists('g:elemc_author')
else
    let g:elemc_author = "Alexei Panov <me@elemc.name>"
endif

function! g:elemc_correct_header_string( str, count, comment_symbol )
    let space_count = a:count - len(a:str) - len(a:comment_symbol)
    if space_count < 0
        return a:str . " " . a:comment_symbol

    let new_str = a:str

    for i in range(1, space_count)
        let new_str = new_str . " "
    endfor
    let new_str = new_str . a:comment_symbol

    return new_str
endfunction

function! g:elemc_create_file( filename )
    execute ":new ". a:filename
    execute ":buffer ". a:filename
endfunction
