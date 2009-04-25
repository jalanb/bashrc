from twine import twist
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
	return twist(name)(c)

def can_join(a,b,rules):
	for rule in rules:
		x = rule(a,b)
		if x:
			return x
	return None

def fred(things):
	result = []
	prev = things[0]
	word, klass, lyst = prev.str_class_and_list()
	sequence = [ lyst, prev ]
	for thing in things[1:]:
		if klass == thing.class_name():
			word += str(thing)
			sequence += [ thing ]
		else:
			if len(word) > 1:
				result += [ sequence ]
			else:
				result += [ prev ]
			prev = thing
			word, klass, lyst = prev.str_class_and_list()
			sequence = [ lyst, prev ]
	return result
		
def integer(a,b):
	a = ''.join([str(c) for c in a])
	b = ''.join([str(c) for c in b])
	if a.isdigit() and b.isdigit():
		return twist('integer')(a + b)

def word(a,b):
	a = ''.join([str(c) for c in a])
	b = ''.join([str(c) for c in b])
	if a.lower().islower() and b.islower():
		return twist('word')(a + b)

def join_by_rules(lyst,rules):
	result = []
	prev, rest = lyst[0],lyst[1:]
	for next in rest:
		x = can_join(prev,next,rules)
		if x:
			prev = x
		else:
			result += [ prev ]
			prev = next
	result += [ prev ]
	return result

def list_of_characters(string_of_characters):
	return [ twisted(c) for c in string_of_characters ]

def plural(a,b):
	if a.class_name() == b.class_name():
		return twist(a.list_name())(a + b)
	if a.class_name() == b.list_name():
		return twist(b.list_name())(a + b)
	if b.class_name() == a.list_name():
		return twist(a.list_name())(a + b)


def list_of_rules(string_of_characters):
	characters = list_of_characters(string_of_characters)
	rules = [ plurals ]
	return join(characters,rules)


def string_to_list(string_of_characters):
	lyst = [ twisted(c) for c in string_of_characters ]
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
		value = ''.join(items)
		result += [ twist(name)(value) ]
	return result

def a_word(prev,curr):
	if curr.class_name() == 'spaces':
		if prev.class_name() == 'lowers':
			return twist('word')(str(prev)), None
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
