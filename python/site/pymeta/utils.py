import os

def save_source(source,modname):
	main_python = os.environ['PYTHON_HOME']
	pymeta_directory = os.path.dirname(__file__)
	generated_directory = os.path.join(pymeta_directory,'generated')
	if not os.path.isdir(generated_directory):
		os.makedirs(generated_directory)
	destination = os.path.join(generated_directory,'%s.py' % modname)
	file(destination,'w').write(source)

