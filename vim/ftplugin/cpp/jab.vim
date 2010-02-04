if exists("g:loaded_jab_cpp")                                                                                                                              
    finish
endif
let g:loaded_jab_cpp = "v001"

noremap <right> :tabnext<cr>
noremap <left> :tabprev<cr>
set foldmethod=indent
NoMatchParen

set autowrite
let s:file_name = expand("%")
let s:file_h = substitute(s:file_name,'\..*$','.h',"")
let s:file_cpp = substitute(s:file_name,'\..*$','.cpp',"")
if filereadable(s:file_cpp) && s:file_name != s:file_cpp
    exec "tabnew " s:file_cpp
	set syntax=cpp
endif
if filereadable(s:file_h) && s:file_name != s:file_h
    exec "tabnew " s:file_h
	set syntax=cpp
endif
tabnext
set ft=cpp
