def doublets(lyst):
	'''[prev,curr] for each element of the list'''
	if lyst is None: return lyst
	results = []
	one = None
	for two in lyst[0:]:
		results.append( [ one, two ] )
		one = two
	return results
		
def triplets(lyst):
	'''[prev,curr,next] for each element of the list'''
	if lyst is None: return lyst
	results = []
	one = None
	try: two = lyst[0]
	except IndexError: return []
	for three in lyst[1:]:
		results.append( [ one, two, three ] )
		one, two = two, three
	results.append( [ one, two, None ] )
	return results

def groups(match,lyst):
	'''Split the list into sub-lists based on the match method

	match takes two items and returns true if they are in the same group
	>>> def match(a,b): return a == b
	>>> groups(match,[0,0,0,1,1,0,1,1,'1'])
	[[0, 0, 0], [1, 1], [0], [1, 1], ['1']]
	'''
	if lyst is None: return lyst
	result = []
	try: group = [ lyst[0] ]
	except IndexError: return []
	for ytem in lyst[1:]:
		if match(ytem,group[-1]):
			group += [ ytem ]
		else:
			result += [ group ]
			group = [ ytem ]
	result += [ group ]
	return result

def before(x,i):
	'''Split a list into two lists: everything before i, and the rest
	
	>>> before('Fred',2)
	('Fr', 'ed')
	'''
	return  x[:i], x[i:]

def before_and_after(x,i):
	'''Split a list into three parts: everything before index i, at i, and all after it
	
	>>> before_and_after('Fred was here',4)
	('Fred', ' ', 'was here')
	'''
	a, b = before(x,i)
	c, d = before(b,1)
	return a, c, d

def befores_and_afters(x):
	'''A generator giving before and after for each item in a list

	>>> for x in befores_and_afters('Fred'): print x
	('', 'F', 'red')
	('F', 'r', 'ed')
	('Fr', 'e', 'd')
	('Fre', 'd', '')
	'''
	for i in range(0,len(x)):
		yield before_and_after(x,i)


def head_rest(x):
	'''Return the head and the rest of a list

	>>> head,rest = head_rest([23,45,67,99,45])
	>>> head
	23
	>>> rest
	[45, 67, 99, 45]
	'''
	a, b = before(x,1)
	return a[0], b
