'''y not?'''

import os
import argv
import paths

argv.add_options([
	('delete', 'delete python compiled files as well', False),
	('wipe', 'remove known garbage',False),
	('stat', 'run svn stat', False),
	('ptags', 'do not refresh the tags file', True),
	('verbose', 'run ptags verbosely', False),
])

from ls import ly
from repositories import svn

def remove_globs(globs):
	for glob in globs:
		#print glob, [ f for f in argv.first_directory.files(glob) ]
		for p in argv.first_directory.listdir(glob):
			if p.islink():
				p.unlink()
			elif p.isfile():
				p.remove()
			elif p.isdir():
				p.rmdir()
			else:
				raise ValueError( 'Do not know how to remove %s' % p )

def wipe():
	remove_globs([ '*~', '.*~', '*.orig', 'fred*', 'mary', '*.tmp', '*.bak', 'one', 'two' ])
	[ f.rm() for f in argv.first_directory.files('*.fail') if not f.size ]

def delete():
	remove_globs([ '*.pyc', '*.pyo' ] )


def ptags():
	import ptags
	ptags.read_write_dir(argv.first_directory)

def main():
	if argv.first_directory != os.getcwd():
		print 'cd', argv.first_directory
		argv.first_directory.cd()
	for method in argv.methods:
		method()
	ly.show()
	if argv.options.stat:
		svn.show_stat()

if __name__ == '__main__':
	ly.prepare_argv()
	argv.main(main)
