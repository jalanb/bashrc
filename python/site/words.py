"""
Some useful methods found (initially) at
	http://www.google.com/codesearch/p?hl=en#632pFyTt4Ec/Supybot-0.83.2/src/utils/str.py&q=pluralize%20lang:python
"""


import re
from itertools import ifilter


def matchCase(s1, s2):
	"""Matches the case of s1 in s2

	>>> matchCase('MATCHcase', 'somestuff')
	'SOMEStuff'
	"""
	if s1.isupper():
		return s2.upper()
	else:
		L = list(s2)
		for (i, char) in enumerate(s1[:len(s2)]):
			if char.isupper():
				L[i] = L[i].upper()
			elif char.islower():
				L[i] = L[i].lower()
		return ''.join(L)


def any_true(function, iterable):
	"""Returns true if any element in iterable satisfies the function."""
	for _ in ifilter(function, iterable):
		return True
	else:
		return False


consonants = 'bcdfghjklmnpqrstvwxz'
ends_in_consonant_y = re.compile('[%s]y$' % consonants)
uncountables = [
	'cowes',
	'deer',
	'equipment',
	'fish',
	'haiku',
	'information',
	'money',
	'rice',
	'series',
	'sheep',
	'species',
	'species',
]
exceptional_plurals = {
	'child': 'children',
	'fungus' : 'fungi',
	'louse': 'lice',
	'man' : 'men',
	'mouse': 'mice',
	'woman' : 'women',
}


def pluralize(s):
	"""Returns the plural of s.

	>>> pluralize('Index')
	'Indices'
	"""
	lowered = s.lower()
	result = s + 's'
	if lowered in exceptional_plurals:
		result = exceptional_plurals[lowered]
	elif lowered in uncountables:
		result = s
	elif lowered.endswith('ex'):
		result = lowered[:-2] + 'ices'
	elif any_true(lowered.endswith, ['x', 'ch', 'sh', 'ss', 'z']):
		result = s+'es'
	elif lowered.endswith('o'):
		eos = ['echo', 'hero', 'potato', 'veto', 'tomato']
		if lowered in eos:
			result = s + 'es'
		else:
			result = s + 's'
	elif ends_in_consonant_y.search(lowered):
		result = s[:-1] + 'ies'
	else:
		regexp, subs = re.compile(r'([^f])fe$', re.IGNORECASE), r'\1ves'
		if regexp.search(s):
			return regexp.sub(subs, s)
	return matchCase(s, result)


ends_in_consonant_ies = re.compile('[%s]ies' % consonants)
exceptional_singlulars = {}
for k, v in exceptional_plurals.iteritems(): exceptional_singlulars[v] = k


def depluralize(s):
	"""Returns the singular of s.

	>>> depluralize('Cows')
	'Cow'
	"""
	lowered = s.lower()
	if lowered in exceptional_plurals:
		return matchCase(s, exceptional_plurals[lowered])
	if lowered in uncountables:
		return s
	if any_true(lowered.endswith, ['ches', 'shes', 'sses']):
		return s[:-2]
	if re.search(ends_in_consonant_ies, lowered):
		return s[:-3] + 'y'
	if lowered.endswith('s'):
		return s[:-1]  # Chop off 's'.
	raise NotImplementedError("Don't know how to depluralize %r" % s)


def number_name(i):
	try:
		i = int(i)
	except ValueError:
		return str(i)
	number_names = {
		0: 'zero',
		1: 'one',
		2: 'two',
		3: 'three',
		4: 'four',
		5: 'five',
		6: 'six',
		7: 'seven',
		8: 'eight',
		9: 'nine'
	}
	return number_names.get(i, str(i))
