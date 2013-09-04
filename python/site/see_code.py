"""Module to handle source codes"""


import os
import re
import linecache


class NoCode(ValueError):
	pass


def indent_line(filename, line_number):
	line = linecache.getline(filename, line_number)
	match = re.match('(\s*)', line)
	return line.rstrip(), match.groups()[0]


def subsequent_lines_with_more_indentation(filename, first_line_number):
	line, first_indentation = indent_line(filename, first_line_number)
	result = [line]
	line_number = first_line_number + 1
	line, indentation = indent_line(filename, line_number)
	while indentation > first_indentation:
		result.append(line)
		line_number += 1
		line, indentation = indent_line(filename, line_number)
	return '\n'.join(result)


def code_of_method(method):
	if not callable(method):
		raise NoCode('Not callable: %r' % method)
	try:
		function_code = method.func_code
	except AttributeError:
		raise NoCode('No code available for %s' % method)
	filename = re.sub('.py[co]$', '.py', method.func_code.co_filename)
	if not os.path.isfile(filename):
		raise NoCode('Source is not a file: %r' % filename)
	return subsequent_lines_with_more_indentation(filename, function_code.co_firstlineno)


def higlight_code(text):
	try:
		from pygments.lexers import get_lexer_by_name
		from pygments.formatters import get_formatter_by_name
	except ImportError:
		return text
	language = 'python'
	lexer = get_lexer_by_name(language)
	if not lexer:
		return text
	formatter = get_formatter_by_name('terminal256', style='alan')
	if not formatter:
		return text
	import pygments
	return pygments.highlight(text, lexer, formatter)


def highlight_method(method):
	text = code_of_method(method)
	return higlight_code(text)


def code_of_module(module):
	filename = re.sub('.py[co]$', '.py', module.__file__)
	return file(filename).read()


def highlight_module(module):
	text = code_of_module(module)
	return higlight_code(text)


def highlight(instance):
	if hasattr(instance, '__file__'):
		return highlight_module(instance)
	return highlight_method(instance)


def code(instance):
	if hasattr(instance, '__file__'):
		return code_of_module(instance)
	return code_of_method(instance)


def see_code(instance):
	print code(instance)


def see_highlight(instance):
	print highlight(instance)
