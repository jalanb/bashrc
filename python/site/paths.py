from path import makepath,path

home = path('~').expanduser()
here = path('.')

def mp3_files(self):
	return self.files('*.mp3')

path.mp3_files = mp3_files

def environ_paths():
	import environ
	result = {}
	for key,value in environ.jab.iteritems():
		if key in result: raise KeyError('%s:%s -> %s' % (key,result[key],value))
		paths = [ makepath(v) for v in value.split(':') ]
		paths = [ p for p in paths if p.exists() ]
		if paths:
			if paths[1:]:
				result[key] = paths
			else:
				result[key] = paths[0]
	class paths: pass
	paths = paths()
	paths.__dict__.update(result)
	return paths
	raise str(result['MONTYLINGUA'])
	if key == 'MONTYLINGUA': raise str(result[key])

def strings_to_paths(strings):
	if type(strings) == type(''):
		strings = strings.split(' ')
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

environ = environ_paths()

here = path('.')
home = path('~').expanduser()

def from_home(p):
	return home.relpathto(p)
