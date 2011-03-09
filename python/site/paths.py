from path import makepath,path

def environ_paths():
	import environ
	result = {}
	for key,value in environ.jab.iteritems():
		if key in result: raise KeyError('%s:%s -> %s' % (key,result[key],value))
		paths = [ p for p in string_to_paths(value) if p.exists() ]
		if paths:
			if paths[1:] or key.endswith('PATH'):
				result[key] = paths
			else:
				result[key] = paths[0]
	class paths: pass
	paths = paths()
	paths.__dict__.update(result)
	return paths

def string_to_paths(string):
	for c in ':, ;':
		if c in string:
			return strings_to_paths( string.split(c) )
	return [ makepath(string) ]

def strings_to_paths(strings):
	return [ makepath(s) for s in strings ]

def split_directories(strings):
	strings = strings_to_paths(strings)
	return [ p for p in strings if p.isdir() ], [ p for p in strings if not p.isdir() ]

def split_files(strings):
	strings = strings_to_paths(strings)
	return [ p for p in strings if p.isfile() ], [ p for p in strings if not p.isfile() ]

def split_directories_files(strings):
	strings = strings_to_paths(strings)
	return [ p for p in strings if p.isdir() ], [ p for p in strings if p.isfile() ], [ p for p in strings if not (p.isfile() or p.isdir())]

def files(strings):
	return split_files(strings)[0]

def directories(strings):
	return split_directories(strings)[0]

def from_home(p):
	return home.relpathto(p)

environ = environ_paths()

here = path('.')
home = path('~').expanduser()
