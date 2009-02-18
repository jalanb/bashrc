syntax match doctest_english /^\s*.*$/ 
syntax include @python <sfile>:p:h/python.vim
syntax region doctest_value start=/^\s\+[^>. 	]/ end=/$/ contained contains=pythonString,pythonNumber,pythonException
syntax region doctest_code start=/\s\+[>.]\{3}/ end=/^\s*$/ contains=@python,doctest_value

syntax region doctest_header start=+=\+\n\w\++ start=+\w.\+\n=\++ end=+=$+
syntax region doctest_header start=+-\+\n\w\++ start=+\w.\+\n-\++ end=+-$+
syntax region doctest_header start=+\*\+\n\w\++ start=+\w.\+\n\*\++ end=+\*$+

syntax region doctest_note start=+\.\{2} \[+ end=+(\n\n)\|\%$+

hi link doctest_header Statement
"hi link doctest_value pythonObject
hi doctest_value ctermfg=Cyan guifg=#0044AA
hi link doctest_english Constant
hi link doctest_note Comment
hi link doctest_code Comment
