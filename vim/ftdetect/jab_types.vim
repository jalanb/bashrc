
au BufNewFile,BufRead,TabEnter *.test,*.tests		set filetype=doctest
au BufNewFile,BufRead,TabEnter *.fail				set filetype=doctest_fail
au BufNewFile,BufRead,TabEnter *.g					set filetype=pymeta
au BufNewFile,BufRead,TabEnter *.parsley			set filetype=parsley
au BufNewFile,BufRead,TabEnter *.pxi				set filetype=python
au BufReadCmd *.jar,*.xpi,*.egg call zip#Browse(expand("<amatch>"))
