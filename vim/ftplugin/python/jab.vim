if exists("g:loaded_jab_python")
    finish
endif
let g:loaded_jab_python = "v001"

let g:pymode_doc = 0

nnoremap } :cn<cr>
nnoremap { :cp<cr>

nnoremap D Oimport pudb; pudb.set_trace()  # pylint: disable=multiple-statements<esc>j
nnoremap tt :Try<cr>
nnoremap tm :MashTry<cr>
nnoremap <S-F9> :call WritePEP()<cr>
nnoremap <leader><space> :%s/\s\+$//<cr>
nnoremap <leader>8   b"aye<c-o>/\(def\\|class\) <c-r>a(<cr>
nnoremap <leader>8   call matchadd('ColorColumn', '\(\%80v\|\%100v\)', 100)
nnoremap <leader>c   ?^\s*class \zs\i<cr>*
nnoremap <leader>d   ?^\s*def \i\+\zs.*<cr>*zv
nnoremap <leader>e   ?^\s*def \zs\i<cr>*#zv
nnoremap <leader>k   $%a<cr><esc
nnoremap <leader>o   O<esc>

call matchadd('ColorColumn', '\(\%80v\|\%100v\)', 100)

function! FoldCommentsAndIndentation(lnum)
    let l:line = getline(a:lnum)
    if l:line =~ '.*{{{'
        return 'a1'
    elseif l:line =~ '.*}}}'
        return 's1'
    endif
    let l:comment_re = '\v^\s*#(([{}]{3})@!.)*$'
    if getline(a:lnum) =~ l:comment_re
        if getline(a:lnum - 1) =~ l:comment_re
            return '1'
        else
            return '0'
        endif
    endif
    return indent(a:lnum) / &tabstop
endfunction

" PEP 8 calls for indentation with 4 spaces
set foldmethod=indent
" set foldexpr=FoldCommentsAndIndentation(v:lnum)
set foldlevel=0
" Do not treat comments differently (default has foldignore=#)
" https://stackoverflow.com/questions/8993455/how-do-i-fix-vim-to-properly-indent-folds-containing-python-comment-lines
set foldignore=
NoMatchParen

" Checkers
let g:syntastic_python_checkers=['pep8', 'pylint', 'python']
"let g:syntastic_python_python_exec = '~/bin/python'
"
" commenting this out because on jab.ook vim says
" E117: Unknown function: SyntasticStatuslineFlag
" E15: Invalid expression: SyntasticStatuslineFlag()
"
" set statusline+=%#warningmsg#%{SyntasticStatuslineFlag()}%*
set laststatus=2
let g:syntastic_always_populate_loc_list = 1
let g:syntastic_auto_loc_list = 1
let g:syntastic_auto_jump = 1
let g:syntastic_stl_format = '%E{%e errors, from line %fe}%B{, }%W{%w warnings from line %fw}'


function OpenTabFor(path)
    let l:sought = expand(a:path)
    let l:start_tab = expand('%')
    if l:sought == l:start_tab
        return
    endif
    let l:this_tab = ''
    while l:this_tab != l:start_tab
        tabnext
        let l:this_tab = expand('%')
        if l:sought == l:this_tab
            return
        endif
    endwhile
    silent exec "tabnew " . l:sought
endfunction

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
        call OpenTabFor(s:unit_test)
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
        call OpenTabFor(s:test_unit)
        set filetype=python
        set foldlevel=1
    endif
endfunction

set autowrite

function UseFile(file_name_arg)
    let s:file_name = a:file_name_arg
    let s:file_stem = fnamemodify(s:file_name,":r")
    let s:file_py = s:file_stem . '.py'
    let s:file_expected = s:file_stem . '.expected'
    let s:file_actual = s:file_stem . '.actual'
    let s:file_jabber = substitute(s:file_py,'\.py$','.j',"")
    if filereadable(s:file_jabber) && s:file_py != s:file_jabber && &loadplugins
        call OpenTabFor(s:file_jabber)
    endif
    let s:file_parsley = substitute(s:file_py,'\.py$','.parsley',"")
    if filereadable(s:file_parsley) && s:file_py != s:file_parsley && &loadplugins
        call OpenTabFor(s:file_parsley)
        set filetype=doctest
    endif
    let s:file_grammar = substitute(s:file_py,'\.py$','.g',"")
    if filereadable(s:file_grammar) && s:file_py != s:file_grammar && &loadplugins
        call OpenTabFor(s:file_grammar)
        set filetype=doctest
    endif
    call LoadUnitTest()
    call LoadTestUnit()
    let s:file_test = substitute(s:file_py,'\.py$','.test',"")
    if filereadable(s:file_test) && s:file_py != s:file_test && &loadplugins
        setl autoread
        call OpenTabFor(s:file_test)
        set filetype=doctest
        set foldlevel=1
    endif
    let s:file_tests = substitute(s:file_py,'\.py$','.tests',"")
    if filereadable(s:file_tests) && s:file_py != s:file_tests && &loadplugins
        setl autoread
        call OpenTabFor(s:file_tests)
        set filetype=doctest
        set foldlevel=1
    endif
    let s:file_fail = substitute(s:file_py,'\.py$','.fail',"")
    if filereadable(s:file_fail) && s:file_py != s:file_fail && &loadplugins
        setl autoread
        call OpenTabFor(s:file_fail)
        set filetype=doctest_fail
    endif
endfunction

if ! &diff && ! exists("g:recovering") && argc() == 1
    call UseFile(expand("%"))
    tabnext
    if !filereadable(expand('%')) || empty(readfile(expand('%')))
        tabnext
    endif
    syntax on
endif
"
" Try to run this file(s) through doctest
"
if !exists("Try")

    function PythonTwo ()
        return system(' python -c "import sys; sys.stdout.write(str(sys.version_info.major))"') == '2'
    endfunction

    function NewTestFile(filename)
        let l:dirname = fnamemodify(a:filename, ':h:t')
        if l:dirname == 'bin'
            return
        endif
        let l:extension = fnamemodify(a:filename, ':e')
        if l:extension != 'py'
            return
        endif
        exec "tabnew! " . s:file_test
        let l:dot_stem = substitute(s:file_stem, "/", ".", "g")
        exec "normal IThe " . l:dot_stem . " module\<cr>===========" . substitute(s:file_stem, ".", "=", "g") . "\<cr>\<cr>    >>> import ". l:dot_stem . "\<cr>>>> assert 'module' in " . l:dot_stem . ".__doc__\<Esc>"
        set cmdheight=2
        write
        set cmdheight=1
    endfunction

    function TryCommand()
        call UseFile(expand("%"))
        if ! filereadable(s:file_test) && ! filereadable(s:file_tests) && ! filereadable(s:test_unit) && ! filereadable(s:unit_test)
            call NewTestFile(s:file_test)
        endif
        let l:python_test_command = ""
        if PythonTwo()
            let l:python_test_command = '! TERM=linux python -m doctest '
        else
            let l:try_py = ''
            if filereadable('./try.py')
                let l:try_py = './try.py'
            else
                if filereadable($TRY)
                    let l:try_py = $TRY
                elseif isdirectory($VIRTUAL_ENV)
                    let l:virtual_try = $VIRTUAL_ENV . "/bin/try"
                    if filereadable(l:virtual_try)
                        let l:try_py = l:virtual_try
                    endif
                elseif filereadable('/usr/local/bin/try')
                    let l:try_py = '/usr/local/bin/try'
                endif
            endif
            if filereadable(l:try_py)
                let l:python_test_command = "! TERM=linux " . l:try_py . " -qa "
            endif
        endif
        if len(l:python_test_command) == 0
            echoerr "No try command available"
            return
        endif
        let l:try_this_file = expand('%')
        let l:try_command = l:python_test_command . l:try_this_file
        return l:try_command
    endfunction

    function TryTest(quietly)
        let l:try_command = TryCommand()
        if len(l:try_command) == 0
            return
        endif
        if a:quietly
            let l:tempfile_ = tempname()
            let l:temped = 1
            let l:exec_command = l:try_command . " > " . l:tempfile_ . " 2>&1 || true"
        else
            let l:temped = 0
            let l:exec_command = l:try_command . " || true"
        endif
        let s:file_fail = substitute(s:file_py,'\.py$','.fail',"")
        try
            exec l:exec_command
            if l:temped == 1
                call rename(l:tempfile_,s:file_fail)
            endif
            redraw!
        catch /.*/
            " echo fred
        endtry
        let l:old_tab = expand("%")
        exec "tablast"
        let l:last_tab = expand("%")
        if expand("%:e") == "fail"
            exec "quit!"
        endif
        if l:old_tab != l:last_tab
            while l:old_tab != expand("%")
                exec "tabnext"
            endwhile
        endif
        if filereadable(s:file_fail) && empty(readfile(s:file_fail))
            call delete(s:file_fail)
        endif
        if ! filereadable(s:file_fail)
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
        call OpenTabFor(s:file_expected)
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
    command! -nargs=0 Try :call Try(1)
endif
if !exists("Mash")
    function Mash()
        " replace tabs with 4 spaces
        try
            if &filetype == "doctest"
                exec "%s/^\t/    /"
            else
                exec "%s/^\t/    /g"
            endif
        catch /.*/
        endtry
    endfunction
    command -nargs=0 Mash :call Mash()

    function MashTry()
        call Mash()
        call Try(1)
    endfunction
    command -nargs=0 MashTry :call MashTry()
endif
"   From vim/vim70/vimrc_example.vim

  " When editing a file, always jump to the last known cursor position.
  " Don't do it when the position is invalid or when inside an event handler
  " (happens when dropping a file on gvim).
  autocmd BufReadPost *
    \ if line("'\"") > 0 && line("'\"") <= line("$") |
    \   exe "normal g`\"" |
    \ endif

function ReSpacePython()
    exec "retab"
    exec "%s/\\s\\+$//e"
endfunction


function WritePython()
    call ReSpacePython()
    call Try(1)
endfunction
autocmd BufWritePost * call WritePython()

" function LintPython()
"     let l:command = "! TERM=linux && pylint "
"     exec l:command
"     redraw!
" endfunction
" autocmd InsertLeave * call LintPython()

if !exists("PPP")
    function WritePEP()
        mkview
        normal zR
        call ReSpacePython()
        exec "%s/'''/\"\"\"/gce"
        exec "%s/^\\([^<'\"[]\\+\\):\\([^ ]\\)/\\1: \\2/gce"
        exec "%s/\\([^ ]\\) #/\\1  #/e"
        exec "%s/\\([^\\s]\\)\\n^\\n\\([a-z]\\)/\\1\\2/ce"
        exec "%s/\\[ \\(.*\\) ]/[\\1]/gce"
        exec "%s/\\[ /[/gce"
        exec "%s/\\([^ ]\\) \\]/\\1]/gce"
        exec "%s/( \\(.*\\) )/(\\1)/gce"
        exec "%s/( /(/gce"
        exec "%s/ )/)/gce"
        exec "%s/{ \\(.*\\) }/{\\1}/gce"
        exec "%s/{ /{/gce"
        exec "%s/\\([^ ]\\) }/}/gce"
        exec "%s/ , /, /gce"
        exec "%s/\\(^\\(\\s\\+\\)\\(try\\|for\\|if\\|except\\)\\( [^:]*\\)\\?: \\)/\\1\\2 /ce"
        " exec "%s/\\([^ ]\\)\\([=+-]\\)/\\1 \\2/gce"
        " exec "%s/\\([=+,-]\\)\\([^ =]\\)/\\1 \\2/gce"
        exec "%s/,\\([^ ]\\)/, \\1/gce"
        exec "%s/ += \\[\\(.*\\)]/.append(\\1)/gce"
        exec "%s/ += \\([^0-9].*\\)$/.append(\\1)/gce"
        exec "%s/\\s\\+$//ge"
        exec "%s/raise \\([A-Za-z]\\+\\), \\(.*\\)/raise \\1(\\2)/gce"
        loadview
    endfunction
    function AddDocstrings()
        exec '%s/\(^\s*def \)\([^(]\+\)\((.*):\n\)\(\s\+\)\([^  "]\)/\1\2\3\4""""""\4\5/e'
        let l:empty_docstring_line = search('""""""',"cn")
        if l:empty_docstring_line != 0
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

if !exists("SaveOther")
    function SaveOther(first, last, name)
        let l:command = ':' . a:first . ',' . a:last ' w! ~/one'
        exec l:command
    endfunction
    function SaveOne(first, last)
        SaveOther(first, last, '~/one')
    endfunction
    function SaveTwo(first, last)
        SaveOther(first, last, '~/two')
    endfunction
    function SaveThree(first, last)
        SaveOther(first, last, '~/three')
    endfunction
    command -nargs=+ One :call SaveOne()
    command -nargs=+ Two :call SaveTwo()
    command -nargs=+ Three :call SaveThree()
endif
