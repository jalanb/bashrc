import os
import sys
import path
import options


try: any([])
except NameError:
	def any(x):
		return len(x) > 0

from l import get_dirs, get_files, screen_width, show_dirs, remove_ignored

my_options = [
	( 'python', 'show python scripts', True),
	( 'tests', 'show tests', False),
	( 'compiled', 'show compiled python', False),
	( 'grammar', 'show grammars', False),
	( 'fails', 'show fails', False),
	( 'any', 'show others', False),
]
def wanted(path_to_file):
	ext = path_to_file.ext
	if options.options.any:
		return True
	rules = [
		[[ '.py' ], options.options.python ],
		[[ '.test', '.tests' ], options.options.tests ],
		[[ '.pyc', '.pyo' ], options.options.compiled ],
		[[ '.g' ], options.options.grammar ],
		[[ '.fail' ], options.options.fails ],
	]
	for exts, option in rules:
		if ext in exts:
			return option

def get_stems(files):
	stems = {}
	for f in files:
		stem = f.namebase
		got = stems.get(stem,[])
		got.append(f)
		try: stems[stem] = got
		except Exception, e: raise ', '.join([ str(got), str(stems), stem, f ])
	return stems
		
def filter_stems(stems):
	remove = []
	for stem,files in stems.iteritems():
		keeps = [f for f in files if wanted(f)]
		if not any(keeps):
			remove += [ stem ]
		else:
			stems[stem] = keeps
	for key in remove:
		del stems[key]

def pad(out, bands = 4):
	chars_per_band = screen_width / bands
	out_chars = len(out)
	out_bands = ( out_chars / chars_per_band ) + 1
	out_size = out_bands * chars_per_band
	assert out_size >= out_chars, '%d < %d' % ( out_size, out_chars )
	extra = out_size - out_chars
	return ''.join([out,' ' * extra])

def sort_by_name(x):
	return sorted(x)

def format(stems):
	names_and_extensions = []
	for name, files in stems.iteritems():
		ordered_exts = [ 'py', 'test', 'tests', 'fail', 'pyc', 'pyo ' ]
		f_exts = [ f.ext[1:] for f in files ]
		exts = [ e for e in ordered_exts if e in f_exts ] + [ e for e in f_exts if e not in ordered_exts ]
		names_and_extensions += [ '%s.%s' % (name,' '.join(exts)) ]
	return sort_by_name(names_and_extensions)

def show_line(outs,columns_per_line):
	columns_this_line, remainder = outs[:columns_per_line], outs[columns_per_line:]
	print ' '.join(columns_this_line)
	if remainder:
		show_line(remainder,columns_per_line)
		
def show(outs):
	try: column_width = max( [ len(o) for o in outs ] )
	except ValueError: return
	columns_per_line = screen_width / column_width
	padded = [ '%-*s' % ( column_width, o ) for o in outs ]
	show_line(padded,columns_per_line)

def main():
	options.run(my_options)
	dirs = get_dirs(options.args)
	show_dirs(dirs)
	files = get_files(dirs)
	show_ignored = False
	if not show_ignored:
		files = remove_ignored(files)
	stems = get_stems(files)
	if not stems: return 0
	filter_stems(stems)
	outs = format(stems)
	show(outs)
	print
	print
	return 0

if __name__ == '__main__':
	sys.exit(main())

