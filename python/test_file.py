from mymeta.jab import jab

def __repr__(self):
	return '<test_file %s>' % self

def __str__(self):
	return self.path_to_file

test_file_grammar = file('test_file.g').read()
test_file = jab.makeGrammar(test_file_grammar, globals(), name="test_file")

def parse(path_to_file):
	source = file(path_to_file).read()
	test_file.path_to_file = path_to_file
	test_file.__str__ = __str__
	test_file.__repr__ = __repr__
	test_file.sections = test_file(source).apply('test_file')
	test_file.examples = []
	for main in test_file.sections:
		test_file.examples.extend(main.examples)
		for sub in main.sections:
			test_file.examples.extend(sub.examples)
	return test_file

class Section:
	def __init__(self,section,sub_sections):
		self.title = section[0]
		self.examples = section[1]
		self.sections = [ Section(s,[]) for s in sub_sections ]

	def __str__(self):
		return '\n\t'.join( [self.title] + [ str(s) for s in self.sections ])

	def __repr__(self):
		return '<Section %s>' % self

class Example:
	def __init__(self,text,python_parts):
		self.text = '\n'.join(['\n\t'.join(t) for t in text])
		self.python = python_parts[0]
		self.expected = python_parts[1]

	def __str__(self):
		return '%s\n\t>.> %s' % ( self.text,'\n\t'.join(['\n\t... '.join(self.python)] + self.expected))

	def __repr__(self):
		result = '\n\t'.join( [ str(self) ] + self.expected )
		return '<Example %s>' % self
