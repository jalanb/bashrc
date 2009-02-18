if exists("g:loaded_jab_python")  
	finish
endif
let g:loaded_jab_python = "v001"

noremap <up> i k <esc>
noremap <down> i j <esc>
noremap <right> :tabnext<cr>
noremap <left> :tabprev<cr>
set foldmethod=indent
NoMatchParen

set autowrite
let s:file_py = expand("%")
let s:file_gy = substitute(s:file_py,'\.py$','.gy',"")
if filereadable(s:file_gy) && s:file_py != s:file_gy
	exec "tabnew " s:file_gy
endif
let s:file_tests = substitute(s:file_py,'\.py$','.tests',"")
if filereadable(s:file_tests) && s:file_py != s:file_tests
	exec "tabnew " s:file_tests
endif
let s:file_test = substitute(s:file_py,'\.py$','.test',"")
if s:file_py != s:file_test
	exec "tabnew " s:file_test
endif
let s:file_fail = substitute(s:file_py,'\.py$','.fail',"")
if s:file_py != s:file_fail
	exec "tabnew " s:file_fail
endif
tabnext

" 
" Try to run this file(s) through doctest
"
if !exists("Try")
	function Try()
		let item_name = expand("%:~:r")
		let fails = item_name . ".fail"
		let command = "! python ~/python/try.py -qa "
		let command_line = command . item_name . " > " . fails . " 2>&1"
		try
			exec command_line
			redraw!
		catch /.*/
			" echo fred
		endtry
		let path_to_fails = expand(fails)
		let z = getfsize(path_to_fails)
		" echo "Size of " . path_to_fails . " is " . z
		if ! z
			return
		endif
		if expand("%:e") != "fail"
			" next command depends on the taborder from start of this script
			" 	because it assumes *.fail is in the last tab
			exec "tablast"
		endif
	endfunction
	command -nargs=0 Try :call Try()
	noremap T :Try<cr>
endif
if !exists("Mash")
	function Mash()
		" replace 4 spaces with a tab
		try
			if &filetype == "doctest"
				exec "%s/^    /\t/"
			else
				exec "%s/^    /\t/g"
			endif
		catch /.*/
			" echo fred
		endtry
	endfunction
	command -nargs=0 Mash :call Mash()
	noremap M :Mash<cr>
	autocmd BufWrite * exec "Mash"
endif
"	From ie-build-1:/usr/share/vim/vim70/vimrc_example.vim

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
