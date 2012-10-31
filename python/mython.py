"""Dirty up the main namespace with some extra imports"""



# Too many dynamic items here to take E0602 (undefined variable) seriously
# and pylint is no good at recognising methods in methods when counting branches - R0912
# pylint: disable-msg=E0602, R0912


def _make_console():

	def show_import(name, fromlist=None):
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
					globals()[alias] = item
				print 'from', module.__file__, 'import', ', '.join(loaded_items)
			else:
				globals()[name] = module
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
		show_import('readline')
		show_import('rlcompleter')
		show_import('atexit')
		if 'libedit' in readline.__doc__:
			readline.parse_and_bind("bind ^I rl_complete")
		else:
			readline.parse_and_bind("tab: complete")
		if not os.path.isfile(path_to_history_file()):
			file(path_to_history_file(), 'w').close()
		readline.read_history_file(path_to_history_file())
		atexit.register(readline.write_history_file, path_to_history_file())
		unlimited_history = -1
		readline.set_history_length(unlimited_history)


	def show_imports():
		print
		show_import('sys')
		print 'sys.path:', [p for p in sys.path if not p.startswith('%s/lib' % sys.prefix)]
		show_import('os')
		show_import('environ')
		show_import('paths')
		show_import('see', ['see', 'see_methods', 'see_attributes', 'spread'])
		show_import('see_code', ['highlight_method'])
		print

	def prettify():
		show_import('pprint', [('pprint', 'show')])
		show_import('colours')
		sys.ps1 = colours.colour_text('>>> ', 'green')
		sys.ps2 = colours.colour_text('... ', 'light green')
		sys.displayhook = show


	from code import InteractiveConsole

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

	def main():
		print
		while True:
			console = Mython(locals=globals())
			try:
				if console.interact() is None:
					return
			except (SystemExit, KeyboardInterrupt):
				raise

	show_imports()
	complete_python()
	prettify()
	main()

_make_console()
