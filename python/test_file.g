test_file ::= <main_section>*

main_section ::= (
		<main_section_text>:i 
		<sub_section>*:j 
	) => Section(i,j)

main_section_text ::= (
		<main_section_head>:i 
		<section_body>:j 
	) => i, j

sub_section ::= (
		<sub_section_head>:i 
		<section_body>:j 
	) => i, j

main_section_head ::= <section_head '='>
sub_section_head ::= <section_head '-'>

section_head :p ::= (
		<text_char>*:i 
		<eol> 
		<line_of p>
		<any_blank_lines>:k
	) => ''.join(i)

section_body ::= (
		<examples>:i 
		<example_paragraph>*:j 
	) => j and [i,j] or i

examples ::= <example>+
example ::= (
		<example_text>:i 
		<example_python>:j
	) => Example(i,j)

example_text ::= <example_paragraph>*

example_python ::= (
		<example_python_lines>:i 
		<example_data>:j 
		<any_blank_lines> 
	) => [i, j]

example_paragraph ::= (
		<example_text_line>:i 
		(~~(<anything>):k ?(k not in '=-'))
		<indented_example_text_line>*:j
		<any_blank_lines> 
	) => [i] + j

indented_example_text_line ::= (
		( <some_indentation> <example_text_line> ) |
		<blank_line>
	)

example_text_line ::= (
		<non_blank_text_char>:i 
		<text_char>*:j 
		<eol> 
	) => ''.join([i]+j)


example_python_lines ::= (
		<example_python_line>:i 
		<example_python_continuation>*:j
	)  => [i] + j

example_python_line ::= (
		<some_indentation> 
		'>' '>' '>' ' ' 
		<line>:i 
	) => i

example_python_continuation ::= (
		<some_indentation> 
		'.' '.' '.' ' ' 
		<line>:i
	) =>  i

example_data ::= <example_data_line>*

example_data_line ::= (
		<some_indentation> 
		(<anything>:i ?(i not in '>.\n')) 
		<line>:j 
	) => i + j

