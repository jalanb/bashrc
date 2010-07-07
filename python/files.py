import commands

def backup_with_suffix(filename,suffix):
	text = file(filename).read()
	file('%s%s' % (filename,suffix),'w').write(text)

def looks_like_this(filename, limits = None, numbers=True, space=' ', tab='	', sol=None, eol=None):
	if not limits:
		start = 0
	else:
		start = limits[0]
	lines = file(filename).readlines()
	if not limits:
		end = len(lines)
	else:
		end = limits[1]
	for i, line in enumerate( file(filename).readlines() ):
		if i >= start:
			if space: line = line.replace(' ',space)
			if tab: line = line.replace('	',tab)
			if sol: line = '%s%s' % (sol,line)
			if numbers: line = '%2d: %s' % (i,line)
			if eol:
				print line.replace('\n',eol)
			else:
				print line,
		if i >= end:
			break

def write_failing_test(earlier_name):
	earlier_text = '''Test Me
=======
	>>> print 1
	>>> print 2
	3
	>>> print 1 / 0
	>>> print 0
'''
	earlier_file = file(earlier_name,'w')
	earlier_file.write(earlier_text)
	earlier_file.close()

def test_file(test_file):
	fail_file = test_file.replace('.tests','.fail').replace('.test','.fail')
	test_command = 'python -c"import doctest; doctest.testfile(\'%s\')" > %s' % ( test_file, fail_file )
	status, output = commands.getstatusoutput(test_command)
	return status == 0
