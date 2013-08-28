"""Script to display a todo list"""

import re
import os
import sys
try:
	from namedtuple import namedtuple
except ImportError:
	from collections import namedtuple

import colours

def todo_file():
	"""Get the filename from the environment"""
	# Tell pylint not to warn that this is a todo
	# pylint: disable-msg=W0511
	if sys.argv[1:]:
		arg = sys.argv[1]
		if os.path.isfile(arg):
			return arg
	return os.environ['JAB_TODO']

def read_todo(path_to_todo):
	result = []
	for line in file(path_to_todo):
		line = line.rstrip()
		if not line:
			continue
		result.append(line)
	return result

def read_todo_items():
	path_to_todo = todo_file()
	lines = read_todo(path_to_todo)
	return [ parse_todo_line(l) for l in lines ]

def priorities():
	"""The recognised priorities in this system"""
	Priority = namedtuple('Priority', 'number, name, colour')
	return [
		Priority(1, 'yesterday', 'red'),
		Priority(2, 'today',     'light red'),
		Priority(3, 'tomorrow',  'light magenta'),
		Priority(4, 'feature',   'magenta'),
		Priority(5, 'wish',      'gray'),
	]

def priority_keys_string():
	"""A string with the priority numbers in this system"""
	return ''.join([ str(priority.number) for priority in priorities() ])

def priority_colour(priority_number):
	for priority in priorities():
		if priority_number == priority.number:
			return priority.colour
	return 'white'

def parse_todo_line(line):
	"""Extract a list of todo items from a list of lines

	Each item is a tuple of (text, priority)
	"""
	item_regexp = re.compile('^(?P<text>.*), (?P<priority>[%s])$' % priority_keys_string())
	match = item_regexp.match(line)
	Item = namedtuple('TodoItem', 'text, priority')
	if not match:
		Item = namedtuple('TextItem', 'text, priority')
		return Item(line, -1)
	text = match.groupdict()['text']
	priority = match.groupdict()['priority']
	return Item( text, int(priority) )

def show_todo_item(item):
	"""Show the item on screen, coloured by it's priority"""
	print colours.colour_text(item.text, priority_colour(item.priority))

def main():
	"""Read all todo items and show them on screen"""
	for item in read_todo_items():
		show_todo_item(item)
	return 0

if __name__ == '__main__':
	sys.exit(main())
