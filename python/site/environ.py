import os

from paths import makepath

def read_environ_items():
	from path import path
	jab = path('~/.jab').expanduser()
	items = {}
	for environ_file in jab.files('*environ*'):
		lines = [ l.strip() for l in environ_file.lines() ]
		lines = [ l for l in lines if l and l[0] != '#' ]
		lines = [ l for l in lines if 'export' in l and '=' in l ]
		while_i_was_debugging ='\n'.join([l for l in lines if l.count('=') > 1])
		lines = [ l.replace('export', '') for l in lines ]
		lines = [ l.split('&&', 1)[-1] for l in lines ]
		lines = [ l.strip() for l in lines ]
		lines = [ l.split('=', 1) for l in lines ]
		lines = [ (key, value.strip('"').strip("'")) for key, value in lines ]
		lines = [ (key, value) for key, value in lines if '033' not in value]
		for key, value in lines:
			values = items.get(key, [])
			values.append(value)
			non_empty_values = [ value for value in values if value ]
			if non_empty_values:
				values = non_empty_values
			items[key] = values
	return sorted(items.items())

def read_environ_keys():
	return [ key for key, value in read_environ_items() ]

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

def environ_paths():
	result = {}
	for key, values in read_environ_items():
		value = values[-1]
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

def _files(strings):
	return split_files(strings)[0]

def directories(strings):
	return split_directories(strings)[0]

def from_home(p):
	return home.relpathto(p)

# environ = environ_paths()
