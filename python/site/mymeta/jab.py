jab_grammar = r"""

any_blank_lines ::= <blank_line>*:i => len(i)
some_blank_lines ::= <blank_line>+:i => len(i)
blank_line ::= <any_blanks>:i <eol> => i
lines ::= <line>+
line ::= <not_eol>*:i <eol> => ''.join(i).rstrip()

some_blanks ::= <blank>+:i	=> ''.join(i)
any_blanks ::= <blank>*:i	=> ''.join(i)
not_blank ::= <anything>:i ?(i not in ' 	') => i
not_eol ::= <anything>:i ?(i not in '\n\r') => i
blank ::= <space> | <tab>

same :p ::= <anything>:i ?(i == p) => i
different :p ::= <anything>:i ?(i != p) => i
not_x ::= <not 'x'>
not :p ::= <different p>*:i => ''.join(i)
up_to_x ::= <up_to 'x'>
up_to :p ::= <different p>*:i <anything> => ''.join(i)

line_of :p ::= <same p>+ <eol>:i => i

indented_text_line ::= <some_indentation>:i <text_line>:j => [ i, j ]
lines_indented ::= <line_indented>+
line_indented ::= <indented_line>:i => i[1]
indented_line ::=  <some_indentation>:i <not_eol>*:j <eol> => [ i, ''.join(j) ]
any_indentation ::= (<any_spaced_indent> | <any_tabbed_indent>):i => len(i)
some_indentation ::= (<some_spaced_indent> | <some_tabbed_indent>):i => len(i)
any_spaced_indent ::= <four_spaces>*
any_tabbed_indent ::= <tab>*
some_spaced_indent ::= <four_spaces>+
some_tabbed_indent ::= <tab>+
indent ::= <four_spaces> | <tab>
four_spaces ::= ' ' ' ' ' ' ' ' => '    '

text_line ::= <text_char>*:i <eol> => ''.join(i)
counted_line ::= <not_eol>*:i <eol>:j => (j, i)
counted_lines ::= <counted_line>+
text_char ::= <blank> | <non_blank_text_char>
non_blank_text_char ::= <letter> | <digit> | <punctuation>
punctuation ::= <sentence_punctuation> | <geek_punctuation>

identifier ::= (
	<letter>:i
	(<letter> | <digit> | <underscore>)*:j
) => ''.join([i]+j)

sentence_punctuation ::= (
	  <dot>
	| <comma>
	| <semi_colon>
	| <colon>
	| <dash>
	| <open_bracket>
	| <close_bracket>
	| <text_quote>
)
geek_punctuation ::= (
	  <slash>
	| <underscore>
	| <open_brace>
	| <close_brace>
	| <open_brick>
	| <close_brick>
	| <asterisk>
	| <plus>
	| <minus>
	| <less>
	| <greater>
)
text_quote ::= <single_quote> | <double_quote>

integer ::= <digit>+:i => int(''.join(i))

slash ::= <back_slash> | <forward_slash>

asterisk ::= '*'
at ::= '@'
back_slash ::= '\\'
bar ::= '|'
colon ::= ':'
comma ::= ','
close_brace ::= '}'
close_bracket ::= ')'
close_brick ::= ']'
dash ::= '-'
dot ::= '.'
eol_char ::= '\n' | '\r'
eol ::= <eol_char>:i => self.match_eol()
equals ::= '='
exclamation ::= '!'
forward_slash ::= '/'
greater ::= '>'
hash ::= '#'
less ::= '<'
minus ::= '-'
open_brace ::= '{'
open_bracket ::= '('
plus ::= '+'
question ::= '?'
semi_colon ::= ';'
single_quote ::= '\''
space ::= ' '
tab ::= '\t' | '	'
underscore ::= '_'
open_brick ::= '['
double_quote ::= '"'
"""
from path import path
try: from pymeta.grammar import OMeta
except TypeError, e:
	if 'getlines' in str(e):
		import platform
		raise ImportError, 'PyMeta needs Python version >= 2.5, not %s' % platform.python_version()
except ImportError:
	import sys
	raise ValueError('Could not import pymeta.grammar.Ometa from %r' % str(sys.path))

ometa_jab = OMeta.makeGrammar(jab_grammar, globals(), name="jab")

class GrammarHelper(object):
	def __init__(self):
		self.line_number = 0

	def match_eol(self):
		self.line_number += 1
		return self.line_number

class jab(ometa_jab,GrammarHelper):
	def __init__(self,s):
		ometa_jab.__init__(self,s)
		GrammarHelper.__init__(self)

def file_grammar(grammar_file):
	root = path(grammar_file).namebase
	grammar = jab.makeGrammar(str(file(grammar_file).read()), globals(), name=root)
	def file_parse(path_to_file):
		source = file(path_to_file).read()
		return grammar(source).apply(root)
	return file_parse

def file_or_source(source):
	try: return file(source).read()
	except IOError: return source

def grammar_tester(grammar_file):
	root = path(grammar_file).namebase
	grammar = jab.makeGrammar(file_or_source(grammar_file),globals(), name=root)
	def test_parse(rule,source):
		result, error = grammar(file_or_source(source)).apply(rule)
		if result:
			return result
		raise error
	return test_parse
