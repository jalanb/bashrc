import os
import sys
import path
import options


try: any([])
except NameError:
	def any(x): return [a for a in x if a]

from l import get_dirs, get_files, screen_width, show_dirs, remove_ignored

my_options = [
	( 'ython', 'hide python scripts', False),
	( 'tests', 'show tests', False),
	( 'compiled', 'show compiled python', False),
	( 'grammar', 'show grammars', False),
	( 'fails', 'show fails', False),
	( 'all', 'show all python related files', False),
	( 'others', 'show non python related files as well', False),
]

def post_parse(options,args):
	anything = False
	wanted = {
		'tests' : ['.test','.tests'],
		'compiled' : [ '.pyc', '.pyo' ],
		'grammar' : ['.g', '.j'],
		'fails' : ['.fail'],
	}
	options.exts = ['.py',]
	options.wanted = ['.py',]
	for k,v in options.__dict__.iteritems():
		try:
			if v: options.wanted += wanted[k]
			options.exts += wanted[k]
		except KeyError: pass
	return options, args
	
def wanted(path_to_file):
	ext = path_to_file.ext
	oo = options.options
	if ext == '.py': return not oo.ython
	if oo.others: return True
	if oo.all: return ext in oo.exts
	return ext in oo.wanted

def get_stems(files):
	stems = {}
	for f in files:
		stem = f.namebase
		got = stems.get(stem,[])
		got.append(f)
		try: stems[stem] = got
		except Exception, e: raise ', '.join([ str(got), str(stems), stem, f ])
	return stems
		
def check_exts(things):
	oo = options.options
	try: exts = [ f.ext for f in things ]
	except AttributeError:
		if ',' in things:
			exts = things.split(',')
			if exts[0].endswith('.py'):
				exts[0] = '.py'
		else:
			exts = things
	python_present = '.py' in exts or 'py' in exts
	python_missing = '.py' not in exts and 'py' not in exts
	hide_python = oo.ython
	show_python = not oo.ython
	if hide_python:
		assert not python_present, str(exts)
	if python_present:
		assert not hide_python, str(exts)

def filter_stems(stems):
	oo = options.options
	remove = []
	for stem,files in stems.iteritems():
		keeps = [f for f in files if wanted(f)]
		if not any(keeps):
			remove += [ stem ]
		else:
			stems[stem] = keeps
			exts = [ k.ext for k in keeps ]
			check_exts(exts)
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
		ordered_exts = [ 'py', 'j', 'g', 'test', 'tests', 'fail', 'pyc', 'pyo' ]
		oo = options.options
		missing = [ e for e in oo.exts if e[1:] not in ordered_exts ]
		assert not missing
		f_exts = [ f.ext[1:] for f in files ]
		check_exts(f_exts)
		exts = [ e for e in ordered_exts if e in f_exts ] + [ e for e in f_exts if e not in ordered_exts ]
		check_exts(f_exts)
		name_and_extensions = '%s.%s' % (name,','.join(exts))
		check_exts(name_and_extensions)
		names_and_extensions += [ name_and_extensions ]
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
	options.run(my_options,post_parse)
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

