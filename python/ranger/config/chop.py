"""Chop given lines at a specified width"""


import os
import sys
from optparse import OptionParser


import ansi_escapes


def handle_command_line():
	"""Get an optional width from the command line"""
	parser = OptionParser()
	parser.add_option('-w', dest='width', action='store', type='int', nargs=1, default=os.environ.get('COLUMNS',80))
	parser.add_option('-s', dest='space', action='store_true', default=False)
	return parser.parse_args()


def main():
	indent = 4
	options, args = handle_command_line()
	for line in sys.stdin.readlines():
		line = line.rstrip()
		counting = True
		count = 0
		chars = []
		for c in line:
			if counting:
				if c == '\x1b':
					counting = False
			else:
				if c == 'm':
					counting = True
				chars.append(c)
				continue
			if c == '\t':
				number_of_chars = min(indent, options.width - count)
				tabs = options.space and '|   ' or '    '
				suffix = tabs[:number_of_chars]
			else:
				if c == ' ':
					c = options.space and '.' or ' '
				suffix = c
				number_of_chars = 1
			if counting:
				count += number_of_chars
				#print '%d <= %d: %s' %(count, number_of_chars, repr(chars))
			if count > options.width:
				break
			chars.append(suffix)
		string = ''.join(chars)
		print '%s%s' % (string, ansi_escapes.no_colour())
	return 0

if __name__ == '__main__':
	sys.exit(main())
