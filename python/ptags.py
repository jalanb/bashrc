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

import sys
import re
import os

import sis
import argv
argv.add_options([
	( 'verbose', 'Report disk changes', False ),
	( 'recursive', 'Recurse into sub-directories', False )
])

from paths import makepath, pwd

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
		self.address = re.sub('[ \t]+',' +','/^%s/' % self.address)
		if not self.name: self.name = ''
		
	def __str__(self):
		return '\t'.join([self.name,self.path,self.address])

	def __repr__(self):
		return '<Tag "%s">' % self.name

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
		return '<FileTag "%s">' % self.name
		
def best_of(old,new):
	if old.path == new.path:
		if isinstance(old,FileTag):
			return None, new
		if old.address == new.address:
			return None, new
		old_pattern = old.address[2:-1]
		new_pattern = new.address[2:-1]
		if new_pattern[0:2] == ' +' and new_pattern[2:] == old_pattern:
			new.name = '.%s' % new.name
			return old, new
		elif old_pattern[0:2] == ' +' and old_pattern[2:] == new_pattern:
			old.name = '.%s' % old.name
			return old, new
		elif ('+class' in new.address and '+def' in old.address) or ('+class' in old.address and '+def' in new.address):
			return old, new
		else:
			raise ValueError('%s\n%s\n\t"%s" != "%s"' % (old.where(), new.where(), old.address , new.address))
	raise NotImplementedError('\n\t%r\n\t%r' % ( old.path, new.path ))
	
def read_file(path_to_python):
	tags = []	# ex Modified global variable!
	t = FileTag(path_to_python)
	tags.append(t)
	def_or_class = re.compile('^[ \t]*(def|class)[ \t]+([a-zA-Z0-9_]+)[ \t]*[:\(]')
	problems = []
	for line in t.path.lines():
		if not line: continue
		try:
			tag = Tag(t.path,line)
			for t in tags:
				if t.name == tag.name:
					try: want_t, tag = best_of( t, tag )
					except ValueError,e: problems += [ str(e) ]
					break
			else:
				tags += [ tag ]
				continue
			if not want_t:
				tags.remove(t)
			tags += [ tag ]
		except AttributeError: pass
	if problems:
		raise ValueError('\n'.join(problems))
	return tags

def read_dir(path_to_directory=None):
	if not path_to_directory: path_to_directory = pwd()
	tags = []
	for py in path_to_directory.files('*.py'):
		for tag in read_file(py):
			tags += [ tag ]
	return tags

def read_dirs(path_to_directory=None):
	if not path_to_directory: path_to_directory = pwd()
	tags = read_dir(path_to_directory)
	for p in path_to_directory.all_dirs():
		tags += read_dir(p)
	return tags

def tags_to_text(tags):
	str_tags = [ str(t) for t in tags ]
	sorted_tags = sorted(str_tags)
	return '\n'.join(sorted_tags)

def write_dir(path_to_directory,tags):
	out = makepath('%s/tags' % path_to_directory)
	if out.isdir():
		message = 'Wrote no tags to %s' % out
	else:
		text = tags_to_text(tags)
		out.write_text(text)
		message = 'Wrote tags to %s' % out
	if argv.options.verbose:
		print message

def read_write_dir(path_to_directory=None):
	if not path_to_directory: path_to_directory = pwd()
	tags = read_dir(path_to_directory)
	write_dir(path_to_directory,tags)

def read_write_dirs(path_to_directory=None):
	if not path_to_directory: path_to_directory = pwd()
	for p in path_to_directory.all_dirs():
		tags = read_dirs(p)
		write_dir(p,tags)

def read_sys_dirs():
	tags = []
	for p in sis.paths:
		tags += read_dir(p)
	return tags

def all_directories_in_a_list_of_tags(tags):
	return sorted(list(set([t.path.parent.from_home() for t in tags])))

def main():
	argv.parse_args()
	if argv.options.recursive:
		read_write_dirs()
	else:
		read_write_dir()

if __name__ == '__main__':
	argv.main(main, ctrl_c=True)
