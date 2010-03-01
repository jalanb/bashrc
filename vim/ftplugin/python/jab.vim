if exists("g:loaded_jab_python")  
	finish
endif
let g:loaded_jab_python = "v001"

noremap <right> :tabnext<cr>
noremap <left> :tabprev<cr>
set foldmethod=indent
NoMatchParen

set autowrite
let s:file_py = expand("%")
if ! &diff && ! exists("g:recovering")
	let s:file_jabber = substitute(s:file_py,'\.py$','.j',"")
	if filereadable(s:file_jabber) && s:file_py != s:file_jabber
		exec "tabnew " s:file_jabber
		if getfsize(expand('%')) > 0
			1,$foldopen!
		endif
	endif
	let s:file_grammar = substitute(s:file_py,'\.py$','.g',"")
	if filereadable(s:file_grammar) && s:file_py != s:file_grammar
		exec "tabnew " s:file_grammar
		set filetype=doctest
		if getfsize(expand('%')) > 0
			1,$foldopen!
		endif
	endif
	let s:file_test = substitute(s:file_py,'\.py$','.test',"")
	if filereadable(s:file_test) && s:file_py != s:file_test
		setl autoread
		exec "tabnew " s:file_test
		set filetype=doctest
		if getfsize(expand('%')) > 0
			1,$foldopen!
		endif
	endif
	let s:file_tests = substitute(s:file_py,'\.py$','.tests',"")
	if filereadable(s:file_tests) && s:file_py != s:file_tests
		setl autoread
		exec "tabnew " s:file_tests
		set filetype=doctest
		if getfsize(expand('%')) > 0
			1,$foldopen!
		endif
	endif
	let s:file_fail = substitute(s:file_py,'\.py$','.fail',"")
	if filereadable(s:file_fail) && s:file_py != s:file_fail
		setl autoread
		exec "tabnew " s:file_fail
		set filetype=doctest_fail
		if getfsize(expand('%')) > 0
			1,$foldopen!
		endif
	endif
	tabnext
	if getfsize(expand('%')) > 0
		1,$foldopen!
	else
		tabnext
		syntax on
	endif
endif
" 
" Try to run this file(s) through doctest
"
if !exists("Try")
	function TryTest(quietly)
		let item_name = expand("%:~:r")
		let fails = item_name . ".fail"
		let command = "! python ~/.jab/python/try.py -qa "
		let command_line = command . item_name . " | grep -v DocTestRunner.merge "
		if a:quietly
			let quiet_line = command_line . " > " . fails . " 2>&1 || true"
		else
			let quiet_line = command_line
		endif
		try
			exec quiet_line
			redraw!
		catch /.*/
			" echo fred
		endtry
		let old_tab = expand("%")
		exec "tablast"
		let last_tab = expand("%")
		if expand("%:e") == "fail"
			exec "quit!"
		endif
		if old_tab != last_tab
			while old_tab != expand("%")
				exec "tabnext"
			endwhile
		endif
		let path_to_fails = expand(fails)
		let z = getfsize(path_to_fails)
		" echo "Size of " . path_to_fails . " is " . z
		if ! z
			return
		endif
		exec "tablast"
		exec "tabnew! " . fails
	endfunction
	function TryFix(quietly)
		let item_name = expand("%:~:r")
		let fails = item_name . ".fail"
		let path_to_fails = expand(fails)
		let z = getfsize(path_to_fails)
		if ! z
			return
		endif
		let command_line = "! python ~/.jab/python/fix_failures.py "
		if a:quietly
			let quiet_line = command_line . fails . " 2>&1 || true"
		else
			let quiet_line = command_line . fails
		endif
		try
			exec quiet_line
			redraw!
		catch /.*/
			" echo fred
		endtry
	endfunction
"	function Try(quietly)
"		if expand("%:e") == "fail"
"			call TryFix(quietly)
"		else
"			call TryTest(quietly)
"		endif
"	endfunction
	command -nargs=0 Try :call TryTest(1)
	command -nargs=0 Fix :call TryFix(0)
	noremap t :Try<cr>
endif
if !exists("Mash")
	function Mash()
		" replace spaces with a tab
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
endif
"	From ie-build-1:/usr/share/vim/vim70/vimrc_example.vim

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
