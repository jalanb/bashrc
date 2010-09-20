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

def try_to_pass_tests(test_file):
	fail_file = '%s.fail' % os.path.splitext(test_file)[0]
	test_command = 'python -c"import doctest; doctest.testfile(\'%s\')" > %s' % ( test_file, fail_file )
	status, output = commands.getstatusoutput(test_command)
	lines = file(fail_file).readlines()
	if not lines:
		return True
	return 'failure' not in lines[-1]
