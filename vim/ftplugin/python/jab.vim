if exists("g:loaded_jab_python")  
	finish
endif
let g:loaded_jab_python = "v001"

noremap } :cn<cr>
noremap { :cp<cr>

noremap D Oimport pudb<cr>pudb.set_trace()<esc>j
noremap tf :Fix<cr>
noremap tm :Mash<cr>
noremap tt :MashTry<cr>
noremap tn :Try<cr>
noremap tp :Pylint<cr>
noremap <leader><space> :%s/\s\+$//<cr>
noremap <leader>;   :s/:$//<cr>
noremap <leader>:   :s/$/:/<cr>
noremap <leader>8	b"aye<c-o>/\(def\\|class\) <c-r>a(<cr>
noremap <leader>d	?^\s*def \zs\i<cr>*
noremap <leader>-	bh/\l\u<cr>cr_

call matchadd('ColorColumn', '\(\%80v\|\%100v\)', 100)

set foldmethod=indent
set foldlevel=0
NoMatchParen

set autowrite
let s:file_name = expand("%")
let s:file_stem = fnamemodify(s:file_name,":r")
let s:file_py = s:file_stem . '.py'
let s:file_expected = s:file_stem . '.expected'
let s:file_actual = s:file_stem . '.actual'
if ! &diff && ! exists("g:recovering") && argc() == 1
	let s:file_jabber = substitute(s:file_py,'\.py$','.j',"")
	if filereadable(s:file_jabber) && s:file_py != s:file_jabber && &loadplugins
		exec "tabnew " s:file_jabber
	endif
	let s:file_parsley = substitute(s:file_py,'\.py$','.parsley',"")
	if filereadable(s:file_parsley) && s:file_py != s:file_parsley && &loadplugins
		exec "tabnew " s:file_parsley
		set filetype=doctest
	endif
	let s:file_grammar = substitute(s:file_py,'\.py$','.g',"")
	if filereadable(s:file_grammar) && s:file_py != s:file_grammar && &loadplugins
		exec "tabnew " s:file_grammar
		set filetype=doctest
	endif
	let s:file_test = substitute(s:file_py,'\.py$','.test',"")
	if filereadable(s:file_test) && s:file_py != s:file_test && &loadplugins
		setl autoread
		exec "tabnew " s:file_test
		set filetype=doctest
		set foldlevel=1
	endif
	let s:file_tests = substitute(s:file_py,'\.py$','.tests',"")
	if filereadable(s:file_tests) && s:file_py != s:file_tests && &loadplugins
		setl autoread
		exec "tabnew " s:file_tests
		set filetype=doctest
		set foldlevel=1
	endif
	let s:file_fail = substitute(s:file_py,'\.py$','.fail',"")
	if filereadable(s:file_fail) && s:file_py != s:file_fail && &loadplugins
		setl autoread
		exec "tabnew " s:file_fail
		set filetype=doctest_fail
	endif
	tabnext
	if !getfsize(expand('%')) > 0
		tabnext
		syntax on
	endif
endif
" 
" Try to run this file(s) through doctest
"
if !exists("Try")
	function NewTestFile(filename)
		exec "tabnew! " . s:file_test
		exec "normal IThe " . s:file_stem . " module\<cr>===========" . substitute(s:file_stem, ".", "=", "g") . "\<cr>\<cr>	>>> import ". s:file_stem . "\<cr>>>> print " . s:file_stem . ".__doc__\<Esc>"
		set cmdheight+=1
		write
		set cmdheight-=1
	endfunction
	function TryTest(quietly)
		let item_name = s:file_stem . "."
		if ! filereadable(s:file_test) && ! filereadable(s:file_tests)
			call NewTestFile(s:file_test)
		endif
		if filereadable('./try.py')
			let try_py = './try.py'
		elseif filereadable($TRY)
			let try_py = $TRY
		else
			let try_py = '~/.jab/python/testing/try.py'
		endif
		let command = "! TERM=linux && python " . try_py . " -qa "
		let command_line = command . item_name . " | grep -v DocTestRunner.merge "
		if a:quietly
			let tmpfile = tempname()
			let quiet_line = command_line . " > " . tmpfile . " 2>&1 || true"
		else
			let tmpfile = 'none'
			let quiet_line = command_line
		endif
		try
			exec quiet_line
			if tmpfile != 'none'
				call rename(tmpfile,s:file_fail)
			endif
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
		let path_to_fails = expand(s:file_fail)
		let z = getfsize(path_to_fails)
		" echo "Size of " . path_to_fails . " is " . z
		if ! z
			return
		endif
		exec "tablast"
		exec "tabnew! " . s:file_fail
	endfunction
	function TryFix(quietly)
		let item_name = expand("%:~:r")
		let path_to_fails = expand(s:file_fail)
		let z = getfsize(path_to_fails)
		if ! z
			return
		endif
		let command_line = "! python ~/.jab/python/fix_failures.py "
		if a:quietly
			let quiet_line = command_line . s:file_fail . " 2>&1 || true"
		else
			let quiet_line = command_line . s:file_fail
		endif
		try
			exec quiet_line
			redraw!
		catch /.*/
			" echo fred
		endtry
	endfunction
	function Vim_Difference_Between_Expected_And_Got()
		if bufloaded(s:file_expected)
			exec "bunload " . s:file_expected
		endif
		if bufloaded(s:file_actual)
			exec "bunload " . s:file_actual
		endif
		if line('.') < 3
			call cursor(4,1)
		endif
		let a:wrapscan=&wrapscan
		set nowrapscan
		call search("Failed","b")
		let v:errmsg = ""
		silent! exec "/Expected/+1,/Got:/-1 w! " . s:file_expected
		if v:errmsg != ""
			echoerr "\"Expected\" not found after the cursor"
			return
		endif
		silent exec "/Got:/+1,/\\(^File\\)\\|\\(had failures\\)/-2 w! " . s:file_actual
		silent exec "tabnew " . s:file_expected
		set buftype=nofile
		set diffopt=filler,iwhite,vertical
		silent exec "diffsplit " . s:file_actual
		silent exec "tabprev"
		silent exec "tabnext"
		set buftype=nofile
		call delete(s:file_expected)
		call delete(s:file_actual)
		let &wrapscan=a:wrapscan
	endfunction
	function Try(quietly)
		if expand("%:e") == "fail"
			call Vim_Difference_Between_Expected_And_Got()
		else
			call TryTest(a:quietly)
		endif
	endfunction
	command -nargs=0 Try :call Try(1)
	command -nargs=0 Fix :call TryFix(0)
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

	function MashTry()
		call Mash()
		call Try(1)
	endfunction
	command -nargs=0 MashTry :call MashTry()
endif
"	From ie-build-1:/usr/share/vim/vim70/vimrc_example.vim

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif
 
" From http://www.vex.net/~x/python_and_vim.html
  " Remove trailing space when writing the file
  autocmd BufWritePre * normal m`:%s/\s\+$//e ``

if !exists("PPP")
	function WritePEP()
		normal zR
		exec "%s/\\s\\+$//ce"
		exec "%s/'''/\"\"\"/gce"
		exec "%s/^\\([^<'\"[]\\+\\):\\([^ ]\\)/\\1: \\2/gce"
		exec "%s/\\([^ ]\\) #/\\1  #/e"
		exec "%s/\\([^\\s]\\)\\n^\\n\\([a-z]\\)/\\1\\2/ce"
		exec "%s/\\[ \\(.*\\) ]/[\\1]/gce"
		exec "%s/\\[ /[/gce"
		exec "%s/ \\]/]/gce"
		exec "%s/( \\(.*\\) )/(\\1)/gce"
		exec "%s/( /(/gce"
		exec "%s/ )/)/gce"
		exec "%s/{ \\(.*\\) }/{\\1}/gce"
		exec "%s/{ /{/gce"
		exec "%s/ }/}/gce"
		exec "%s/ , /, /gce"
		exec "%s/\\(^\\(\\s\\+\\)\\(try\\|for\\|if\\|except\\)\\( [^:]*\\)\\?: \\)/\\1\\2	/ce"
		" exec "%s/\\([^ ]\\)\\([=+-]\\)/\\1 \\2/gce"
		" exec "%s/\\([=+,-]\\)\\([^ =]\\)/\\1 \\2/gce"
		exec "%s/,\\([^ ]\\)/, \\1/gce"
		exec "%s/ += \\[\\(.*\\)]/.append(\\1)/gce"
		exec "%s/ += \\(.*\\)$/.append(\\1)/gce"
		exec "%s/\\s\\+$//ge"
		exec "%s/raise \\([A-Za-z]\\+\\), \\(.*\\)/raise \\1(\\2)/gce"
	endfunction
	function AddDocstrings()
		exec '%s/\(^\s*def \)\([^(]\+\)\((.*):\n\)\(\s\+\)\([^"]\)/\1\2\3\4""""""\4\5/e'
		let empty_docstring_line = search('""""""',"cn")
		if empty_docstring_line != 0
			exec '/"""\zs"""'
			normal n
			startinsert
		else
			normal i
		endif
	endfunction
	command -nargs=0 PPP :call WritePEP()
	command -nargs=0 PPA :call AddDocstrings()
endif
