'''
Convenience methods for populating an OptionPraser

	>>> import argv
	>>> my_opts = ( [
	...	 ('exit','stop this nonsense'),
	...	 ('save','backups are fun',False),
	...	 ('name','who am i','Fred','f'),
	... ] )

	>>> my_parser = argv._make_parser( my_opts )

That's an optparse.OptParser,
	which handles command line options and args

More commonly:
	>>> argv.add_options(my_opts)
	>>> options, args = argv.parse_args(command_line='-s crash.log')
	>>> print options.__dict__
	{'save': True, 'exit': '', 'name': 'Fred'}
	>>> print args
	['crash.log']

See argv.test* for more

'''

_ordered_options = []
def _ordered_option(option_arguments):
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
	from optparse import make_option
	_ordered_options.append(option_arguments[1])
	return make_option(
		'-%s' % option_arguments[0],
		'--%s' % option_arguments[1],
		dest = option_arguments[1],
		action = option_arguments[2],
		help = option_arguments[3],
		default = option_arguments[4]
	)

def _make_argv_option(long_name,help,default,short=None,action=None):
	'''Return an optparse option
	
	Short name defaulted to long name's initial.
	Action defaults to _default_action()
	'''
	if not short:
		short = long_name[0]
	action = _default_action(default,action)
	return _ordered_option((short,long_name,action,help,default))

def _default_action(default,action=None):
	'''Default action for that type of default'''
	if action: return action
	if type(default) == type(True):
		if default:
			return 'store_false'
		return'store_true'
	return 'store'

def _as_five_tuple(tupel):
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
	return long, help, default, short, _default_action(default,action)

def _listize(method):
	'''Return a method which converts a list of tuples to a list of options.

	Using method(tuple) for each onversion
	'''
	def to_options(tuples):
		options = []
		for tupel in tuples:
			long, help, default, short, action = _as_five_tuple(tupel)
			options += [ method(long, help, default, short, action) ]
		return options
	return to_options

_make_argv_options = _listize(_make_argv_option)

def _options_to_parser(options):
	'''Make an OptionParser from a list of options'''
	from optparse import OptionParser
	return OptionParser(option_list=options,conflict_handler="resolve")

_added_tuples = []
def add_options(options):
	'''Add a list of tuples to be used as options
	
	tuples can have
		2 values: a string defaulting to ""
		3 values: name, help, default
		4 values: name, help, default, short name
		5 values: name, help, default, short name, action
	Type of the default sets the type of option
		It also sets the action (unless supplied)
	'''
	_added_tuples[:0] = options

def _make_parser(tuples=None):
	'''Make an OptionParser from a list of all_tuples

	all_tuples can have
		2 values: a string defaulting to ""
		3 values: name, help, default
		4 values: name, help, default, short name
		5 values: name, help, default, short name, action
	'''
	options = []
	if tuples is None: tuples = []
	for tupl in tuples + _added_tuples:
		try:
			five_tuple = _as_five_tuple(tupl)
			options += [ _make_argv_option(*five_tuple) ]
		except:
			raise ValueError(repr(tupl))
	return _options_to_parser(options)

options = None
args = None
directories = []
first_directory = None
files = []
post_parses = []
methods = []

def reset():
	'''Reset the module variables back to empty values'''
	global options
	options = None
	global args
	args = None
	global _added_tuples
	_added_tuples = []
	global post_parses
	post_parses = []

def parse_args(command_line=None):
	'''Parse a command line using options added eralier

	The options were sent in to add_options() earlier

	'''
	option_parser = _make_parser()
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
	_find_files_in_args(args)
	return options, args

def _find_files_in_args(args):
	global files
	global directories
	global first_directory
	import paths
	directories, files, _ = paths.split_directories_files(args)
	first_directory = directories and directories[0] or paths.makepath('.')

def test_args(command_line=None):
	'''Convenience method for testing prse_args

	It does not sys.exit() if the command line includes "-h"
	'''
	option_parser = _make_parser()
	global options
	global args
	if command_line is None:
		command_line = '-h'
	if command_line == '':
		import sys
		command_line = sys.argv[0]
	if command_line:
		try: command_line = command_line.split()
		except AttributeError: pass
		try: options, args = option_parser.parse_args(command_line)
		except SystemExit:
			if _added_tuples: options, args = option_parser.parse_args()
			return
	else:
		options, args = option_parser.parse_args()
	for post_parse in post_parses:
		options, args = post_parse(options,args)
	_find_files_in_args(args)

def main(main_method,ctrl_c = None,no_args = False):
	'''Treat method as a typical main()

	Calls the method, then sends its return value to sys.exit()
	If ctrl_c is not None, then catch KeyboardInterrupts and exit gracefully
		ctrl_c might be a string, which is sent to stderr
	Set no_args to True to stop parsing of command line args
	'''
	if type(main_method) == type(main):
		Globals = main_method.func_globals
	else:
		raise RuntimeError('%s is not a method' % main_method)
	if not no_args:
		parse_args()
	global methods
	methods = []
	for name in _ordered_options:
		try:
			Global = Globals[name]
			if callable(Global) and getattr(options, name):
				methods.append(Global)
		except KeyError: pass
	import sys
	if ctrl_c is not None:
		if ctrl_c in [ True, '' ]:
			ctrl_c = ' Exitting ^c'
		try:
			return_value = main_method()
		except KeyboardInterrupt:
			print >> sys.stderr, ctrl_c
			return_value = 1
	else:
		return_value = main_method()
	sys.exit(return_value)

