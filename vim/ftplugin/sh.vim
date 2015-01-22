"
" Adaptations for shell scripts
"
"
" Keyboard
"
" down through functions
"
noremap <up> ?^[^{} \t#]<cr>
noremap <down> /^[^{} \t#]<cr>
" to function start/end
noremap [d ?^[^{} \t#]<cr>
noremap ]d /^[^{} \t#]<cr>
"
" introduce variable
"
noremap <leader>v mvO<c-r>.=<c-r>"<esc>`v
"
" debugging
"
noremap <F8> Oset -x<esc>joset +x<esc>k
noremap <F7> gg/^\s*set..x$<cr>:noremap <F7> ddn<cr>

