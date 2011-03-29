import os

def read_environ_keys():
	from path import path
	jab = path('~/.jab').expanduser()
	keys = []
	for environ_file in jab.files('*environ*'):
		lines = [ l.strip() for l in environ_file.lines() ]
		lines = [ l for l in lines if l and l[0] != '#' ]
		lines = [ l for l in lines if 'export' in l and '=' in l ]
		while_i_was_debugging ='\n'.join([l for l in lines if l.count('=') > 1])
		lines = [ l.replace('export','') for l in lines ]
		lines = [ l.strip() for l in lines ]
		lines = [ l.split('=',1) for l in lines ]
		lines = [ (key,value.strip('"').strip("'")) for key,value in lines ]
		lines = [ (key,value) for key,value in lines if '033' not in value]
		for key,value in lines:
			if key not in keys:
				keys.append(key)
	return sorted(keys)

def read_bash(keys):
	result = {}
	for key in keys:
		try: result[key] = os.environ[key]
		except KeyError: pass
	return result

jab = {}
jab.update(read_bash(read_environ_keys()))
globals().update(os.environ)
del os
