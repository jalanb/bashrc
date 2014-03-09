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

highlight CursorLine                                      cterm=underline                 guibg=#080808   gui=underline
highlight StatusLine        ctermfg=Black                 cterm=None       guifg=#000000  guibg=#0000ff   gui=none
highlight Normal            ctermfg=White    ctermbg=Black                 guifg=#ffffff  guibg=#000000
highlight Error                              ctermbg=Red                                  guibg=#ff0000
highlight Todo              ctermfg=Black    ctermbg=Green                 guifg=#000080  guibg=#c0c000
highlight Search            ctermfg=196      ctermbg=52                    guifg=#ff0000  guibg=#402020
highlight Comment           ctermfg=241      ctermbg=232                   guifg=#626262
highlight pythonBoolean     ctermfg=33                                     guifg=#0087ff
highlight Number            ctermfg=39
highlight String            ctermfg=159                                    guifg=#afffff
highlight pythonDocTest     ctermfg=27
highlight pythonEscape      ctermfg=21                                     guifg=#0000ff
highlight Identifier        ctermfg=32                                     guifg=#0087d7
highlight Keyword           ctermfg=196                                    guifg=#ff0000                  gui=bold
highlight Statement         ctermfg=160                                    guifg=#d70000                  gui=bold
highlight Repeat            ctermfg=88                                     guifg=#870000                  gui=bold
highlight Conditional       ctermfg=124                                    guifg=#af0000                  gui=bold
highlight Exception         ctermfg=160                                    guifg=#d70000                  gui=bold
highlight Structure         ctermfg=196                                    guifg=#ff0000                  gui=bold
highlight PreProc           ctermfg=130                                    guifg=#af5f00                  gui=bold
highlight Type              ctermfg=52                                     guifg=#5f0000                  gui=bold
highlight pythonClassname   ctermfg=56                                     guifg=#5f00d7
highlight pythonFunction    ctermfg=68                                     guifg=#5f87d7
highlight pythonBuiltinFunc ctermfg=58                                     guifg=#5f5f00
highlight pythonSelf        ctermfg=97                                     guifg=#875FAF
highlight pythonCall        ctermfg=46                                     guifg=#00FF00
highlight pythonInstance    ctermfg=48                                     guifg=#00FF87
highlight pythonMemberCall  ctermfg=28                                     guifg=#008700
highlight pythonMember      ctermfg=171                                    guifg=#D75FFF
highlight pythonObject      ctermfg=91                                     guifg=#8700AF
highlight pythonVariable    ctermfg=90                                     guifg=#870087
highlight Special           ctermfg=226                                    guifg=#FFFF00                  gui=bold
highlight Constant          ctermfg=Cyan      ctermbg=234                  guifg=#0066FF
highlight Directory         ctermfg=DarkGreen ctermbg=233                  guifg=#008800

" Spacings
highlight pythonIndentError ctermfg=Black    ctermbg=198                   guifg=#FF0087
highlight pythonSpaceError  ctermfg=Black    ctermbg=198                   guifg=#FF0087

highlight Folded            ctermfg=White    ctermbg=Black                 guifg=#ffffff  guibg=Black
highlight FoldColumn        ctermfg=White    ctermbg=Black                 guifg=#ffffff  guibg=Black

highlight MatchParen gui=bold guibg=NONE                                  guifg=lightblue  cterm=bold ctermbg=NONE

"
" for the plugin EasyMotion.vim
"
highlight EasyMotionTarget  ctermfg=DarkRed  ctermbg=none
highlight EasyMotionShade   ctermfg=Gray     ctermbg=none
