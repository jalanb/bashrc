"
" Adaptations for shell scripts
"
"
" Keyboard
"
" down through functions
"
noremap <leader><up> jzOk
noremap <leader><down> jzOw
noremap <up> zx?^[^{} \t#]<cr>jzOk
noremap <down> zx/^[^{} \t#]<cr>jzOk
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

let g:syntastic_sh_checkers=['bashate', 'checkbashisms', 'shellcheck']

" Fold on indentation
set foldmethod=indent
"
" Start with closed folds
"
set foldlevel=0
