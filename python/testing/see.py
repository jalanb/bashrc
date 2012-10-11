#!/usr/bin/env python

"""
see
A human alternative to dir().

	>>> from see import see
	>>> help(see)
	Help on function see in module see:
	<BLANKLINE>
	see(obj=anything, pattern=None, r=None, methods=None, attributes=None)
	    Inspect an object. Like the dir() builtin, but easier on the eyes.
	<BLANKLINE>
	    Keyword arguments (all optional):
	    obj -- object to be inspected
	    pattern -- shell-style search pattern (e.g. '*len*')
	    r -- regular expression
	<BLANKLINE>
	    If obj is omitted, objects in the current scope are listed instead.
	<BLANKLINE>
	    Some unique symbols are used:
	<BLANKLINE>
	        .*      implements obj.anything
	        []      implements obj[key]
	        in      implements membership tests (e.g. x in obj)
	        +obj    unary positive operator (e.g. +2)
	        -obj    unary negative operator (e.g. -2)
	<BLANKLINE>

Copyright (c) 2009 Liam Cooke
http://inky.github.com/see/

Licensed under the GNU General Public License v3. {{{
This program is free software: you can redistribute it and/or modify
it under the terms of the GNU General Public License as published by
the Free Software Foundation, either version 3 of the License, or
(at your option) any later version.

This program is distributed in the hope that it will be useful,
but WITHOUT ANY WARRANTY; without even the implied warranty of
MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
GNU General Public License for more details.

You should have received a copy of the GNU General Public License
along with this program.  If not, see <http://www.gnu.org/licenses/>.
}}}
"""

import re
import sys
import textwrap
import linecache
import fnmatch
import inspect

from pprint import pformat

__all__ = ['see'] #,'see_attributes', 'see_methods', 'code']

__author__ = 'Liam Cooke'
__contributors__ = [
	'Bob Farrell',
	'Gabriel Genellina',
	'Baishampayan Ghose',
	'Charlie Nolan',
	'Ed Page',
	'guff',
	'jdunck',
]
__version__ = '0.5.4'
__copyright__ = 'Copyright (c) 2009 Liam Cooke'
__license__ = 'GNU General Public License v3'


def regex_filter(names, pat):
	pat = re.compile(pat)

	def match(name, fn=pat.search):
	    return fn(name) is not None
	return tuple(filter(match, names))


def fn_filter(names, pat):

	def match(name, fn=fnmatch.fnmatch, pat=pat):
	    return fn(name, pat)
	return tuple(filter(match, names))


class _SeeOutput(tuple):
	"""Tuple-like object with a pretty string representation."""

	def __new__(self, actions=None):
	    return tuple.__new__(self, actions or [])

	def __repr__(self):
	    return textwrap.fill('    '.join(self), 78,
	                         initial_indent='    ',
	                         subsequent_indent='    ')


class _SeeDefault(object):
	def __repr__(self):
	    return 'anything'

_LOCALS = _SeeDefault()


def see(obj=_LOCALS, pattern=None, r=None, methods=None, attributes=None):
	"""
	Inspect an object. Like the dir() builtin, but easier on the eyes.

	Keyword arguments (all optional):
	obj -- object to be inspected
	pattern -- shell-style search pattern (e.g. '*len*')
	r -- regular expression

	If obj is omitted, objects in the current scope are listed instead.

	Some unique symbols are used:

	    .*      implements obj.anything
	    []      implements obj[key]
	    in      implements membership tests (e.g. x in obj)
	    +obj    unary positive operator (e.g. +2)
	    -obj    unary negative operator (e.g. -2)

	"""
	use_locals = obj is _LOCALS
	actions = []
	dot = not use_locals and '.' or ''
	func = lambda f: hasattr(f, '__call__') and '()' or ''
	name = lambda a, f: ''.join((dot, a, func(f)))
	if methods is None and attributes is None:
	    methods = attributes = True
	if use_locals:
	    obj.__dict__ = inspect.currentframe().f_back.f_locals
	attrs = dir(obj)
	if not use_locals:
	    for var, symbol in SYMBOLS:
	        if var not in attrs or symbol in actions:
	            continue
	        elif var == '__doc__':
	            if not obj.__doc__ or not obj.__doc__.strip():
	                continue
	        actions.append(symbol)

	def is_callable(p):
	    return hasattr(p,"__call__")

	for attr in filter(lambda a: not a.startswith('_'), attrs):
	    try:
	        prop = getattr(obj, attr)
	    except AttributeError:
	        continue
	    if not methods and is_callable(prop): continue
	    if not attributes and not is_callable(prop): continue
	    actions.append(name(attr, prop))

	if pattern is not None:
	    actions = fn_filter(actions, pattern)
	if r is not None:
	    actions = regex_filter(actions, r)

	return _SeeOutput(actions)

def see_methods(*args,**kwargs):
	kwargs['methods'] = True
	return see(*args,**kwargs)

def see_attributes(*args,**kwargs):
	kwargs['attributes'] = True
	return see(*args,**kwargs)

