import os
import sys
import path
import argv
import l
import lout


try: any([])
except NameError:
	def any(x): return [a for a in x if a]


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

argv.post_parses.append(post_parse)

argv.add_options([
		( 'ython', 'hide python scripts', False),
		( 'tests', 'show tests', False),
		( 'compiled', 'show compiled python', False),
		( 'grammar', 'show grammars', False),
		( 'fails', 'show fails', False),
		( 'all', 'show all python related files', False),
		( 'others', 'show non python related files as well', False),
])


def python_wanted(path_to_file):
	ext = path_to_file.ext
	oo = argv.options
	if ext == '.py': return not oo.ython
	if oo.others: return True
	if oo.all: return ext in oo.exts
	return ext in oo.wanted

def filter_names(names,wanted=None):
	if not wanted: wanted = python_wanted
	remove = []
	for name,files in names.iteritems():
		wanted_files = [f for f in files if wanted(f)]
		if not any(wanted_files):
			remove += [ name ]
		else:
			names[name] = wanted_files
			exts = [ f.ext for f in wanted_files ]
#			ly_rules(exts)
	for key in remove:
		del names[key]

def ly_rules(things):
	oo = argv.options
	try:
		exts = [ f.ext for f in things ]
	except AttributeError:
		if ',' in things:
			exts = things.split(',')
			if exts[0].endswith('.py'):
				exts[0] = '.py'
		else:
			if type(things) == type(''):
				things = [ things ]
			exts = [ path.path(f).ext for f in things ]
	python_present = '.py' in exts or 'py' in exts
	python_missing = '.py' not in exts and 'py' not in exts
	hide_python = oo.ython
	show_python = not oo.ython
	if hide_python:
		assert not python_present, str(exts)
	if python_present:
		assert not hide_python, str(exts)

lout.lout_rules = ly_rules

def show():
	try: dirs = l.get_dirs(argv.args)
	except ValueError, e:
		print e
		return
	lout.show_dirs(dirs)
	files = l.get_files(dirs)
	show_ignored = False
	if argv.options.ignore:
		files = l.remove_ignored(files)
	names = l.get_names(files)
	if not names: return 0
	filter_names(names)
	outs = lout.format(names)
	lout.show(outs)
	if not argv.options.quiet:
		print
		print
	return 0

def main():
	argv.parse_args()
	show()

if __name__ == '__main__':
	argv.main(main)

