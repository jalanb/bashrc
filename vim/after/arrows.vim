
"
" Normal Arrows
"
nnoremap <left>             ?<cr>zv
nnoremap <right>            /<cr>zv
"noremap <left>             #zv
"noremap <right>            *zv
nnoremap <up>             :call ClaudeLeftSearch()<cr>
nnoremap <down>            :call ClaudeRightSearch()<cr>
"
" Normal Shift Arrows
"
nmap     <s-up>             <up>zz
nmap     <s-down>           <down>zz
nnoremap <s-up>             <C-B>
nnoremap <s-right>          gt
"noremap <s-left>           gT
"noremap <s-right>          gt
"
" Normal Control Arrows
"
nmap     <c-up>             gg<down>
nmap     <c-down>           G<up>
"noremap <c-left>           prev desktop
"noremap <c-right>          next desktop
nnoremap <c-k>              window up
nnoremap <c-j>              does nothing ?
nnoremap <c-h>              prev desktop
nnoremap <c-l>              next desktop
"
" Insert Control Arrows
"
inoremap <c-up>             <Esc><PageUp>I
inoremap <c-down>           <Esc><PageDown>I
inoremap <c-left>           <Esc>bi
inoremap <c-right>          <Esc>lwi

"
" Lettered Arrows
"
nnoremap t<left>  gT
nnoremap t<right> gt
"
" More Arrows
"
" nnoremap <up><up>           ?<cr>
" nnoremap <down><down>       /<cr>
" nnoremap <left><left>         #zv
" nnoremap <right><right>       *zv
"

" Claude code starts here
"
" Auto-fold navigation for Fred's workflow
"
" Track which folds we auto-opened so we only close our own
let b:auto_opened_folds = []

function! ExpandBodyOfCode()
    let line = getline('.')
    let lnum = line('.')

    " jzoz:
    "  j: down one line (go to body of code)
    "  zo / zO : open one/all folds
    "  z: centre this line on screen

    " Python class: expand one level
    if line =~ '^\s*class\s'
        execute 'normal! jzoz'
        call add(b:auto_opened_folds, lnum)
        return
    endif

    " Python def: expand all
    if line =~ '^\s*def\s'
        execute 'normal! jzOz'
        call add(b:auto_opened_folds, lnum)
        return
    endif

    " Bash function: expand all
    if line =~ '^\w\+\s*()\s*{$'
        execute 'normal! jzOz'
        call add(b:auto_opened_folds, lnum)
        return
    endif
endfunction

function! CloseFoldsWhenLeaving()
    " Close all folds we auto-opened
    for lnum in b:auto_opened_folds
        execute lnum . 'foldclose'
    endfor
    " Clear the tracking list
    let b:auto_opened_folds = []
endfunction

function! ClaudeSearch(direction)
    call CloseFoldsWhenLeaving()
    execute 'normal! ' . a:direction . 'zvz'
    call ExpandBodyOfCode()
endfunction

function! ClaudeLeftSearch()
    call ClaudeSearch('#')
endfunction

function! ClaudeRightSearch()
    call ClaudeSearch('*')
endfunction