def spread(thing, exclude = None):
	'''Spread out the attributes of thing onto stdout

	exclude is a list of regular expressions
		attributes matching any if these will not be shown
		if the default of None is used it is set to [ '__.*__' ]
	'''
	ids = []
	if not exclude:
		exclude = [ '__.*__' ]
	exclusions = [ re.compile(e) for e in exclude ]

	def spread_out_an_attribute(v,separator):
		if not v:
			return repr(v)
		if id(v) in ids:
			return str(v)
		return spread_out_the_attributes(v,separator)

	def spread_out_the_attributes(thing,separator):
		if not thing or not hasattr(thing,'__dict__'):
			return pformat(thing)
		ids.append(id(thing))
		attributes_list = []
		for k,v in thing.__dict__.iteritems():
			if isinstance(v,type(sys)): continue
			if callable(v): continue
			excluded = False
			for exclusion in exclusions:
				if exclusion.search(k):
					excluded = True
					break
			if excluded: continue
			if hasattr(v,'__repr__'):
				value = v.__repr__()
			else:
				value = spread_out_an_attribute(v,separator)
			lines = separator.join(value.splitlines())
			attributes_list.append('%s : %s' % (k,lines))
		attributes_string = separator.join( attributes_list )
		ids.pop()
		if hasattr(thing,'__class__'):
			klass = thing.__class__
		else:
			klass = dir(thing)
		return '''<%s%s%s\n%s>''' % ( klass, separator, attributes_string, separator[1:-2])

	print spread_out_the_attributes(thing,'\n\t')

def indent(filename,line_number):
	line = linecache.getline(filename,line_number)
	match = re.match('(\s*)',line)
	if not match:
	    return None, None
	return line.rstrip(), match.groups()[0]

def code(method):
	if not callable(method):
	    print 'Not callable: %r' % method
	    return
	result = [ ]
	try: first_line_number = method.func_code.co_firstlineno
	except AttributeError:
	    print 'No code available for', method
	    return
	filename = method.func_code.co_filename
	if filename.endswith('.pyc') or filename.endswith('.pyo'):
	    filename = filename[:-1]
	line, first_indentation = indent(filename,first_line_number)
	result = [ line ]
	line_number = first_line_number + 1
	line, indentation = indent(filename,line_number)
	while indentation > first_indentation:
	    result.append( line )
	    line_number += 1
	    line, indentation = indent(filename,line_number)
	print '\n'.join(result)

PY_300 = sys.version_info >= (3, 0)
PY_301 = sys.version_info >= (3, 0, 1)

SYMBOLS = tuple(filter(lambda x: x[0], (
	# callable
	('__call__', '()'),

	# element/attribute access
	('__getattr__', '.*'),
	('__getitem__', '[]'),
	('__setitem__', '[]'),
	('__delitem__', '[]'),

	# iteration
	('__enter__', 'with'),
	('__exit__', 'with'),
	('__contains__', 'in'),

	# operators
	('__add__', '+'),
	('__radd__', '+'),
	('__iadd__', '+='),
	('__sub__', '-'),
	('__rsub__', '-'),
	('__isub__', '-='),
	('__mul__', '*'),
	('__rmul__', '*'),
	('__imul__', '*='),
	(not PY_300 and '__div__', '/'),
	(not PY_301 and '__rdiv__', '/'),
	('__truediv__', '/'),
	('__rtruediv__', '/'),
	('__floordiv__', '//'),
	('__rfloordiv__', '//'),
	(not PY_300 and '__idiv__', '/='),
	('__itruediv__', '/='),
	('__ifloordiv__', '//='),
	('__mod__', '%'),
	('__rmod__', '%'),
	('__divmod__', '%'),
	('__imod__', '%='),
	('__pow__', '**'),
	('__rpow__', '**'),
	('__ipow__', '**='),
	('__lshift__', '<<'),
	('__rlshift__', '<<'),
	('__ilshift__', '<<='),
	('__rshift__', '>>'),
	('__rrshift__', '>>'),
	('__irshift__', '>>='),
	('__and__', '&'),
	('__rand__', '&'),
	('__iand__', '&='),
	('__xor__', '^'),
	('__rxor__', '^'),
	('__ixor__', '^='),
	('__or__', '|'),
	('__ror__', '|'),
	('__ior__', '|='),
	('__pos__', '+obj'),
	('__neg__', '-obj'),
	('__invert__', '~'),
	('__lt__', '<'),
	(not PY_301 and '__cmp__', '<'),
	('__le__', '<='),
	(not PY_301 and '__cmp__', '<='),
	('__eq__', '=='),
	(not PY_301 and '__cmp__', '=='),
	('__ne__', '!='),
	(not PY_301 and '__cmp__', '!='),
	('__gt__', '>'),
	(not PY_301 and '__cmp__', '>'),
	('__ge__', '>='),
	(not PY_301 and '__cmp__', '>='),

	# built-in functions
	('__abs__', 'abs()'),
	(PY_300 and '__bool__' or '__nonzero__', 'bool()'),
	('__complex__', 'complex()'),
	(PY_300 and '__dir__', 'dir()'),
	('__divmod__', 'divmod()'),
	('__rdivmod__', 'divmod()'),
	('__float__', 'float()'),
	('__hash__', 'hash()'),
	('__doc__', 'help()'),
	(PY_300 and '__index__' or '__hex__', 'hex()'),
	('__int__', 'int()'),
	('__iter__', 'iter()'),
	('__len__', 'len()'),
	(not PY_300 and '__long__', 'long()'),
	(PY_300 and '__index__' or '__oct__', 'oct()'),
	('__repr__', 'repr()'),
	('__reversed__', 'reversed()'),
	(PY_300 and '__round__', 'round()'),
	('__str__', 'str()'),
	(PY_300 and '__unicode__', 'unicode()'),
)))


if __name__ == '__main__':
	help(see)

# vim: expandtab tabstop=4 shiftround shiftwidth=4 fdm=marker
