" Vim syntax file
" Language:	generic log file
" Written By:	J Alan Brogan
" Last Change:	November 19th, 2007

" For version 5.x: Clear all syntax items
" For version 6.x: Quit when a syntax file was already loaded
if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

syn case ignore

syn match	logComment	"^#.*$" 
syn match	logCommand	"^[a-zA-Z$].*$"
syn match	logOutput	"^\tO.*$" contains=logPrefix
syn match	logError	"^\tE.*$" contains=logPrefix
syn match	logWarning	"^\tW.*$" contains=logPrefix
syn match	logPrefix	"^\t[OEW]" contained

" Define the default highlighting.
" For version 5.7 and earlier: only when not done already
" For version 5.8 and later: only when an item doesn't have highlighting yet
if version >= 508 || !exists("did_log_syntax_inits")
  if version < 508
    let did_log_syntax_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif

  HiLink logCommand		Function
  HiLink logComment		Comment
  HiLink logOutput		String
  HiLink logWarning		Statement
  HiLink logError		Error
  highlight Invisible		ctermfg=Black ctermbg=Black guifg=Black guibg=Black
  HiLink logPrefix		Invisible

  delcommand HiLink
endif

let b:current_syntax = "fulllog"

" vim: ts=8
