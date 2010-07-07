import files

import test_file
import fail_file

from pprint import pprint

def parse_files(stem):
	test = '%s.test' % stem
	tests = '%s.tests' % stem
	fail = '%s.fail' % stem
	return test_file.parse(test), test_file.parse(tests), fail_file.read_fail_file(fail)

def fix_failure(test_file, failure, suffix):
	if not failure.exists(): return 0
	assert test_file.path_to_file == failure.path_to_test
	lines = file(failure.path_to_test).readlines()
	actual_lines = lines[:failure.line]
	actual_lines += [ str('\t%s\n' % a) for a in failure.actual ]
	actual_lines += lines[failure.line + len(failure.expected):]
	if suffix: files.backup_with_suffix(test_file.path_to_file,suffix)
	file(test_file.path_to_file,'w').write(''.join(actual_lines))
	return len(failure.actual) - len(failure.expected)

def fix_file(test_file,fail_file,suffix='~'):
	if suffix:
		files.backup_with_suffix(test_file.path_to_file,suffix)
	extra = 0
	for failure in fail_file.failures:
		failure.line += extra
		fixed = fix_failure(test_file, failure, suffix=suffix)
		extra += fixed

