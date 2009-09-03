" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=8 sw=4
" Vim color file
" Maintainer:	J Alan Brogan (vim@al-got-rhythm.net)
" Last Change:	2004 Aug 21

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "alan-colour"

highlight Normal		ctermfg=White	ctermbg=Black			guifg=White	guibg=Black
highlight Search		ctermfg=Red	ctermbg=DarkRed			guifg=Red	guibg=#402020

highlight Comment	 	ctermfg=Grey					guifg=#808080
highlight Constant	 	ctermfg=Cyan			cterm=none	guifg=#0066FF
highlight CursorLine		cterm=underline					gui=underline guibg=#080808
highlight string		ctermfg=Blue					guifg=Blue
highlight pythonEscape		ctermfg=Blue					guifg=#000088
highlight Identifier	 	ctermfg=Green					guifg=#44ff44
highlight Keyword    		ctermfg=LightRed		cterm=bold	guifg=Red			gui=bold
highlight Statement 		ctermfg=Red			cterm=bold	guifg=Red			gui=bold
highlight PreProc	 	ctermfg=LightRed				guifg=#ff4444	gui=bold
highlight Type		 	ctermfg=2					guifg=#ff4444	gui=bold
highlight Special	 	ctermfg=red					guifg=#ff4444  gui=bold
highlight Error					ctermbg=Red					guibg=Red
highlight Todo		 	ctermfg=Black	ctermbg=Green			guifg=#000080	guibg=#c0c000
highlight Directory  		ctermfg=DarkGreen				guifg=DarkGreen
highlight StatusLine 		ctermfg=Black	ctermbg=Blue	cterm=none	guifg=Black	guibg=Blue	gui=none
highlight pythonClass		ctermfg=Green					guifg=Blue
highlight pythonSelf		ctermfg=red					guifg=#ff88ff
highlight pythonCall            ctermfg=green					guifg=#bbff88
highlight pythonMemberCall      ctermfg=green					guifg=#bbff44
highlight pythonMember		ctermfg=blue					guifg=#bb44ff
highlight pythonObject		ctermfg=blue					guifg=#8800ff
highlight pythonVariable	ctermfg=blue					guifg=#8800ff
"highlight pythonBoolean		ctermfg=red					guifg=red


highlight Folded		ctermfg=White	ctermbg=Black			guifg=White      guibg=Black
highlight FoldColumn		ctermfg=White	ctermbg=Black			guifg=White      guibg=Black

