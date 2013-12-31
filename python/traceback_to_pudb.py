"""Convert a traceback to breakpoint lines for use with pudb"""


import os
import sys


def de_quote(string):
	"""Remove leading/trailing double quotes

	>>> de_quote('"fred"') == 'fred'
	True
	"""
	return string.strip('"')


def de_comma(string):
	"""Remove any trailing commas

	>>> de_comma(',fred,,')  == ',fred'
	True
	"""
	return string.rstrip(',')


def de_punctuate(string):
	"""Remove quotes and trailing commas

	>>> de_punctuate('"stuff and nonsense",') == 'stuff and nonsense'
	True
	"""
	return de_quote(de_comma(string))


def de_punctuate_word(words, i):
	"""Remove quotes and trailing commas from the i'th word

	>>> de_punctuate_word(['"1"', '"2",'], 1) == '2'
	True
	"""
	return de_punctuate(words[i])


def as_words(string):
	"""Split the string into words

	>>> as_words('\tfred was here    ') == ['fred', 'was', 'here']
	True
	"""
	return string.strip().split()


def lines_of_words(lines):
	"""Read the file, spilt text into lines of words

	>>> lines = lines_of_words(file(__file__).readlines())
	>>> this_line = [l for l in lines if 'this_line' in l][0]
	>>> this_line[:3] == ['>>>', 'this_line', '=']
	True
	"""
	return [as_words(l) for l in lines]


def filter_by_word(lines, word_index, expected_word):
	"""Exclude all lines without that word at that index

	>>> lines = [['one', 'two', 'three'], ['four', 'five']]
	>>> filter_by_word(lines, 1, 'five') == [['four', 'five']]
	True
	"""
	return [l for l in lines if l[word_index] == expected_word]


def parse_traceback_lines(lines):
	"""Extract filename and line number from traceback lines

	>>> lines = [
	...     'File "build.py", line 86, in time',
	...     '    return main()',
	...     'File "build.py", line 52, in main',
	... ]
	>>> parse_traceback_lines(lines)
    [('build.py', '86'), ('build.py', '52')]
	"""
	lines = lines_of_words(lines)
	file_lines = filter_by_word(lines, 0, 'File')
	return [(de_punctuate_word(l, 1), de_punctuate_word(l, 3)) for l in file_lines]


def main(args):
	"""Run the program

	If there are command line arguments
		use them as files containing the tracebacks
	Else
		read the traceback from stdin
	"""
	if args:
		list_of_lines = [file(arg).readlines() for arg in args]
	else:
		list_of_lines = [sys.stdin.readlines()]
	for lines in list_of_lines:
		for line in parse_traceback_lines(lines):
			print 'b', ':'.join(line)
	return os.EX_OK


if __name__ == '__main__':
	sys.exit(main(sys.argv[1:]))
