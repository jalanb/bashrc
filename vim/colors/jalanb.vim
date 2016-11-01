" local syntax file - set colors on a per-machine basis:
" vim: tw=0 ts=8 sw=4
" Vim color file
" Maintainer:    J Alan Brogan (vim@al-got-rhythm.net)
" Last Change:    2004 Aug 21

if version < 600
  syntax clear
elseif exists("b:current_syntax")
  finish
endif

let python_highlight_all = 1

if exists("python_highlight_all") && python_highlight_all != 0
  " Not override previously set options
  if !exists("python_highlight_builtins")
    if !exists("python_highlight_builtin_objs")
      let python_highlight_builtin_objs = 1
    endif
    if !exists("python_highlight_builtin_funcs")
      let python_highlight_builtin_funcs = 1
    endif
  endif
  if !exists("python_highlight_exceptions")
    let python_highlight_exceptions = 1
  endif
  if !exists("python_highlight_string_formatting")
    let python_highlight_string_formatting = 1
  endif
  if !exists("python_highlight_string_format")
    let python_highlight_string_format = 1
  endif
  if !exists("python_highlight_string_templates")
    let python_highlight_string_templates = 1
  endif
  if !exists("python_highlight_indent_errors")
    let python_highlight_indent_errors = 1
  endif
  if !exists("python_highlight_space_errors")
    let python_highlight_space_errors = 1
  endif
  if !exists("python_highlight_doctests")
    let python_highlight_doctests = 1
  endif
endif

" Keywords
syn keyword pythonNone      None
syn keyword pythonBoolean   False True
syn keyword pythonKeyword   as assert del exec global
syn keyword pythonBranch    break continue
syn keyword pythonKeyword   lambda nonlocal pass print return with yield
syn keyword pythonClassStatement    class nextgroup=pythonClassname skipwhite
syn keyword pythonFuncStatement def cdef nextgroup=pythonFunction skipwhite
syn keyword pythonConditional   elif else if
syn keyword pythonRepeat    for while
syn keyword pythonOperator  and in is not or
syn keyword pythonException except finally raise try
syn keyword pythonInclude   from import
syn match   pythonFunction  "\h\w*" display contained
syn match   pythonClassname "\h\w*\((\h\w*)\)\?" display contained

" Decorators (new in Python 2.4)
syn match   pythonDecorator "@" display nextgroup=pythonDottedName skipwhite
syn match   pythonDottedName "[a-zA-Z_][a-zA-Z0-9_]*\(\.[a-zA-Z_][a-zA-Z0-9_]*\)*" display contained
syn match   pythonDot        "\." display containedin=pythonDottedName

" Comments
syn match   pythonComment   "#.*$" display contains=pythonTodo,@Spell
syn match   pythonRun       "\%^#!.*$"
syn match   pythonCoding    "\%^.*\%(\n.*\)\?#.*coding[:=]\s*[0-9A-Za-z-_.]\+.*$"
syn keyword pythonTodo      TODO FIXME XXX contained

" Errors
syn match pythonError       "\<\d\+\D\+\>" display
syn match pythonError       "[$?]" display
syn match pythonError       "[&|]\{2,}" display
syn match pythonError       "[=]\{3,}" display

" TODO: Mixing spaces and tabs also may be used for pretty formatting multiline
" statements. For now I don't know how to work around this.
if exists("python_highlight_indent_errors") && python_highlight_indent_errors != 0
  syn match pythonIndentError   "^\s*\%( \t\|\t \)\s*\S"me=e-1 display
endif

" Trailing space errors
if exists("python_highlight_space_errors") && python_highlight_space_errors != 0
  syn match pythonSpaceError    "\s\+$" display
endif

" Strings
syn region pythonString     start=+'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonEscape,pythonEscapeError,@Spell
syn region pythonString     start=+"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonEscape,pythonEscapeError,@Spell
syn region pythonString     start=+"""+ end=+"""+ keepend contains=pythonEscape,pythonEscapeError,pythonDocTest2,pythonSpaceError,@Spell
syn region pythonString     start=+'''+ end=+'''+ keepend contains=pythonEscape,pythonEscapeError,pythonDocTest,pythonSpaceError,@Spell

