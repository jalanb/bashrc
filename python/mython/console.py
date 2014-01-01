"""Provide a console in which to run Python commands"""


import os
import sys
import pprint
import atexit
import keyword
import optparse
import commands
import readline
import rlcompleter
from code import InteractiveConsole


import colours


def from_string_as_list(from_string):
	"""Convert as list of from names to a list"""
	if not from_string:
		return []
	assert '_AS_' not in from_string
	string = from_string.replace(' as ','_AS_')
	words = string.split()
	result = []
	for word in words:
		if '_AS_' in word:
			result.append(tuple(word.split('_AS_')))
		else:
			result.append(word)
	return result


def show_import(symbols, name, from_string=None):
	"""import the named module into the given symbols dictionary"""
	try:
		fromlist = from_string_as_list(from_string)
		module = __import__(name, fromlist=fromlist)
		if fromlist:
			loaded_items = []
			for name in fromlist:
				try:
					name, alias = name
					loaded_items.append('%s as %s' % (name, alias))
				except ValueError:
					alias = name
					loaded_items.append(name)
				item = getattr(module, name)
				symbols[alias] = item
			prefix = 'from %s import ' % module.__file__
			indent = len(prefix)
			width = commands.getoutput('tput cols')
			string_items = ', '.join(loaded_items)
			suffix = pprint.pformat(string_items, indent=indent, width=width)
			tell_user('%s %s' % (prefix, suffix))
		else:
			symbols[name] = module
			try:
				out = module.__file__
			except AttributeError:
				out = name
			tell_user('import', out)
	except ImportError:
		tell_user('Failed to import', name)


def complete_python():
	def path_to_history_file():
		return '%s.history' % os.path.splitext(os.path.realpath(__file__))[0]
	readline.parse_and_bind("tab: complete")
	if not os.path.isfile(path_to_history_file()):
		file(path_to_history_file(), 'w').close()
	readline.read_history_file(path_to_history_file())
	atexit.register(readline.write_history_file, path_to_history_file())
	unlimited_history = -1
	readline.set_history_length(unlimited_history)


def show_imports(symbols):
	print
	show_import(symbols, 'sys')
	tell_user('sys.path:', [p for p in sys.path if not p.startswith('%s/lib' % sys.prefix)])
	show_import(symbols, 'os')
	show_import(symbols, 'environ')
	show_import(symbols, 'paths')
	show_import(symbols, 'see', 'see see_methods see_attributes spread')
	show_import(symbols, 'see_code', 'code highlight')
	print


def prettify(symbols):
	show_import(symbols, 'pprint', 'pprint as show')
	show_import(symbols, 'colours')
	sys.ps1 = colours.prompt_text('>>> ', 'green')
	sys.ps2 = colours.prompt_text('... ', 'light green')
	sys.displayhook = pprint.pprint


def editor():
	return os.environ.get('EDITOR', 'vim')


def edit_temporary_text(text):
	from tempfile import NamedTemporaryFile
	with NamedTemporaryFile(suffix='.py') as temporary_file:
		temporary_file.write(text)
		temporary_file.flush()
		command = '%s %s' % (editor(), temporary_file.name)
		os.system(command)
		with file(temporary_file.name) as text_file:
			return text_file.read()


def verbose():
	return False


def tell_user(*args):
	if not verbose():
		return
	message = ' '.join([str(arg) for arg in args])
	print colours.colour_text(message, 'gray')


class Mython(InteractiveConsole):

	def runsource(self, source, *args):
		self.old_source = source.encode('latin-1')
		return InteractiveConsole.runsource(self, source, *args)

	def raw_input(self, *args):
		line = InteractiveConsole.raw_input(self, *args)
		if not line:
			return line
		if line == 'q':
			sys.exit(0)
		if line == 'e':
			text = edit_temporary_text(self.old_source)
			readline.replace_history_item(readline.get_current_history_length() - 1, text)
			return text
		words = line.split()
		first_word, more_words = words[0], words[1:]
		if keyword.iskeyword(first_word):
			tell_user('%r is a keyword' % first_word)
			return line
		if first_word in self.locals:
			if '(' in line:
				tell_user('Looks like a method call')
			else:
				first_thing = self.locals[first_word]
				if callable(first_thing):
					line = '%s(%s)' % (first_word, ', '.join(more_words))
					tell_user('Looks like a method call without brackets')
					tell_user('change to %r' % line)
				else:
					tell_user('%r is not callable' % first_word)
		else:
			tell_user('%r is unknown' % first_word)
		tell_user('Run: %r' % line)
		return line


def handle_command_line():
	parser = optparse.OptionParser()
	parser.add_option('-v', '--verbose', action='store_true')
	options, args = parser.parse_args()
	if options.verbose:
		global verbose
		verbose = lambda: True


def run(symbols):
	print
	while True:
		console = Mython(locals=symbols)
		try:
			if console.interact() is None:
				return
		except (SystemExit, KeyboardInterrupt):
			raise


def main(symbols):
	handle_command_line()
	show_imports(symbols)
	complete_python()
	prettify(symbols)
	return run(symbols)
