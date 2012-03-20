
au BufNewFile,BufRead,TabEnter *.test,*.tests		set filetype=doctest
au BufNewFile,BufRead,TabEnter *.fail				set filetype=doctest_fail
au BufNewFile,BufRead,TabEnter *.g					set filetype=pymeta
