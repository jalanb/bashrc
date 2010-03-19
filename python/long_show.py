def long_show(fred,indentation=None):
	if not indentation:
		indentation = ''
	if issubclass(type(fred), list) or issubclass(type(fred), tuple):
		if issubclass(type(fred), list):
			start, end = '[', ']'
		if issubclass(type(fred), tuple):
			start, end = '(', ')'
		sys.stdout.write( '%s%s\n' % (indentation,start) )
		for item in fred:
			long_show(item,'%s\t' % indentation)
			sys.stdout.write( ',\n' )
		sys.stdout.write( '%s%s' % (indentation,end) )
	elif issubclass(type(fred), dict):
		start, end = '{', '}'
		sys.stdout.write( '%s%s\n' % (indentation,start) )
		for key,value in fred.iteritems():
			long_show(key,'%s\t' % indentation)
			sys.stdout.write( ': ' )
			long_show(value,'%s\t' % indentation)
			sys.stdout.write( ',\n' )
		sys.stdout.write( '%s%s' % (indentation,end) )
	else:
		sys.stdout.write( '%s%s' % (indentation,fred) )

