" vim-history.vim - Show recent files from vim history by time period
" Maintainer: Your Name
" Version: 1.0

if exists('g:loaded_vim_history') || &compatible
  finish
endif
let g:loaded_vim_history = 1

" Define the user command
command! -nargs=* VimHistory call vim_history#show(<f-args>)

" Optional: provide some sensible defaults as separate commands
command! VimHistoryToday call vim_history#show(1, 'd')
command! VimHistoryWeek call vim_history#show(1, 'w')
command! VimHistoryMonth call vim_history#show(1, 'm')
