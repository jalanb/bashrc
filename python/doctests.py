import os
import sys
import doctest
import commands

import test_file
import fail_file

from pprint import pprint

def parse_files(stem):
	test = '%s.test' % stem
	tests = '%s.tests' % stem
	fail = '%s.fail' % stem
	return test_file.parse(test), test_file.parse(tests), fail_file.read_fail_file(fail)

def write_failing_test(failing_name):
	earlier_text = '''Test Me
=======
	>>> print 1
	>>> print 2
	3
	>>> print 1 / 0
	>>> print 0
'''
	earlier_file = file(failing_name,'w')
	earlier_file.write(earlier_text)
	earlier_file.close()

class DocTestOutput:

	def __init__(self, fail_file):

		self.out = file(fail_file,'w')
		self.quietly = False

	def write(self, bytes):

		head = "*** DocTestRunner.merge:"
		tail = "' in both testers; summing outcomes."

		if bytes.startswith(head) and bytes.endswith(tail):
			self.quietly = True

		if not self.quietly:
			self.out.write(bytes)

		if 0 <= bytes.find('\n'):
			self.quietly = False

def try_to_pass_tests(test_file):
	fail_file = '%s.fail' % os.path.splitext(test_file)[0]
	test_command = 'python -c"import doctest; doctest.testfile(\'%s\')" > %s' % ( test_file, fail_file )
	status, output = commands.getstatusoutput(test_command)
	lines = file(fail_file).readlines()
	if not lines:
		return True
	return 'failure' not in lines[-1]

	try:
		safe_out = sys.stdout
		sys.stdout = DocTestOutput(fail_file)
		number_of_failures, number_of_tests = doctest.testfile(test_file)
		sys.stdout = safe_out
	finally:
		sys.stdout = safe_out
	return number_of_failures == 0
