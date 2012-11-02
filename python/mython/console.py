"""Provide a console in which to run Python commands"""


import os
import sys
import atexit
import rlcompleter
import readline
from code import InteractiveConsole
from pprint import pprint


import colours


def show_import(symbols, name, fromlist=None):
	"""import the named module into the given symbols dictionary"""
	try:
		module = __import__(name, fromlist=fromlist or [])
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
			print 'from', module.__file__, 'import', ', '.join(loaded_items)
		else:
			symbols[name] = module
			try:
				out = module.__file__
			except AttributeError:
				out = name
			print 'import', out
	except ImportError:
		print 'Failed to import', name


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
	print 'sys.path:', [p for p in sys.path if not p.startswith('%s/lib' % sys.prefix)]
	show_import(symbols, 'os')
	show_import(symbols, 'environ')
	show_import(symbols, 'paths')
	show_import(symbols, 'see', ['see', 'see_methods', 'see_attributes', 'spread'])
	show_import(symbols, 'see_code', ['highlight_method'])
	print


def prettify(symbols):
	show_import(symbols, 'pprint', [('pprint', 'show')])
	show_import(symbols, 'colours')
	sys.ps1 = colours.prompt_text('>>> ', 'green')
	sys.ps2 = colours.prompt_text('... ', 'light green')
	sys.displayhook = pprint


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


class Mython(InteractiveConsole):

	def runsource(self, source, *args):
		self.old_source = source.encode('latin-1')
		return InteractiveConsole.runsource(self, source, *args)

	def raw_input(self, *args):
		line = InteractiveConsole.raw_input(self, *args)
		if line == 'q':
			sys.exit(0)
		if line == 'e':
			text = edit_temporary_text(self.old_source)
			readline.replace_history_item(readline.get_current_history_length() - 1, text)
			return text
		return line


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
	show_imports(symbols)
	complete_python()
	prettify(symbols)
	return run(symbols)
