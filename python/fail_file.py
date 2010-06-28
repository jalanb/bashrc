import os

from mymeta.jab import jab

def show(name,lines):
	return
	print name
	print '....%s' % '\n....'.join([str([c for c in l]) for l in lines])

class FailFile:
	def __init__(self,fails):
		self.failures = fails
		try:
			self.filename = fails[0].filename
		except IndexError:
			self.filename = ''

	def fix(self,backup='~'):
		if backup:
			expected_text = file(self.filename).read()
			file('%s%s' % (self.filename,backup),'w').write(expected_text)
		extra = 0
		for failure in self.failures:
			failure.line += extra
			fixed = failure.fix(backup=None)
			extra += fixed

	def __repr__(self):
		return '<FailFile %r>' % self.filename

class Failure:
	def __init__(self,fileline,expected_actual,start):
		self.filename, self.line = fileline
		self.expected, self.actual = expected_actual
		self.start = start

	def __repr__(self):
		return '<Failure in %s:%d>' % (self.filename,self.line)

	def exists(self):
		return os.path.isfile(self.filename)

	def needed(self):
		if not self.exists():
			return False
		lines = file(self.filename).readlines()
		for i, expected_line in enumerate(self.expected):
			try:
				current_line = lines[self.line + i]
			except IndexError:
				current_line = ""
			if not current_line.strip():
				return True
			if current_line.strip() != expected_line.strip():
				return False
				return '%s != %s' % (current_line.strip(), expected_line.strip())
		return True

	def fixed_lines(self):
		if not self.needed(): return
		lines = file(self.filename).readlines()
		actual_lines = lines[:self.line]
		show( 'Before', lines[:self.line] )
		actual_lines += [ str('\t%s\n' % a) for a in self.actual ]
		show( 'New', [ str('\t%s\n' % a) for a in self.actual ] )
		actual_lines += lines[self.line + len(self.expected):]
		show('After', lines[self.line + len(self.expected):])
		show('All',actual_lines)
		return actual_lines

	def fix(self,backup='~'):
		fixed = self.fixed_lines()
		if not fixed: return
		if backup:
			expected_text = file(self.filename).read()
			file('%s%s' % (self.filename,backup),'w').write(expected_text)
		file(self.filename,'w').write(''.join(fixed))
		return len(self.actual) - len(self.expected)

fail_file_grammar = '''
fail_file ::= (
		<failure>*:i 
		<fail_summary>?:j
	) => make_fail_file(i,j)

had_fails_line ::= (
		<integer>:i 
		<spaces> 
		<token "items had failures"> 
		<line>
	) => i

count_of_count_line ::= (
	<spaces> <integer>
	<spaces> <token 'of'>
	<spaces> <integer>
	<spaces> <token 'in'>
	<string> <line>
)

fail_summary ::= (
		<line_of '*'> 
		<line>
		<spaces> <line>
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
exception_raised ::= <exception_header> <lines_indented>:i => [ '', [i[0],'...',i[-1]] ]

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

'''
fail_file = jab.makeGrammar(fail_file_grammar, globals(), name="fail_file")

def read_fail_file(path_to_file):
	source = file(path_to_file).read()
	if not source:
		return
	return fail_file(source).apply('fail_file')

def make_fail_file(fails,summary_count):
	if summary_count is None: summary_count = 0
	assert summary_count == len(fails), '%s != len(%s)' % (summary_count,fails)
	return FailFile(fails)
	
