if exists("g:loaded_jab_doctest")
    finish
endif
let g:loaded_jab_doctest = "v001"

noremap D Oimport pudb; pudb.set_trace()  # pylint: disable=multiple-statements<esc>j
noremap tf :Fix<cr>
noremap tm :Mash<cr>
noremap tt :MashTry<cr>
noremap tr :Try<cr>


function FindUnitTest()
    let s:unit_test = substitute(s:file_py,'\.py$','_test.py',"")
    if ! filereadable(s:unit_test)
        let s:unit_test = 'test/' . s:unit_test
        if ! filereadable(s:unit_test)
            let s:unit_test = 'test/' . substitute(s:file_py,'\.py$','_test.py',"")
            if ! filereadable(s:unit_test)
                let s:unit_test = 'test/test_' . s:file_py
            endif
        endif
    endif
endfunction

function LoadUnitTest()
    call FindUnitTest()
    if filereadable(s:unit_test) && s:file_py != s:unit_test && &loadplugins
        setl autoread
        exec "tabnew " s:unit_test
        set filetype=python
        set foldlevel=1
    endif
endfunction

function FindTestUnit()
    let s:test_unit = substitute(s:file_py,'^','test_',"")
    if ! filereadable(s:test_unit)
        let s:test_unit = substitute(s:file_py,'^','tests/test_',"")
    endif
endfunction

function LoadTestUnit()
    call FindTestUnit()
    if filereadable(s:test_unit) && s:file_py != s:test_unit && s:unit_test != s:test_unit && &loadplugins
        setl autoread
        exec "tabnew " s:test_unit
        set filetype=python
        set foldlevel=1
    endif
endfunction

set autowrite
let s:file_name = expand("%")
let s:file_stem = fnamemodify(s:file_name,":r")
let s:file_py = s:file_stem . '.py'
let s:file_test = s:file_stem . '.test'
let s:file_tests = s:file_stem . '.tests'
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
    call LoadUnitTest()
    call LoadTestUnit()
    if filereadable(s:file_py) && s:file_test != s:file_py && &loadplugins
        setl autoread
        exec "tabnew " s:file_py
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
" Enable 'Try' command to run buffer through doctest
"
if !exists("Try")
    function NewTestFile(filename)
        exec "tabnew! " . s:file_test
        exec "normal IThe " . s:file_stem . " module\<cr>===========" . substitute(s:file_stem, ".", "=", "g") . "\<cr>\<cr>    >>> import ". s:file_stem . "\<cr>>>> print " . s:file_stem . ".__doc__\<Esc>"
        set cmdheight+=1
        write
        set cmdheight-=1
    endfunction
    function TryTest(quietly)
        let item_name = s:file_stem . "."
        if ! filereadable(s:file_test) && ! filereadable(s:file_tests) && ! filereadable(s:test_unit) && ! filereadable(s:unit_test)
            call NewTestFile(s:file_test)
        endif
        if filereadable('./try.py')
            let try_py = './try.py'
        elseif filereadable($TRY)
            let try_py = $TRY
        else
            let try_py = '~/jab/src/python/testing/try.py'
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
        let s:file_fail = substitute(s:file_py,'\.py$','.fail',"")
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
endif
"   From ie-build-1:/usr/share/vim/vim70/vimrc_example.vim

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

" From http://www.vex.net/~x/python_and_vim.html
  " Remove trailing space when writing the file
  autocmd BufWritePre * call WritePython()
