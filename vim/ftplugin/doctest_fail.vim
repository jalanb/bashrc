if exists("b:loaded_jab_doctest_fail_buffer")  
	finish
endif
let b:loaded_jab_doctest_fail_buffer = "v001"


if expand("%:e") != "fail"
	finish
endif

setlocal autoread
setlocal nomodifiable
