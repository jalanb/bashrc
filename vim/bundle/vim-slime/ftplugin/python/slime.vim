function! _EscapeText_python(text)
  return substitute(substitute(a:text, "\n", "", "g"),"\t","    ","g")
endfunction
