def before(x,i):
	return  x[:i], x[i:]

def before_and_after(x,i):
	a, b = before(x,i)
	c, d = before(b,1)
	return a, c, d

def befores_and_afters(x):
	for i in range(0,len(x)):
		yield before_and_after(x,i)


def take_first(things):
	return before_and_after(things,0)

def take_next(before,item,after):
	return before + item, after[:1], after[1:]

def take(a,b=None,c=None):
	if b is None:
		return take_first(a)
	else:
		return take_next(a,b,c)

def head_rest(x):
	a, b = before(x,1)
	return a[0], b
