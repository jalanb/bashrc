" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=8 sw=4
" Vim color file
" Maintainer:    J Alan Brogan (vim@al-got-rhythm.net)
" Last Change:    2004 Aug 21

hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "alan-colour"

highlight CursorLine                                      cterm=underline                guibg=#080808   gui=underline 
highlight StatusLine        ctermfg=Black    ctermbg=Blue                  guifg=#000000  guibg=#0000ff   gui=none
highlight Normal            ctermfg=White    ctermbg=Black                 guifg=#ffffff  guibg=#000000
highlight Error                             ctermbg=Red                                  guibg=#ff0000
highlight Todo              ctermfg=Black    ctermbg=Green                 guifg=#000080  guibg=#c0c000
highlight Search            ctermfg=196      ctermbg=52                    guifg=#ff0000  guibg=#402020
highlight Comment           ctermfg=241      ctermbg=233                   guifg=#808080
highlight pythonBoolean     ctermfg=33                                     guifg=#0087ff
highlight Number            ctermfg=39
highlight String            ctermfg=159                                    guifg=#87ffff
highlight pythonDocTest     ctermfg=27                  
highlight pythonEscape      ctermfg=21                                     guifg=#0000ff
highlight Identifier        ctermfg=32                                     guifg=#44ff44
highlight Keyword           ctermfg=196                                    guifg=#ff0000                  gui=bold
highlight Statement         ctermfg=160                                    guifg=#ff0000                  gui=bold
highlight Repeat            ctermfg=88                                     guifg=#ff0000                  gui=bold
highlight Conditional       ctermfg=124                                    guifg=#ff0000                  gui=bold
highlight Exception         ctermfg=160                                    guifg=#5f0000                  gui=bold
highlight Structure         ctermfg=196                                    guifg=#5f0000                  gui=bold
highlight PreProc           ctermfg=130                                    guifg=#ff4444                  gui=bold
highlight Type              ctermfg=52                                     guifg=#ff4444                  gui=bold
highlight pythonClassname   ctermfg=56                                     guifg=#0000ff
highlight pythonFunction    ctermfg=68                                     guifg=#0000ff
highlight pythonBuiltinFunc ctermfg=58                                     guifg=#0000ff
highlight pythonSelf        ctermfg=97                                     guifg=#ff88ff
highlight pythonCall        ctermfg=46                                     guifg=#bbff88
highlight pythonInstance    ctermfg=48                                     guifg=#bbff88
highlight pythonMemberCall  ctermfg=28                                     guifg=#bbff44
highlight pythonMember      ctermfg=171                                    guifg=#bb44ff
highlight pythonObject      ctermfg=91                                     guifg=#8800ff
highlight pythonVariable    ctermfg=90                                     guifg=#8800ff
highlight Special           ctermfg=226                                    guifg=#ff4444                  gui=bold
highlight Constant          ctermfg=Cyan     ctermbg=121                   guifg=#0066FF
highlight Directory         ctermfg=DarkGreen ctermbg=240                  guifg=#008800


highlight Folded         ctermfg=White    ctermbg=Black                    guifg=#ffffff  guibg=Black
highlight FoldColumn         ctermfg=White    ctermbg=Black                guifg=#ffffff  guibg=Black

highlight MatchParen gui=bold guibg=NONE                                  guifg=lightblue  cterm=bold ctermbg=NONE

"
" for the plugin EasyMotion.vim
"
highlight EasyMotionTarget ctermbg=none  ctermfg=DarkRed
highlight EasyMotionShade  ctermbg=none  ctermfg=Gray