syn match  pythonEscape         +\\[abfnrtv'"\\]+ display contained
syn match  pythonEscape         "\\\o\o\=\o\=" display contained
syn match  pythonEscapeError    "\\\o\{,2}[89]" display contained
syn match  pythonEscape         "\\x\x\{2}" display contained
syn match  pythonEscapeError    "\\x\x\=\X" display contained
syn match  pythonEscape         "\\$"
syn match  pythonEscape         "\\u\x\{4}" display contained
syn match  pythonEscapeError    "\\u\x\{,3}\X" display contained
syn match  pythonEscape         "\\U\x\{8}" display contained
syn match  pythonEscapeError    "\\U\x\{,7}\X" display contained
syn match  pythonEscape         "\\N{[A-Z ]\+}" display contained
syn match  pythonEscapeError    "\\N{[^A-Z ]\+}" display contained

" Raw strings
syn region pythonRawString  start=+[bB]\=[rR]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonRawEscape,@Spell
syn region pythonRawString  start=+[bB]\=[rR]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonRawEscape,@Spell
syn region pythonRawString  start=+[bB]\=[rR]"""+ end=+"""+ keepend contains=pythonDocTest2,pythonSpaceError,@Spell
syn region pythonRawString  start=+[bB]\=[rR]'''+ end=+'''+ keepend contains=pythonDocTest,pythonSpaceError,@Spell

syn match pythonRawEscape   +\\['"]+ display transparent contained

" Bytes
syn region pythonBytes      start=+[bB]'+ skip=+\\\\\|\\'\|\\$+ excludenl end=+'+ end=+$+ keepend contains=pythonBytesError,pythonBytesContent,@Spell
syn region pythonBytes      start=+[bB]"+ skip=+\\\\\|\\"\|\\$+ excludenl end=+"+ end=+$+ keepend contains=pythonBytesError,pythonBytesContent,@Spell
syn region pythonBytes      start=+[bB]"""+ end=+"""+ keepend contains=pythonBytesError,pythonBytesContent,pythonDocTest2,pythonSpaceError,@Spell
syn region pythonBytes      start=+[bB]'''+ end=+'''+ keepend contains=pythonBytesError,pythonBytesContent,pythonDocTest,pythonSpaceError,@Spell

syn match pythonBytesError    ".\+" display contained
syn match pythonBytesContent    "[\u0000-\u00ff]\+" display contained contains=pythonBytesEscape,pythonBytesEscapeError

syn match pythonBytesEscape     +\\[abfnrtv'"\\]+ display contained
syn match pythonBytesEscape     "\\\o\o\=\o\=" display contained
syn match pythonBytesEscapeError    "\\\o\{,2}[89]" display contained
syn match pythonBytesEscape     "\\x\x\{2}" display contained
syn match pythonBytesEscapeError    "\\x\x\=\X" display contained
syn match pythonBytesEscape     "\\$"

if exists("python_highlight_string_formatting") && python_highlight_string_formatting != 0
  " String formatting
  syn match pythonStrFormatting "%\%(([^)]\+)\)\=[-#0 +]*\d*\%(\.\d\+\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonRawString
  syn match pythonStrFormatting "%[-#0 +]*\%(\*\|\d\+\)\=\%(\.\%(\*\|\d\+\)\)\=[hlL]\=[diouxXeEfFgGcrs%]" contained containedin=pythonString,pythonRawString
endif

if exists("python_highlight_string_format") && python_highlight_string_format != 0
  " str.format syntax
  syn match pythonStrFormat "{{\|}}" contained containedin=pythonString,pythonRawString
  syn match pythonStrFormat "{\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)\=\%(\.\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\[\%(\d\+\|[^!:\}]\+\)\]\)*\%(![rsa]\)\=\%(:\%({\%(\%([^[:cntrl:][:space:][:punct:][:digit:]]\|_\)\%([^[:cntrl:][:punct:][:space:]]\|_\)*\|\d\+\)}\|\%([^}]\=[<>=^]\)\=[ +-]\=#\=0\=\d*,\=\%(\.\d\+\)\=[bcdeEfFgGnosxX%]\=\)\=\)\=}" contained containedin=pythonString,pythonRawString
endif

if exists("python_highlight_string_templates") && python_highlight_string_templates != 0
  " String templates
  syn match pythonStrTemplate   "\$\$" contained containedin=pythonString,pythonRawString
  syn match pythonStrTemplate   "\${[a-zA-Z_][a-zA-Z0-9_]*}" contained containedin=pythonString,pythonRawString
  syn match pythonStrTemplate   "\$[a-zA-Z_][a-zA-Z0-9_]*" contained containedin=pythonString,pythonRawString
endif

if exists("python_highlight_doctests") && python_highlight_doctests != 0
  " DocTests
  syn region pythonDocTest  start="^\s*>>>" end=+'''+he=s-1 end="^\s*$" contained
  syn region pythonDocTest2 start="^\s*>>>" end=+"""+he=s-1 end="^\s*$" contained
endif

" Numbers (ints, longs, floats, complex)
syn match   pythonHexError  "\<0[xX]\x*[g-zG-Z]\x*\>" display

syn match   pythonHexNumber "\<0[xX]\x\+\>" display
syn match   pythonOctNumber "\<0[oO]\o\+\>" display
syn match   pythonBinNumber "\<0[bB][01]\+\>" display

syn match   pythonNumberError   "\<\d\+\D\>" display
syn match   pythonNumberError   "\<0\d\+\>" display
syn match   pythonNumber    "\<\d\>" display
syn match   pythonNumber    "\<[1-9]\d\+\>" display
syn match   pythonNumber    "\<\d\+[jJ]\>" display

syn match   pythonFloat     "\.\d\+\%([eE][+-]\=\d\+\)\=[jJ]\=\>" display
syn match   pythonFloat     "\<\d\+[eE][+-]\=\d\+[jJ]\=\>" display
syn match   pythonFloat     "\<\d\+\.\d*\%([eE][+-]\=\d\+\)\=[jJ]\=" display

syn match   pythonOctError  "\<0[oO]\=\o*[8-9]\d*\>" display
syn match   pythonBinError  "\<0[bB][01]*[2-9]\d*\>" display

if exists("python_highlight_builtin_objs") && python_highlight_builtin_objs != 0
  " Builtin objects and types
  syn keyword pythonBuiltinObj  Ellipsis NotImplemented
  syn keyword pythonBuiltinObj  __debug__ __doc__ __file__ __name__ __package__
endif

if exists("python_highlight_builtin_funcs") && python_highlight_builtin_funcs != 0
  " Builtin functions
  syn keyword pythonBuiltinFunc __import__ abs all any ascii
  syn keyword pythonBuiltinFunc bin
  syn keyword pythonBuiltinFunc chr classmethod cmp compile
  syn keyword pythonBuiltinFunc delattr dir divmod enumerate eval
  syn keyword pythonBuiltinFunc exec filter format getattr
  syn keyword pythonBuiltinFunc globals hasattr hash
  syn keyword pythonBuiltinFunc input isinstance
  syn keyword pythonBuiltinFunc issubclass iter len locals map max
  syn keyword pythonBuiltinFunc memoryview min next open ord
  syn keyword pythonBuiltinFunc pow range
  syn keyword pythonBuiltinFunc repr reversed round setattr
  syn keyword pythonBuiltinFunc sorted staticmethod sum
  syn keyword pythonBuiltinFunc vars zip

  syn keyword pythonBuiltinType bool bytearray bytes complex dict float frozenset
  syn keyword pythonBuiltinType hex id int list object oct property set slice
  syn keyword pythonBuiltinType str super tuple type
endif

if exists("python_highlight_exceptions") && python_highlight_exceptions != 0
  " Builtin exceptions and warnings
  syn keyword pythonExClass BaseException
  syn keyword pythonExClass Exception ArithmeticError
  syn keyword pythonExClass LookupError EnvironmentError

  syn keyword pythonExClass AssertionError AttributeError BufferError EOFError
  syn keyword pythonExClass FloatingPointError GeneratorExit IOError
  syn keyword pythonExClass ImportError IndexError KeyError
  syn keyword pythonExClass KeyboardInterrupt MemoryError NameError
  syn keyword pythonExClass NotImplementedError OSError OverflowError
  syn keyword pythonExClass ReferenceError RuntimeError StopIteration
  syn keyword pythonExClass SyntaxError IndentationError TabError
  syn keyword pythonExClass SystemError SystemExit TypeError
  syn keyword pythonExClass UnboundLocalError UnicodeError
  syn keyword pythonExClass UnicodeEncodeError UnicodeDecodeError
  syn keyword pythonExClass UnicodeTranslateError ValueError VMSError
  syn keyword pythonExClass WindowsError ZeroDivisionError

  syn keyword pythonExClass Warning UserWarning BytesWarning DeprecationWarning
  syn keyword pythonExClass PendingDepricationWarning SyntaxWarning
  syn keyword pythonExClass RuntimeWarning FutureWarning
  syn keyword pythonExClass ImportWarning UnicodeWarning
endif

if exists("python_slow_sync") && python_slow_sync != 0
  syn sync minlines=2000
else
  " This is fast but code inside triple quoted strings screws it up. It
  " is impossible to fix because the only way to know if you are inside a
  " triple quoted string is to start from the beginning of the file.
  syn sync match pythonSync grouphere NONE "):$"
  syn sync maxlines=200
endif

if version >= 508 || !exists("did_python_syn_inits")
  if version <= 508
    let did_python_syn_inits = 1
    command -nargs=+ HiLink hi link <args>
  else
    command -nargs=+ HiLink hi def link <args>
  endif
  " Brackets, Parenthesis, Curly Brackets
  syn match pythonBraces       "[{}\[\]]"
  syn match pythonParens       "[()]"
  syn match pythonOpSymbols    "=\{1,3}\|!==\|!=\|<\|>\|>=\|<=\|++\|+=\|--\|-="
  syn match   pythonLogicSymbols "\(&&\)\|\(||\)"
  HiLink pythonOpSymbols            Operator
  HiLink pythonLogicSymbols         Boolean
  HiLink pythonBraces               Function
  HiLink pythonParens               Operator
  HiLink pythonBranch       Conditional
" HiLink pythonClass        PreProc
  HiLink pythonNone         Number

  HiLink pythonKeyword      Keyword
  HiLink pythonStatement    Statement
  HiLink pythonPreCondit    PreCondit
  HiLink pythonFunction     Function
  HiLink pythonConditional  Conditional
  HiLink pythonRepeat       Repeat
  HiLink pythonException    Exception
  HiLink pythonOperator     Operator
  HiLink pythonInclude      Include
  HiLink pythonBoolean      Boolean

  HiLink pythonDecorator    Define
  HiLink pythonDottedName   Identifier
  HiLink pythonDot          Special

  HiLink pythonComment      Comment
  HiLink pythonCoding       Comment
  HiLink pythonRun          Comment
  HiLink pythonTodo         Todo

  HiLink pythonError        Error
  HiLink pythonIndentError  Error
  HiLink pythonSpaceError   Error

  HiLink pythonString       String
  HiLink pythonRawString    String
  HiLink pythonEscape           Special
  HiLink pythonEscapeError      Error

  HiLink pythonBytes            String
  HiLink pythonBytesContent     String
  HiLink pythonBytesError       Error
  HiLink pythonBytesEscape      Special
  HiLink pythonBytesEscapeError Error

  HiLink pythonStrFormatting    Special
  HiLink pythonStrFormat        Special
  HiLink pythonStrTemplate      Special

"  HiLink pythonDocTest     Special
  HiLink pythonDocTest2     pythonDocTest

  HiLink pythonNumber       Number
  HiLink pythonHexNumber    Number
  HiLink pythonOctNumber    Number
  HiLink pythonBinNumber    Number
  HiLink pythonFloat        Float
  HiLink pythonNumberError  Error
  HiLink pythonOctError     Error
  HiLink pythonHexError     Error
  HiLink pythonBinError     Error

  HiLink pythonBuiltinObj   Type
  HiLink pythonBuiltinType  Type
 "HiLink pythonBuiltinFunc  pythonFunction

  HiLink pythonExClass      Structure

  HiLink pythonClassStatement       PreProc
  HiLink pythonFuncStatement        PreProc

syn match   pythonVariable  "\<\zs\h\w*"
syn match   pythonObject    "\<\zs\h\w*\ze\."
syn match   pythonCall      "\<[a-z_]\w*\ze("
syn match   pythonInstance  "\<[A-Z]\w*\ze("
syn match   pythonMember    "\.\h\w*\>"
syn match   pythonMemberCall    "\.\h\w*\ze("
syn match   pythonSelf      "\<self\>"
  delcommand HiLink
endif

let b:current_syntax = "python"
setlocal spelllang=en_gb

   call rainbow_parenthsis#LoadSquare ()
   call rainbow_parenthsis#LoadRound ()
   call rainbow_parenthsis#LoadBraces ()
   call rainbow_parenthsis#Activate ()
hi clear
set background=dark
if exists("syntax_on")
  syntax reset
endif
let g:colors_name = "jalanb"

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
