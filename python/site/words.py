'''
Some useful methods found (initially) at
	http://www.google.com/codesearch/p?hl=en#632pFyTt4Ec/Supybot-0.83.2/src/utils/str.py&q=pluralize%20lang:python
'''
import re
from itertools import ifilter

def matchCase(s1, s2):
	"""Matches the case of s1 in s2"""
	if s1.isupper():
		return s2.upper()
	else:
		L = list(s2)
		for (i, char) in enumerate(s1[:len(s2)]):
			if char.isupper():
				L[i] = L[i].upper()
		return ''.join(L)


def any_true(function, iterable):
	"""Returns true if any element in iterable satisfies the function."""
	for _ in ifilter(function, iterable):
		return True
	else:
		return False

consonants = 'bcdfghjklmnpqrstvwxz'
ends_in_consonant_y = re.compile('[%s]y$' % consonants)
exceptional_plurals = {
	'fish' : 'fish'
}

def pluralize(s):
	"""Returns the plural of s.  Put any exceptions to the general English
	rule of appending 's' in the exceptional_plurals dictionary.
	"""
	lowered = s.lower()
	result = s + 's'
	if lowered in exceptional_plurals:
		result = exceptional_plurals[lowered]
	elif lowered.endswith('ex'):
		return lowered[:-2] + 'ices'
	elif any_true(lowered.endswith, ['x', 'ch', 'sh', 'ss']):
		result = s+'es'
	elif ends_in_consonant_y.search(lowered):
		result = s[:-1] + 'ies'
	return matchCase(s, result)

ends_in_consonant_ies = re.compile('[%s]ies' % consonants)
exceptional_singlulars = {}
for k,v in exceptional_plurals.iteritems(): exceptional_singlulars[v] = k

def depluralize(s):
	"""Returns the singular of s."""
	lowered = s.lower()
	if lowered in exceptional_plurals:
		return matchCase(s, exceptional_plurals[lowered])
	elif any_true(lowered.endswith, ['ches', 'shes', 'sses']):
		return s[:-2]
	elif re.search(ends_in_consonant_ies, lowered):
		return s[:-3] + 'y'
	else:
		if lowered.endswith('s'):
			return s[:-1] # Chop off 's'.
		else:
			return s # Don't know what to do.


