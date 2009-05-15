'''
Convenience methods for populating an OptionPraser

	>>> import options
	>>> option_parser = options.tuples_to_parser( [
	...	 ('exit','stop this nonsense'),
	...	 ('save','backups are fun',False),
	...	 ('name','who am i','Fred','f'),
	... ] )

That's an optparse.OptParser,
	which handles command line options and args

	>>> options, args = option_parser.parse_args(['-s','crash.log'])
	>>> print options.__dict__
	{'save': True, 'exit': '', 'name': 'Fred'}
	>>> print args
	['crash.log']

See options.test* for more

'''
from optparse import make_option, OptionParser

def ordered_option(option_arguments):
	'''Make an option that can be passed to OptionParser.__init__()

	option_arguments is a tuple with values in this order
		short name (The '-' will be added)
		long name (The '--' will be added)
		action
		help
		default
	All values, in that order, must be given

	dest will be set == long name
	'''
	return make_option(
		'-%s' % option_arguments[0],
		'--%s' % option_arguments[1],
		dest = option_arguments[1],
		action = option_arguments[2],
		help = option_arguments[3],
		default = option_arguments[4]
	)

def letter_boolean_option(long_name,help,default,short_name):
	'''Make a boolean option that can be passed to OptionParser.__init__()'''
	action = 'store_true'
	if default:
		action = 'store_false'
	return ordered_option((short_name,long_name,action,help,default))

def letter_string_option(long_name,help,default,short_name):
	'''Make a string option that can be passed to OptionParser.__init__()'''
	return ordered_option((short_name,long_name,'store',help,default))

def initialise(option_method):
	'''Return the same method, with short name defaulted to long name's initial'''
	def freddy(long_name,help,default):
		return option_method(long_name,help,default,long_name[0])
	return freddy

string_option = initialise(letter_string_option)
boolean_option = initialise(letter_boolean_option)

def as_four_tuple(tupel):
	'''Convert the tuple to a 4 tuple.

	Add a default "" to a 2-tuple
	Then add a short name to a 3-tuple
	Any other n-tuple
		 raise Value Erro
	'''
	if len(tupel) == 4:
		long, help, default, short = tupel
	elif len(tupel) == 3:
		long, help, default = tupel
		short = long[0]
	elif len(tupel) == 2:
		long, help = tupel
		short = long[0]
		default = ''
	else:
		raise ValueError('Use 2, 3, or 4 arguments, not %r' % tupel)
	return long, help, default, short

def listize(method):
	'''Return a method which converts a list of tuples to a list of options.

	Using method(tuple) for each onversion
	'''
	def to_options(tuples):
		options = []
		for tupel in tuples:
			long, help, default, short = as_four_tuple(tupel)
			options += [ method(long, help, default, short) ]
		return options
	return to_options

strings = listize(letter_string_option)
booleans = listize(letter_boolean_option)

def options_to_parser(options):
	'''Make an OptionParser from a list of options'''
	return OptionParser(option_list=options)

def tuples_to_parser(tuples):
	'''Make an OptionParser from a list of tuples'''
	options = []
	for tupel in tuples:
		tupel = as_four_tuple(tupel)
		for t in tupel:
			if type(t) == type(True):
				options += [ letter_boolean_option(tupel[0],tupel[1],tupel[2],tupel[3]) ]
				break
		else:
			options += [ letter_string_option(tupel[0],tupel[1],tupel[2],tupel[3]) ]
	return options_to_parser(options)

options = None
args = None

def run(tuples,post_parse=None):
	option_parser = tuples_to_parser(tuples)
	global options
	global args
	options, args = option_parser.parse_args()
	if post_parse:
		options, args = post_parse(options,args)

def test(command_line,tuples,post_parse=None):
	option_parser = tuples_to_parser(tuples)
	global options
	global args
	options, args = option_parser.parse_args(command_line.split())
	if post_parse:
		options, args = post_parse(options,args)
