'''
Convenience methods for populating an OptionPraser

	>>> import argv
	>>> my_opts = ( [
	...	 ('exit','stop this nonsense'),
	...	 ('save','backups are fun',False),
	...	 ('name','who am i','Fred','f'),
	... ] )

	>>> my_parser = argv.make_parser( my_opts )
That's an optparse.OptParser,
	which handles command line options and args

More commonly:
	>>> argv.add(my_opts)
	>>> options, args = option_parser.parse_args(command_line='-s crash.log'])
	>>> print options.__dict__
	{'save': True, 'exit': '', 'name': 'Fred'}
	>>> print args
	['crash.log']

See argv.test* for more

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

def make_argv_option(long_name,help,default,short=None,action=None):
	'''Return an optparse option
	
	Short name defaulted to long name's initial.
	Action defaults to default_action()
	'''
	if not short:
		short = long_name[0]
	action = default_action(default,action)
	return ordered_option((short,long_name,action,help,default))

def default_action(default,action=None):
	'''Default action for that type of default'''
	if action: return action
	if type(default) == type(True):
		if default:
			return 'store_false'
		return'store_true'
	return 'store'

def as_five_tuple(tupel):
	'''Convert the tuple to a 4 tuple.

	Add a default "" to a 2-tuple
	Then add a short name to a 3-tuple
	Any other n-tuple
		 raise Value Erro
	'''
	action = None
	if len(tupel) == 5:
		long, help, default, short, action = tupel
	elif len(tupel) == 4:
		long, help, default, short = tupel
	elif len(tupel) == 3:
		long, help, default = tupel
		short = long[0]
	elif len(tupel) == 2:
		long, help = tupel
		short = long[0]
		default = ''
	else:
		raise ValueError('Use 2, 3, 4 or 5 arguments, not %r' % tupel)
	return long, help, default, short, default_action(default,action)

def listize(method):
	'''Return a method which converts a list of tuples to a list of options.

	Using method(tuple) for each onversion
	'''
	def to_options(tuples):
		options = []
		for tupel in tuples:
			long, help, default, short, action = as_five_tuple(tupel)
			options += [ method(long, help, default, short, action) ]
		return options
	return to_options

make_argv_options = listize(make_argv_option)

def options_to_parser(options):
	'''Make an OptionParser from a list of options'''
	return OptionParser(option_list=options)

added_args = []
def add(args):
	added_args[:0] = args

def make_parser(args=None):
	'''Make an OptionParser from a list of tuples

	tuples can have
		2 values: a string defaulting to ""
		3 values: name, help, default
		4 values: name, help, default, short name
		5 values: name, help, default, short name, action
	'''
	options = []
	if not args: args = []
	tuples = args + added_args
	for tupel in tuples:
		try: five_tuple = as_five_tuple(tupel)
		except: raise ValueError(repr(tupel))
		options += [ make_argv_option(*five_tuple) ]
	return options_to_parser(options)

options = None
args = None
post_parses = []

def parse_args(command_line=None):
	'''Use options are made from a list of tuples

	The list used is: those as args here, and any sent in to add() earlier

	tuples can have
		2 values: a string defaulting to ""
		3 values: name, help, default
		4 values: name, help, default, short name
		5 values: name, help, default, short name, action
	Type of the default sets the type of option
		It also sets the action (unless supplied)
	'''
	option_parser = make_parser()
	global options
	global args
	if command_line:
		try: command_line = command_line.split()
		except AttributeError: pass
		options, args = option_parser.parse_args(command_line)
	else:
		options, args = option_parser.parse_args()
	for post_parse in post_parses:
		options, args = post_parse(options,args)
	return options, args

def test_args(command_line=None):
	option_parser = make_parser()
	global options
	global args
	if command_line is None:
		command_line = '-h'
	if command_line:
		try: command_line = command_line.split()
		except AttributeError: pass
		if '-h' in command_line:
			command_line.remove('-h')
			option_parser.print_help()
		options, args = option_parser.parse_args(command_line)
	else:
		options, args = option_parser.parse_args()
	for post_parse in post_parses:
		options, args = post_parse(options,args)
