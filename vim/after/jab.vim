set nospell

"	From ie-build-1:/usr/share/vim/vim70/vimrc_example.vim

" When editing a file, always jump to the last known cursor position.
" Don't do it when the position is invalid or when inside an event handler
" (happens when dropping a file on gvim).
autocmd BufReadPost *
  \ if line("'\"") > 0 && line("'\"") <= line("$") |
  \   exe "normal g`\"" |
  \ endif
"
" https://vi.stackexchange.com/a/22788/182
"
"
function FirstPress(c1) abort
  echo 'Hello World'
  let now = reltime()
  while reltimefloat(reltime(now)) < &timeoutlen / 1000.0
    " See if the user has typed another character
    let c2 = getchar(0)

    if c2 != 0
      echo " The user typed something. Was it another h?"
      if c2 == char2nr(a:c1)
        echo " The user typed a double h, switch buffers"
        " call feedkeys(a:c1 == 'h' ? ":bp\<CR>" : ":bn\<CR>", 't')
      else
        echo " The user typed something else. Switch tabs and replay what they typed"
        " call feedkeys((a:c1 == 'h' ? 'gT' : 'gt') . nr2char(c2), 't')
      endif
      return
    endif
  endwhile

  echo " The user did not press anything. Switch Tabs"
  " call feedkeys((a:c1 == 'h' ? 'gT' : 'gt'), 't')
endfunction

function AtStart()
	if getpos('.')[1] == 1 && getpos('.')[2] == 1:
        return 1
    endif
    return 0
endfunction

function AtEnd()
	if getpos('.')[1] == line('$') && (getpos('.')[2] == col('$') - 1 )
        return 1
    endif
    if ( col('$') == 1):
        return 1
    endif
    return 0
endfunction

" nnoremap <expr> h (AtStart() == 1) ? ':call FirstPress("h")<CR>' : 'h'
" nnoremap <expr> l (AtEnd() == 1) ? ':call FirstPress("l")<CR>' : 'l'
" noremap H (getpos('.')[1] == 1 && getpos('.')[2] == 1) ? ':call FirstPress("H")<CR>' : 'H'
" noremap L (getpos('.')[1] == line('$') && (getpos('.')[2] == col('$') - 1 \|\| col('$') == 1)) ? ':call FirstPress("L")<CR>' : 'L'
"noremap H :call FirstPress("H")<CR>
"noremap L :call FirstPress("L")<CR>
