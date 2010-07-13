import os
from mymeta.jab import jab
import files

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

	def update(self,fail_file):
		def next_failure(failures):
			try:
				failure = failures.next()
				assert self.path_to_file == failure.path_to_test
				return failure
			except StopIteration:
				return None

		failures = iter(fail_file.failures)
		failure = next_failure(failures)
		for example in self.examples:
			if example.update(failure):
				failure = next_failure(failures)

	def write(self,stream=None):
		if not stream:
			files.backup_with_suffix(self.path_to_file,'~')
			stream = file(self.path_to_file,'w')
		self.sections[0].write(stream,'=')
		for section in self.sections[1:]:
			section.write(stream,None)

	def accept(self):
		for example in self.examples:
			example.accept()

	def passed(self):
		for example in self.examples:
			if not example.passed():
				return False
		return True
	
class Section:
	def __init__(self,section,sub_sections):
		self.title = section[0]
		self.examples = section[1]
		self.sections = [ Section(s,[]) for s in sub_sections ]

	def __str__(self):
		return '\n\t'.join( [self.title] + [ str(s) for s in self.sections ])

	def __repr__(self):
		return '<Section %s>' % self

	def write(self,stream,underliner=None):
		print >> stream, self.title
		if not underliner:
			if self.sections:
				underliner = '='
			else:
				underliner = '-'
		print >> stream, underliner * len(self.title)
		for example in self.examples:
			example.write(stream)
		for section in self.sections:
			section.write(stream)

class Example:
	def __init__(self, text, python_parts, line_number):
		self.text = '\n'.join(['\n\t'.join(t) for t in text])
		self.python = [ l.rstrip() for l in python_parts[0] ]
		self.expected = [ l.rstrip() for l in python_parts[1] ]
		self.line_number = line_number

	def __str__(self):
		return '%s\n\t>>> %s' % ( self.text,'\n\t'.join(['\n\t... '.join(self.python)] + self.expected))

	def __repr__(self):
		return '<Example %r>' % '\n'.join(self.python)

	def accept(self):
		self.expected = self.actual
		
	def update(self,failure):
		if not failure or self.line_number != failure.test_line_number:
			self.actual = self.expected
			return False
		self.actual = failure.actual
		return True

	def write(self,stream):
		if self.text:
			print >> stream, self.text
		print >> stream, '\t>>>',
		print >> stream, '\n\t... '.join(self.python)
		if self.expected:
			print >> stream, '\t',
			print >> stream, '\n\t'.join(self.expected)

	def passed(self):
		try:
			return self.expected == self.actual
		except AttributeError:
			return False
