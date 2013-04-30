"
" Adaptations for shell scripts
"
"
" Keyboard
"
" to function start/end
noremap [d ?^[^{} \t#]<cr>
noremap ]d /^[^{} \t#]<cr>
" introduce variable
noremap <leader>v mvO<c-r>.=<c-r>"<esc>`v
