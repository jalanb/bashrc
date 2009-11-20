fail_file ::= (
		<failure>*:i 
		<fail_summary>:j
	) => make_fail_file(i,j)

had_fails_line ::= (
		<integer>:i 
		<spaces> 
		<token "items had failures"> 
		<line>
	) => i

fail_summary ::= (
		<line_of '*'> 
		<integer> <line>
		<space> <line>
		<token "***Test Failed*** "> <integer>:i <line>
	) => i

failure ::= (
		<line_of '*'>:h
		<file_line>:i 
		<example_section> 
		<result_section>:j
	) => Failure( i, j, h) 


result_section ::= <exception_raised> | <result_difference>

exception_header ::= <token "Exception raised:"> <eol> => None
exception_raised ::= <exception_header> <lines_indented>:i => [ '', i ]

result_difference ::= <expected_section>:i <actual_section>:j => [ i, j ]

file_line ::= (
		<token "File"> 
		<spaces> 
		<string>:i 
		<token ", line "> 
		<integer>:j 
		<line> 
	) => [i, j]

example_section ::= <example_header> <line_indented>
example_header ::= <token "Failed example"> <colon> <eol>

expected_section ::= <expected_something> | <expected_nothing>
expected_nothing ::= <token "Expected nothing"> <eol> => []
expected_something ::= <expected_header> <lines_indented>
expected_header ::= <token "Expected"> <colon> <eol> => []

actual_section ::= <actual_header> <lines_indented>
actual_header ::= <token "Got:"> <eol> => []

list_of :p :q ::= <apply p>:i ( <apply q> <apply p> )*:j => [i] + j
comma_separated_list :p ::= <list_of p ','>

quote ::= <single_quote> | <double_quote>
string ::= <quote>:i <different i>*:j <same i> => ''.join(j)

