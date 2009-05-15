#! /usr/bin/env python

'''
ptags

Adapted from ptags.py in the python distribution

Create a tags file for Python programs, usable with vi.
Tagged are:
	functions (even inside other defs or classes)
	classes
	filenames
	Warns about files it cannot open.
	No warnings about duplicate tags.
--
I am targeting vim, so
	the tags file format to use is specified here:
	http://ctags.sourceforge.net/ctags.html#TAG%20FILE%20FORMAT
'''

import sys, re, os

from path import makepath, here

class Tag:
	def_or_class = re.compile('''
		(?P<address>
			(
				^[ \t]*
				(?P<type>def|class)
				[ \t]+
				(?P<name>[_a-zA-Z]([a-zA-Z0-9][a-zA-Z0-9_]*))
				[ \t]*
				[:\(]
			) |
			1
		)
	''',re.VERBOSE)
	def __init__(self,path,line):
		s = line.rstrip()
		self.__dict__.update(self.def_or_class.match(s).groupdict())
		self.path = path
		self.address = '/^%s/' % self.address
		
	def __str__(self):
		return '\t'.join([self.name,self.path,self.address])

	def __repr__(self):
		return '<Tag "%s">' % self

	def __cmp__(self,other):
		return cmp(str(self),str(other))
		

class FileTag(Tag):
	def __init__(self,path):
		try:
			self.name = path.namebase
		except AttributeError:
			path = makepath(path)
		Tag.__init__(self,path,'1')
		self.name = path.namebase
		self.address = '1'

	def __repr__(self):
		return '<FileTag "%s">' % self
		
def best_of(old,new):
	if old.path == new.path:
		if isinstance(old,FileTag):
			return new
		if str(old) == str(new):
			return new
	raise NotImplementedError('\n\t%r\n\t%r' % ( old, new ))
	
def tag_file(path_to_python):
	tags = []	# ex Modified global variable!
	t = FileTag(path_to_python)
	tags.append(t)
	def_or_class = re.compile('^[ \t]*(def|class)[ \t]+([a-zA-Z0-9_]+)[ \t]*[:\(]')
	for line in t.path.lines():
		try:
			tag = Tag(t.path,line)
			for t in tags:
				if t.name == tag.name:
					tag = best_of( t, tag )
					break
			else:
				tags += [ tag ]
				continue
			tags.remove(t)
			tags += [ tag ]
		except AttributeError: pass
		continue
		m = def_or_class.match(line)
		if m:
			address = m.group(0)
			name = m.group(2)
			s = '%s\t%s\t/^%s/\n' % ( name , path_to_python , address )
			tags.append(s)
	return tags

def tag_dir(p):
	tags = []
	for py in p.files('*.py'):
		for tag in tag_file(py):
			tags += [ tag ]
	for d in p.dirs():
		tags += tag_dir(d)
	return tags

def write_dir(p,tags):
	for d in p.dirs(): write_dir(d,tags)
	out = makepath('%s/tags' % p)
	out.write_lines( sorted([str(t) for t in tags]) )

def main():
	p = here()
	tags = tag_dir(p)
	tags.sort()
	write_dir(p,tags)
	print 'Wrote tags to ', p

if __name__ == '__main__':
	try:
		print sys.argv[1]
		print 'Usage:', sys.argv[0]
	except:
		sys.exit(main())
