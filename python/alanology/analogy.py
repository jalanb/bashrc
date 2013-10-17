import twine
import tally
import lists

def module_grammar(module):
	"""Find a file named same as this module, except with extension j

	Such files should contain analogy-grammars
	"""
	return file(module.__file__.replace('.pyc', '.j').replace('.py', '.j')).read()


def string_to_list(string_of_characters):
	"""Convert a Python string to a Tally of twisted characters"""
	lyst = tally.tlist('string')([twisted(c) for c in string_of_characters])
	return lyst


def lysted(lyst):
	return pluralled(classed(lyst))


def pluralled(lyst):
	result = []
	for items in lyst:
		item = items[0]
		name = item.list_name()
		result.append(tally.tlist(name)(items))
	return result


def classed(lyst):
	def same_class(a, b):
		return a.class_name() == b.class_name()
	return lists.groups(same_class, [l for l in lyst])


def pairer(name, before, after):
	def take_every_two(lyst, take_two):
		i = iter(lyst)
		prev = i.next()
		try:
			while i:
				curr = i.next()
				prev, curr = take_two(prev, curr)
				yield prev
				if not curr:
					prev = curr
					curr = i.next()
				prev = curr
		finally:
			if prev:
				yield prev

	def named_pair(name, *outer_args):
		def take_two(*inner_args):
			if all(i.class_name() == o for i, o in zip(inner_args, outer_args)):
				return tally.tlist(name)(inner_args[0]), None
			return inner_args
		return take_two

	method = named_pair(name, before, after)
	def reduce_by_pairs(lyst):
		new_list = take_every_two(lyst, method)
		return [l for l in new_list]

	return reduce_by_pairs

worded = pairer('word', 'lowers', 'spaces')
sentenced = pairer('sentence', 'words', 'eols')


def twisted(c):
	if c.isupper():
		name = 'upper'
	elif c.islower():
		name = 'lower'
	elif c.isdigit():
		name = {
			'0' : 'zero',
			'1' : 'one',
			'2' : 'two',
			'3' : 'three',
			'4' : 'four',
			'5' : 'five',
			'6' : 'six',
			'7' : 'seven',
			'8' : 'eight',
			'9' : 'nine',
		}[c]
		name = 'digit'
	else:
		names = {
			' ' : 'space',
			'\t' : 'tab',
			'\n' : 'eol',
			'>' : 'greater than',
			'(' : 'open bracket',
			'.' : 'dot',
			'_' : 'underscore',
			"'" : 'single quote',
			')' : 'close bracket',
			'=' : 'equals',
			':' : 'colon',
			'{' : 'open brace',
			',' : 'comma',
			'\\' : 'backslash',
			'"' : 'double quote',
			'}' : 'close brace',
			'[' : 'open brick',
			']' : 'close brick',
			'+' : 'plus',
			'/' : 'forward slash',
			'*' : 'asterisk',
			'-' : 'dash',
			';' : 'semi colon',
			'@' : 'at',
			'<' : 'less than',
			'!' : 'exclamation mark',
			'%' : 'per cent',
			'&' : 'ampersand',
			'|' : 'bar',
		}
		name = names[c]
	return twine.twist(name)(c)

