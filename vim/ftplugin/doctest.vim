if exists("b:ftplugin_doctest_version")  
	finish
endif
let b:ftplugin_doctest_version= "v003"

setlocal autoread

set foldmethod=indent
set foldlevel=0
set shiftwidth=4

function DocTest()
    write
    let command = '! TERM=linux && python -m doctest -f -o REPORT_ONLY_FIRST_FAILURE ' . expand('%') . ' | grep -v -e DocTestRunner'
    exec command
endfunction

command! -nargs=0 TT :call DocTest()

nnoremap tt :call DocTest()<cr>
