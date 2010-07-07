import os
from mymeta.jab import jab

test_file_grammar = file('test_file.g').read()
test_file = jab.makeGrammar(test_file_grammar, globals(), name="test_file")

def parse(path_to_file):
	if not os.path.isfile(path_to_file):
		return None
	return TestFile(path_to_file)

class TestFile:
	def __init__(self,path_to_file):
		self.path_to_file = path_to_file
		self.source = file(path_to_file).read()
		self.sections = test_file(self.source).apply('test_file')
		self.examples = []
		for section in self.sections:
			self.examples.extend(section.examples)
			for sub in section.sections:
				self.examples.extend(sub.examples)

	def __repr__(self):
		return '<TestFile %r>' % self.path_to_file

	def __str__(self):
		return self.path_to_file

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
