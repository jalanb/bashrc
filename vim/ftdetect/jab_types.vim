
au BufNewFile,BufRead,TabEnter *.test,*.tests		setf doctest
au BufNewFile,BufRead,TabEnter *.fail				setf doctest_fail
au BufNewFile,BufRead,TabEnter *.gy					setf python_grammar
