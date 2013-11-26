" Vim syntax file
" Language:         Parsley
" Maintainer:       Alan Brogan (vim@al-got-rhythm.net)
" Last Change:      $Date: 2013-11-23
" Version:          0.1

" Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn include @python syntax/python.vim

" Spaces
"
syn match parsley_comment                "#.*$"
syn match parsley_hspace                 "\(\s\|#.*$\)"
syn match parsley_vspace                 "\(\r\n\|\r\|\n\)"
syn match parsley_ws                     "\(\s\r\n\|\r\|\n\|#.*$\)"

" expressions
syn match parsley_name                   "\<\a\w*"
syn match parsley_assign                 "="

syn match parsley_terminal               "<[^>]\+>"

syn region parsley_semantic_expression   start="(" end=")" contained
syn region parsley_semantic_predicate    start="?(" end=")" contains=parsley_semantic_expression
syn region parsley_semantic_action       start="!(" end=")" contains=parsley_semantic_expression
syn region parsley_python                matchgroup=Comment excludenl start="->" end="$"

"
" literals
"
syn match parsley_number                 "\<\d\>"
syn match parsley_number                 "\<[1-9]\d\+\>"
syn match parsley_number                 "\<0\o\+\>"
syn match parsley_number                 "\<0[xX]\x\+\>"

syn match parsley_string                 |"[^"]*"|
syn match parsley_character              "'\(\\.\|[^']\)\+'"

hi link parsley_comment                  Comment
hi link parsley_name                     Identifier
hi link parsley_terminal                 String
hi link parsley_assign                   Operator
hi link parsley_number                   Number
hi link parsley_string                   String
hi link parsley_character                String
hi link parsley_semantic_predicate       Special
hi link parsley_semantic_action          Special
