import os

def save_source(source,modname):
	main_python = os.environ['MAIN_PYTHON']
	mymeta_directory = '/Users/jab/python/site/mymeta'
	destination = os.path.join(mymeta_directory,'generated','%s.py' % modname)
	file(destination,'w').write(source)

