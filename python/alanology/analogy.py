import twine
import tally
import lists

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

def string_to_list(string_of_characters):
	lyst = tally.tlist('string')([ twisted(c) for c in string_of_characters ])
	return lyst

def lysted(lyst):
	return pluralled(classed(lyst))

def classed(lyst):
	def same_class(a,b): return a.class_name() == b.class_name()
	return lists.groups(same_class,[l for l in lyst])

def pluralled(lyst):
	result = []
	for items in lyst:
		item = items[0]
		name = item.list_name()
		value = tally.enjoin(items)
		result += [ tally.tlist(name)(value) ]
	return result

def a_word(prev,curr):
	if curr.class_name() == 'spaces':
		if prev.class_name() == 'lowers':
			return tally.tlist('word')(str(prev)), None
	return prev,curr

def wordied(lyst):
	return [l for l in wordled(lyst)]

def wordled(lyst):
	i = iter(lyst)
	prev = i.next()
	while i:
		curr = i.next()
		prev, curr = a_word(prev,curr)
		yield prev
		if not curr:
			prev = curr
			curr = i.next()
		prev = curr

