from path import path

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
		paths = [ path(v) for v in value.split(':') if path(v).exists() ]
		if paths:
			if paths[1:]:
				result[key] = paths
			else:
				result[key] = paths[0]
		elif '/' in value:
			result[key] = value
	return result
	raise str(result['MONTYLINGUA'])
	if key == 'MONTYLINGUA': raise str(result[key])

globals().update(environ_paths())

here = path('.')
home = path('~').expanduser()

